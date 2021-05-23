<#
    .SYNOPSIS 
    Windows 10 

    .DESCRIPTION
    Install:   PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_InstallBGInfo.ps1 -install
    Uninstall:   PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_InstallBGInfo.ps1 -uninstall

    .ENVIRONMENT
    PowerShell 5.0

    .AUTHOR
    Niklas Rast
#>

[CmdletBinding()]
param(
	[Parameter(Mandatory = $true, ParameterSetName = 'install')]
	[switch]$install,
	[Parameter(Mandatory = $true, ParameterSetName = 'uninstall')]
	[switch]$uninstall
)

$ErrorActionPreference="SilentlyContinue"
#Use "C:\Windows\Logs" for System Installs and "$env:TEMP" for User Installs
$logFile = ('{0}\{1}.log' -f "C:\Windows\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))

if ($install)
{
    Start-Transcript -path $logFile
        try
        {         
            #Copy BGInfo exe and custom design to local drive
            Copy-Item -Path "${PSScriptRoot}\BGInfo" -Destination "C:\Program Files (x86)" -Recurse -Force
            Copy-Item -Path "${PSScriptRoot}\BGInfo\BginfoAutorun.lnk" -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" -Force

            #Register BGInfo in autostart
            New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo" -PropertyType "String" -Value "C:\Program Files (x86)\BGInfo\Bginfo.exe CurrentConfig.bgi /timer:0 /nolicprompt /silent" -Force
            
            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -Name "W10_InstallBGInfo" -Force
            New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_InstallBGInfo" -Name "Version" -PropertyType "String" -Value "1.0" -Force
            New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_InstallBGInfo" -Name "Revision" -PropertyType "String" -Value "001" -Force
            New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_InstallBGInfo" -Name "LogFile" -PropertyType "String" -Value "${logFile}" -Force
        } 
        catch
        {
            $PSCmdlet.WriteError($_)
        }
    Stop-Transcript
}

if ($uninstall)
{
    Start-Transcript -path $logFile
        try
        {
            #Remove BGInfo from local drive
            Remove-Item -Path "C:\Program Files (x86)\BGInfo" -Recurse -Force
            Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\BginfoAutorun.lnk" -Force

            #Deregister BGInfo in autostart
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "BGInfo" -Force
            
            Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\W10_InstallBGInfo" -Force -Recurse
        }
        catch
        {
            $PSCmdlet.WriteError($_)
        }
    Stop-Transcript
}