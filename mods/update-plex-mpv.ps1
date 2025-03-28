function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Relaunch as Admin if not already elevated
if (-not (Test-Admin)) {
    Write-Host "Restarting script as Administrator..."
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Step 1: Get the latest release info
$latestReleaseUrl = "https://api.github.com/repos/mitzsch/mpv-winbuild/releases/latest"
$latestRelease = Invoke-RestMethod -Uri $latestReleaseUrl
$assetsUrl = $latestRelease.assets_url

# Step 2: Get the assets list
$assets = Invoke-RestMethod -Uri $assetsUrl

# Step 3: Find the latest debug file
$devAsset = $assets | Where-Object { $_.name -match "mpv-dev-x86_64-v3-.*\.7z" } | Select-Object -First 1

if ($devAsset) {
    $downloadUrl = $devAsset.browser_download_url
    $downloadPath = Join-Path $env:TEMP $devAsset.name
    $extractPath = Join-Path $env:TEMP "mpv-extracted"
    $targetDll = "libmpv-2.dll"
    $plexPath = "C:\Program Files\Plex\Plex HTPC"

    # Step 4: Download the file
    Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath
    Write-Host "Downloaded: $downloadPath"

    # Step 5: Extract the 7z file using native Windows 24H2 support
    if (!(Test-Path $extractPath)) { New-Item -ItemType Directory -Path $extractPath | Out-Null }
    tar -xvf $downloadPath -C $extractPath

    # Step 6: Locate libmpv-2.dll
    $dllPath = Get-ChildItem -Path $extractPath -Recurse -Filter $targetDll | Select-Object -First 1

    if ($dllPath) {
        # Step 7: Move it to Plex directory, overwriting existing file
        $destinationPath = Join-Path $plexPath $targetDll
        Move-Item -Path $dllPath.FullName -Destination $destinationPath -Force
        Write-Host "Replaced $targetDll in $plexPath"
    }
    else {
        Write-Host "libmpv-2.dll not found in extracted files."
    }

    # Cleanup
    Write-Host "Cleaning up temp files.."
    Remove-Item -Path $downloadPath -Force
    Remove-Item -Path $extractPath -Recurse -Force
}
else {
    Write-Host "No matching mpv-dev file found."
}

# Pause at the end to prevent the window from closing
Write-Host "`nPress Enter to exit..."
Read-Host | Out-Null