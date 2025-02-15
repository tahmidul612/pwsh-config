function LoadStep([string] $Description, [ScriptBlock]$script) {
    Write-Host  -NoNewline "Loading " $Description.PadRight(20)
    & $script
    Write-Host "`u{2705}" # checkmark emoji
}

[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

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
    Import-Module gsudoModule
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

# Function to check winget and scoop for updates
function update-check {
    $ErrorActionPreference_bak = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    Write-Host       "Checking for updates..." -ForegroundColor Gray -NoNewline
    Invoke-Expression "winget update *>&1" -OutVariable winget | Out-Null
    Invoke-Expression "scoop update *>&1" | Out-Null
    Invoke-Expression "scoop status *>&1" -OutVariable scoop | Out-Null
    if (($winget -like "*No installed package found matching input criteria.*") -and ($scoop -like "*Everything is ok!*")) {
        Write-Host "`rNo updates available   " -ForegroundColor Green
    }
    else {
        Write-Host "`rUpdates available      " -ForegroundColor Yellow
        Write-Host "Run 'update-all' to update all packages" -ForegroundColor Gray
    }
    $ErrorActionPreference = $ErrorActionPreference_bak
}

# Run update-check on a daily basis
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