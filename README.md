# BGInfo Configurator from Sysinternals

![GitHub repo size](https://img.shields.io/github/repo-size/niklasrast/Windows-10-BGInfo-Configurator)

![GitHub issues](https://img.shields.io/github/issues-raw/niklasrast/Windows-10-BGInfo-Configurator)

![GitHub last commit](https://img.shields.io/github/last-commit/niklasrast/Windows-10-BGInfo-Configurator)

This repo contains an powershell scripts to deploy an BGInfo configuration $PSSCRIPTROOT\BGInfo\CurrentConfig.bgi to any Windows Client. The configuration will be refreshed on every login from the users.

## Install:
```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_InstallBGInfo.ps1 -install
```

## Uninstall:
```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_InstallBGInfo.ps1 -uninstall
```

### Parameter definitions:
- -install configures CurrentConfig.bgi to run at each user login
- -uninstall removes "C:\Program Files (x86)\BGInfo", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\BginfoAutorun.lnk" and "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -String "BGInfo"
 
## Logfiles:
The scripts create a logfile with the name of the .ps1 script in the folder C:\Windows\Logs.

## Requirements:
- PowerShell 5.0
- Windows 10 or later

# Feature requests
If you have an idea for a new feature in this repo, send me an issue with the subject Feature request and write your suggestion in the text. I will then check the feature and implement it if necessary.

Created by @niklasrast 
