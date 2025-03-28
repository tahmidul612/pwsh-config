# Setup Powershell

- [Powershell Preview](#powershell-preview)
- [Scoop](#scoop)
- [Git](#git)
- [Nerd Font](#nerd-font)
- [Update Default Shell](#update-default-shell)
- [Configure Terminal](#configure-terminal)
- [oh-my-posh](#oh-my-posh)
- [Optional Modifications](#optional-modifications)
  - [Gsudo modifications](#gsudo-modifications)
  - [Enable daily update check](#enable-daily-update-check)
  - [Windows Security Exclusion](#windows-security-exclusion)
  - [Path Substitution Fix](#path-substitution-fix)
  - [Faster Terminal-Icons](#faster-terminal-icons)
  - [Update Plex mpv](#update-plex-mpv)

<!--start-->
## Powershell Preview

Install powershell preview with winget

> Update `app installer` from Microsoft store if the install command does not work

```console
winget install --id Microsoft.Powershell.Preview --source winget
```

## [Scoop](https://scoop.sh/)

Scoop is a package manager for Windows. It installs packages only for the current user (does not need admin privileges) and adds command line alias for the package when needed. The terminal does not have to be restarted to use the alias.

> Run these commands in a non-elevated powershell/terminal (regular powershell without admin privileges)

```console
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex
```

## Git

Install git (required for some scoop commands)

> For a full git setup follow [git-config](https://gist.github.com/tahmidul612/b0aa70aaf128309a0c156cd2dcf6d4bb)

```console
winget install git.git
```

## Nerd Font

Install FiraCode Nerd Font with scoop

```console
scoop bucket add nerd-fonts
scoop install FiraCode-NF-Mono
```

## Update Default Shell

- Restart terminal
- Open terminal settings
- Change `Default profile` from `Windows Powershell` to `Powershell`

> You default profile may be different, change it to `Powershell` or `Powershell Preview`

## Configure Terminal

- Open terminal settings
- Open JSON File
- Copy and paste this [Night Owl Theme](https://github.com/edurojasr/Windows-Terminal-Night-Owl-Theme/blob/master/schemes.json) into the schemes section
- Navigate to the `Powershell` profile
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

### Gsudo modifications

- Allow gsudo to cache credentials

  > <https://gerardog.github.io/gsudo/docs/credentials-cache>

  ```console
  gsudo config CacheMode auto
  ```

- Make gsudo the default sudo command (overwriting windows built in sudo)

  > <https://gerardog.github.io/gsudo/docs/gsudo-vs-sudo#what-if-i-install-both>

  ```console
  gsudo config PathPrecedence true
  ```

### Enable daily update check

The provided profile has a function to check winget and scoop for updates once every day. This can be enable by uncommenting [line 81](https://github.com/tahmidul612/pwsh-config/blob/32e2c4137d2ea5b4fe108536e11dba3c5d92d636/profile.ps1#L81) in the profile.ps1 file
> Update check can be skipped by Ctrl+C, it will not check again that day

### Windows Security Exclusion

> Check <https://ohmyposh.dev/docs/faq#the-prompt-is-slow-delay-in-showing-the-prompt-between-commands> for more information

Security scans may be slowing down oh-my-posh, add oh-my-posh executable to Windows Defender exclusion list (or the exclusion list for you antivirus)

> OMP Executable location

```console
(Get-Command oh-my-posh).Source
```

Adding entire the scoop directory, or possibly just the modules directory to the exclusion list may also help

> Scoop directory location

```console
echo $env:USERPROFILE\scoop
```

### Path Substitution Fix

Using `$env:POSH_THEMES_PATH` in the profile.ps1 file may cause a delay in loading the profile. This is a fix for that:

```console
(Get-Content -Path $PROFILE).Replace('$env:POSH_THEMES_PATH', "$($env:POSH_THEMES_PATH)") | Set-Content $PROFILE
```

> Replaces the environment variable with the absolute path

### [Faster Terminal-Icons](./mods/faster-terminal-icons.md)

> Check <https://github.com/devblackops/Terminal-Icons/issues/76> for more information

The terminal-icons module can take a while to load. This is a guide to modify the module to make it load 3x+ faster

### Update Plex mpv

> [!TIP]
> You can also follow the guide in my gist [Config Plex](https://gist.github.com/tahmidul612/4e1fdfc60bc39112fdd237cacb26cb56) to configure mpv for plex

Install/update plex htpc from <https://plex.tv>

- To directly run the remote script, run this in powershell

```console
irm https://raw.github.com/tahmidul612/pwsh-config/raw/master/mods/update-plex-mpv.ps1 | gsudo iex
```

- If you have the `pwsh-config` repo cloned, you can run the script from the local directory

```console
gsudo mods/update-plex-mpv.ps1
```

<!--end-->
