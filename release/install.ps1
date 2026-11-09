# Installs this unofficial WestPlay build over an installed WestPlay 2.2.2, after backing up the original.
#   install.cmd           install (or update to a newer build of this)
#   restore.cmd           put the original WestPlay back
#   install.ps1 -Check    only say where WestPlay and the game plugins are, change nothing
param([switch]$Restore, [switch]$Check)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$backup = Join-Path $env:LOCALAPPDATA 'WestPlay-original-backup'

function Find-WestPlay {
    $candidates = @()
    foreach ($key in 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                     'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                     'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*') {
        Get-ItemProperty $key -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like 'WestPlay*' } | ForEach-Object {
            if ($_.InstallLocation) { $candidates += $_.InstallLocation.Trim('"') }
            if ($_.DisplayIcon) { $candidates += (Split-Path -Parent $_.DisplayIcon.Trim('"').Split(',')[0]) }
        }
    }
    $candidates += Join-Path $env:LOCALAPPDATA 'WestPlay'
    $candidates += Get-ChildItem (Join-Path $env:LOCALAPPDATA 'Packages') -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { Join-Path $_.FullName 'LocalCache\Local\WestPlay' }
    foreach ($dir in $candidates) {
        if ($dir -and (Test-Path (Join-Path $dir 'westplay.exe'))) { return (Resolve-Path $dir).Path }
    }
    return $null
}

function Find-Plugins {
    # WestPlay's game plugin, in each game it's installed in (ATS and/or ETS2, in any Steam library).
    $steam = (Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
    $libraries = @()
    if ($steam) {
        $libraries += $steam
        $vdf = Join-Path $steam 'steamapps\libraryfolders.vdf'
        if (Test-Path $vdf) {
            Select-String -Path $vdf -Pattern '"path"\s+"([^"]+)"' | ForEach-Object {
                $libraries += $_.Matches[0].Groups[1].Value.Replace('\\', '\')
            }
        }
    }
    $found = @()
    foreach ($library in ($libraries | Select-Object -Unique)) {
        foreach ($game in 'American Truck Simulator', 'Euro Truck Simulator 2') {
            $dll = Join-Path $library "steamapps\common\$game\bin\win_x64\plugins\westplay.dll"
            if (Test-Path $dll) { $found += $dll }
        }
    }
    # Steam names its own folder in two spellings: one each (PowerShell's sort is case-blind).
    return @($found | Sort-Object -Unique)
}

if ($Check) {
    Write-Host "WestPlay: $(Find-WestPlay)"
    Find-Plugins | ForEach-Object { Write-Host "Game plugin: $_" }
    return
}

$running = Get-Process -Name westplay, amtrucks, eurotrucks2 -ErrorAction SilentlyContinue
if ($running) {
    throw "Please close WestPlay and the game first (still running: $(($running.Name | Select-Object -Unique) -join ', ')). WestPlay may be in the tray by the clock: right-click it, Quit."
}

$app = Find-WestPlay
if (-not $app) { throw 'WestPlay is not installed here. Install the official WestPlay 2.2.2 first, set it up once, then run this again.' }
$plugins = Find-Plugins
Write-Host "WestPlay found in: $app"
$plugins | ForEach-Object { Write-Host "Game plugin found: $_" }

if ($Restore) {
    if (-not (Test-Path (Join-Path $backup 'app\westplay.exe'))) { throw "No backup of the original WestPlay found in $backup." }
    Copy-Item (Join-Path $backup 'app\westplay.exe'), (Join-Path $backup 'app\westplay.dll'), (Join-Path $backup 'app\westplay-maps.exe') $app -Force
    Remove-Item (Join-Path $app 'ui') -Recurse -Force
    Copy-Item (Join-Path $backup 'app\ui') (Join-Path $app 'ui') -Recurse
    foreach ($dll in $plugins) { Copy-Item (Join-Path $backup 'app\westplay.dll') $dll -Force }
    Write-Host ''
    Write-Host 'The original WestPlay is back. Open WestPlay, then the game.'
    return
}

foreach ($file in 'westplay.exe', 'westplay.dll', 'westplay-maps.exe', 'ui\cabin.html') {
    if (-not (Test-Path (Join-Path $here $file))) { throw "This folder is missing $($file): unzip the whole download first, then run install.cmd from inside it." }
}

# The original, backed up once (installing a newer build of this later keeps that first backup).
if (-not (Test-Path (Join-Path $backup 'app\westplay.exe'))) {
    New-Item -ItemType Directory (Join-Path $backup 'app') -Force | Out-Null
    Copy-Item (Join-Path $app 'westplay.exe'), (Join-Path $app 'westplay.dll'), (Join-Path $app 'westplay-maps.exe') (Join-Path $backup 'app')
    Copy-Item (Join-Path $app 'ui') (Join-Path $backup 'app\ui') -Recurse
    Write-Host "Original WestPlay backed up to: $backup"
}

Copy-Item (Join-Path $here 'westplay.exe'), (Join-Path $here 'westplay.dll'), (Join-Path $here 'westplay-maps.exe') $app -Force
Remove-Item (Join-Path $app 'ui') -Recurse -Force
Copy-Item (Join-Path $here 'ui') (Join-Path $app 'ui') -Recurse
foreach ($dll in $plugins) { Copy-Item (Join-Path $here 'westplay.dll') $dll -Force }

# The examples for your own screens and looks, in Documents\WestPlay (never over your own files).
$documents = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'WestPlay'
New-Item -ItemType Directory (Join-Path $documents 'styles\examples') -Force | Out-Null
if (-not (Test-Path (Join-Path $documents 'screens.txt'))) { Copy-Item (Join-Path $here 'screens.txt') $documents }
Copy-Item (Join-Path $here 'styles-examples\*') (Join-Path $documents 'styles\examples') -Force

Write-Host ''
Write-Host 'Installed. Open WestPlay (it updates its mod for the game), then start the game.'
Write-Host 'Your own screen shapes: Documents\WestPlay\screens.txt. Your own looks: Documents\WestPlay\styles (see styles\examples).'
