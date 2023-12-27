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
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\multiverse-neon.omp.json" | Invoke-Expression
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