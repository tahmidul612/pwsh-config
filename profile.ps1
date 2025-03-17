function LoadStep([string] $Description, [ScriptBlock]$script) {
    Write-Host  -NoNewline "Loading " $Description.PadRight(20)
    & $script
    Write-Host "`u{2705}" # checkmark emoji
}

[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

if ($env:VSCODE_INJECTION -eq "1") {
    $env:EDITOR = "code --wait"  # or 'code-insiders' for VS Code Insiders
}

Write-Host "Loading PowerShell $($PSVersionTable.PSVersion)..." -ForegroundColor 3
Write-Host

LoadStep "ZLocation" {
    Import-Module ZLocation
}

LoadStep "PSReadline" {
    Import-Module PSReadLine
}

LoadStep "PSFzf" {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}

LoadStep "Terminal-Icons" {
    Import-Module -Name Terminal-Icons
}

LoadStep "gsudo" {
     Import-Module 'gsudoModule'
}

LoadStep "Posh Theme" {
    $env:VIRTUAL_ENV_DISABLE_PROMPT = 1
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression
}
# scoop-search-multisource hook
function scoop {
    if (Get-Command scoop-search-multisource.exe -ErrorAction SilentlyContinue) {
        if ($args[0] -eq "search") {
            scoop-search-multisource.exe @($args | Select-Object -Skip 1)
        }
        else {
            scoop.ps1 @args
        }
    }
}

function update-check {
    $ErrorActionPreference_bak = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    
    Write-Host "Checking for updates...`n" -ForegroundColor Gray -NoNewline
    
    $wingetOutput = winget upgrade --include-unknown | Out-String
    Invoke-Expression "scoop update *>&1" | Out-Null
    $scoopStatus = scoop status | Out-String
    
    $wingetUpdates = @()
    $scoopUpdates = @()
    
    # Parse Winget output
    if ($wingetOutput -match "No installed package found matching input criteria") {
        $wingetUpdates = @()
    }
    else {
        $wingetOutput -split "`r?`n" | ForEach-Object {
            if ($_ -match "^(\S+)\s+(\S+)\s+->\s+(\S+)") {
                $wingetUpdates += [PSCustomObject]@{
                    Package        = $matches[1]
                    CurrentVersion = $matches[2]
                    NewVersion     = $matches[3]
                }
            }
        }
    }
    
    # Parse Scoop output
    if ($scoopStatus -notmatch "Everything is ok!") {
        $scoopStatus -split "`r?`n" | ForEach-Object {
            if ($_ -match "^(\S+).*?\((\S+) -> (\S+)\)") {
                $scoopUpdates += [PSCustomObject]@{
                    Package        = $matches[1]
                    CurrentVersion = $matches[2]
                    NewVersion     = $matches[3]
                }
            }
        }
    }
    
    if ($wingetUpdates.Count -eq 0 -and $scoopUpdates.Count -eq 0) {
        Write-Host "`rNo updates available   " -ForegroundColor Green
    }
    else {
        Write-Host "`rUpdates available:" -ForegroundColor Yellow
        
        if ($wingetUpdates.Count -gt 0) {
            Write-Host "`nWinget Updates:" -ForegroundColor Cyan
            $wingetUpdates | Format-Table -AutoSize
        }
        
        if ($scoopUpdates.Count -gt 0) {
            Write-Host "`nScoop Updates:" -ForegroundColor Magenta
            $scoopUpdates | Format-Table -AutoSize
        }
        
        Write-Host "`nRun 'update-all' to update all packages" -ForegroundColor Gray
    }
    
    $ErrorActionPreference = $ErrorActionPreference_bak
}

function DailyUpdate {
    trap { $last_date = $null }
    Invoke-Expression "(Get-ItemProperty -Path HKCU:\Environment -Name LastUpdate).LastUpdate *>&1" -OutVariable last_date | Out-Null
    $cur_date = Get-Date -Format "MM/dd/yyyy"
    if ($last_date -eq $null -or !$last_date -or $last_date -ne $cur_date) {
        Set-ItemProperty -Path HKCU:\Environment -Name LastUpdate -Value $cur_date
        update-check
    }
    else {
        Set-ItemProperty -Path HKCU:\Environment -Name LastUpdate -Value $cur_date
    }
}
# DailyUpdate

# Update all packages
function update-all {
    winget update --all;
    scoop update --all;
}

# Cleanup scoop
function scoopClean {
    scoop cleanup *;
    scoop cache rm *;
}