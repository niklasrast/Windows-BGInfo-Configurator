<#
    .SYNOPSIS 
    Windows 10 

    .DESCRIPTION
    Install:   PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-Sysinternals-BGINFO.ps1 -install
    Uninstall:   PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-Sysinternals-BGINFO.ps1 -uninstall

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

$ErrorActionPreference = "SilentlyContinue"
#Use "C:\Windows\Logs" for System Installs and "$env:TEMP" for User Installs
$logFile = ('{0}\{1}.log' -f "C:\Windows\Logs", [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))

#Test if registry folder exists
if ($true -ne (test-Path -Path "HKLM:\SOFTWARE\OS")) {
    New-Item -Path "HKLM:\SOFTWARE\" -Name "OS" -Force
}

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
            
            #Register package in registry
            New-Item -Path "HKLM:\SOFTWARE\OS\" -Name "Sysinternals-BGINFO"
            New-ItemProperty -Path "HKLM:\SOFTWARE\OS\Sysinternals-BGINFO" -Name "Version" -PropertyType "String" -Value "1.0.0" -Force
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
            
            #Remove package registration in registry
            Remove-Item -Path "HKLM:\SOFTWARE\OS\Sysinternals-BGINFO" -Recurse -Force 
        }
        catch
        {
            $PSCmdlet.WriteError($_)
        }
    Stop-Transcript
}