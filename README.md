# Setup Powershell

## Powershell Preview

Install powershell preview with winget

```console
winget install --id Microsoft.Powershell.Preview --source winget
```

## Nerd Font

Install FiraCode Nerd Font with scoop

```console
scoop bucket add nerd-fonts
scoop install FiraCode-NF-Mono
```

## Configure Terminal

- Open terminal settings
- Open JSON File
- Copy and paste this [Night Owl Theme](https://github.com/edurojasr/Windows-Terminal-Night-Owl-Theme/blob/master/schemes.json) into the schemes section
- Navigate to the Powershell Preview profile
- Set the *Starting Directory*
- Navigate to **Powershell > Appearance**
- Set *Color Scheme* to Night Owl
- Change *Font Face* to FiraCode Nerd Font Mono
- Set *Padding* to 20 and *Scrollbar Visibility* to hidden

> Set *Background opacity to 90%* and enable acrylic material (optional)
>
> Open **Appearance** from the sidebar and turn on *Use acrylic material in the tab row* (optional)

## [oh-my-posh](https://ohmyposh.dev/)

Install oh-my-posh with winget

```console
winget install JanDeDobbeleer.OhMyPosh -s winget
```

Add oh-my-posh executable to Windows Defender exclusion list (or the exclusion list for you antivirus)

> Executable location

```console
(Get-Command oh-my-posh).Source
```

> Restart terminal to enable oh-my-posh command alias

Disable oh-my-posh notices

```console
oh-my-posh disable notice
```

Install and import [PSReadline](https://github.com/PowerShell/PSReadLine)

```console
Install-Module PSReadLine -AllowPrerelease -Force
Import-Module PSReadLine
```

> Importing PSReadline is required to install psfzf

Install [fzf](https://github.com/junegunn/fzf), [psfzf](https://github.com/kelleyma49/PSFzf) and [terminal-icons](https://github.com/devblackops/Terminal-Icons)

```console
scoop bucket add extras
scoop install fzf psfzf terminal-icons
```

Install [ZLocation](https://github.com/vors/ZLocation)

```console
Install-Module ZLocation -Scope CurrentUser
```

Download and copy custom profile to Powershell profile directory

> Profile copied from <https://thirty25.com/posts/2021/12/optimizing-your-powershell-load-times>

```console
iwr -uri "https://github.com/tahmidul612/pwsh-config/raw/master/profile.ps1" -outfile "$PROFILE"
```

Reload profile to enable the theme and modules

```console
. $PROFILE
```
