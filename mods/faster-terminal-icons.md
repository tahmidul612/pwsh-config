# Faster Terminal-Icons

>[Possible improvements of load time #76
](<https://github.com/devblackops/Terminal-Icons/issues/76>)

## Auto

Run this command to automatically apply the changes

```console
irm https://github.com/tahmidul612/pwsh-config/raw/master/mods/faster-terminal-icons.ps1 | iex
```

## Manual (Recommended)

> The Terminal-Icons.psm1 file is located in `Split-Path -Parent (Get-Module Terminal-Icons).Path`

Export userThemeData, colorSequences and glyphs to a xml file. This can be done by appending the following to the Terminal-Icons.psm1 file:

```powershell
$userThemeData,$colorSequences,$glyphs|Export-Clixml -Path "$moduleRoot/Data/Data.xml"
```

After appending the command to the file, import Terminal-Icons module to create the Data.xml file

```console
Import-Module Terminal-Icons
```

Replace the Terminal-Icons.psm1 file with the modified version

```console
iwr -uri "https://github.com/tahmidul612/pwsh-config/raw/master/mods/Terminal-Icons.psm1" -outfile "(Get-Module Terminal-Icons).Path"
```

> Use diff or check the [github issue](<https://github.com/devblackops/Terminal-Icons/issues/76>) for the changes made to the file
