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
>
> Install psfzf after installing fzf or the install/import may fail

Install [fzf](https://github.com/junegunn/fzf), [psfzf](https://github.com/kelleyma49/PSFzf), [terminal-icons](https://github.com/devblackops/Terminal-Icons) and [gsudo](<https://github.com/gerardog/gsudo>)

```console
scoop bucket add extras
scoop install fzf terminal-icons
scoop install psfzf
scoop install gsudo
```

Install [ZLocation](https://github.com/vors/ZLocation)

```console
Install-Module ZLocation -Scope CurrentUser
```

Install [scoop-search-multisource](https://github.com/plicit/scoop-search-multisource)
> For searching scoop directory waaaaay faster than the built in scoop search

```console
scoop install "https://raw.githubusercontent.com/plicit/scoop-search-multisource/master/scoop-search-multisource.json"
```

Download and copy custom profile to Powershell profile directory

> Profile is a modified version of <https://thirty25.com/posts/2021/12/optimizing-your-powershell-load-times>

```console
iwr -uri "https://github.com/tahmidul612/pwsh-config/raw/master/profile.ps1" -outfile "$PROFILE"
```

Reload profile to enable the theme and modules

```console
. $PROFILE
```

---

## Optional Modifications

### Windows Defender Exclusion[^1]

Defender scans may be slowing down oh-my-posh, add oh-my-posh executable to Windows Defender exclusion list (or the exclusion list for you antivirus)

> Executable location

```console
(Get-Command oh-my-posh).Source
```

### Path Substitution Fix

Using `$env:POSH_THEMES_PATH` in the profile.ps1 file may cause a delay in loading the profile. This is a fix for that:

```console
(Get-Content -Path $PROFILE).Replace('$env:POSH_THEMES_PATH', "$($env:POSH_THEMES_PATH)") | Set-Content $PROFILE
```

> Replaces the environment variable with the absolute path

### [Faster Terminal-Icons](./mods/faster-terminal-icons.md)[^2]

The terminal-icons module can take a while to load. This is a guide to modify the module to make it load 3x+ faster

[^1]: <https://ohmyposh.dev/docs/faq#the-prompt-is-slow-delay-in-showing-the-prompt-between-commands>
[^2]: <https://github.com/devblackops/Terminal-Icons/issues/76>
