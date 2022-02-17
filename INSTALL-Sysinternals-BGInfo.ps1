<#
    .SYNOPSIS 
    Windows 10 Software packaging wrapper

    .DESCRIPTION
    Install:   C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-Sysinternals-BGInfo.ps1 -install
    Uninstall: C:\Windows\SysNative\WindowsPowershell\v1.0\PowerShell.exe -ExecutionPolicy Bypass -Command .\INSTALL-Sysinternals-BGInfo.ps1 -uninstall
    
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
    Start-Transcript -path $logFile -Append
        try
        {         
            #Add File or Folder
            Copy-Item -Path "$PSScriptRoot\BGInfo" -Destination "C:\ProgramData\" -Recurse -Force

            Copy-Item -Path "C:\ProgramData\BGInfo\bginfo.bat" -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" -Force

            #Register package in registry
            New-Item -Path "HKLM:\SOFTWARE\OS\" -Name "Sysinternals-BGInfo"
            New-ItemProperty -Path "HKLM:\SOFTWARE\OS\Sysinternals-BGInfo" -Name "Version" -PropertyType "String" -Value "1.0.0" -Force

            return $true        
        } 
        catch
        {
            $PSCmdlet.WriteError($_)
            return $false
        }
    Stop-Transcript
}

if ($uninstall)
{
    Start-Transcript -path $logFile -Append
        try
        {
            #Remove File or Folder
            Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\bginfo.bat" -Force
            Remove-Item -Path "C:\ProgramData\BGInfo\" -Recurse -Force

            #Remove package registration in registry
            Remove-Item -Path "HKLM:\SOFTWARE\OS\Sysinternals-BGInfo" -Recurse -Force 

            return $true     
        }
        catch
        {
            $PSCmdlet.WriteError($_)
            return $false
        }
    Stop-Transcript
}