<#
.SYNOPSIS
    This script imports the Terminal-Icons module and modifies it to include a custom import command.
.DESCRIPTION
    This script imports the Terminal-Icons module and checks if it already contains a modified import command or if the Data.xml file already exists. If neither of these conditions are met, it modifies the module to include a custom import command and downloads a modified version of the module from a specified URI.
.EXAMPLE
    .\faster-terminal-icons.ps1
    This command runs the script to import and modify the Terminal-Icons module.
#>

$error.clear()
try {
    Import-Module -Name Terminal-Icons -ErrorAction Stop
}
catch {
    Write-Error "Terminal-Icons module not found."
    exit
}
if (Get-Content -Path (Get-Module Terminal-Icons).Path | Select-String -SimpleMatch 'Import-Clixml -Path "$moduleRoot/Data/Data.xml"') {
    Write-Error "Terminal-Icons module already contains modified import command"
}
if ((Test-Path -Path "$(Split-Path -Parent (Get-Module Terminal-Icons).Path)/Data/Data.xml")) {
    Write-Error "Data.xml already exists"
}
if ($error) {
    exit
}
Import-Module -Name Terminal-Icons
Write-Output ("`n" + '$userThemeData,$colorSequences,$glyphs|Export-Clixml -Path "$moduleRoot/Data/Data.xml"') | Add-Content -Path (Get-Module Terminal-Icons).Path
Import-Module -Name Terminal-Icons
Invoke-WebRequest -uri "https://github.com/tahmidul612/pwsh-config/raw/master/mods/Terminal-Icons.psm1" -outfile "(Get-Module Terminal-Icons).Path"