# 10-functions.ps1 --- Personal function definitions
 
#  <mike@MSP-17>
# Created: October 6th, 2026
# Updated:
 
# Description:
# Define personal functions and a default prompt for powershell

# Code:

# IsWindows variable is not defined in Windows Powershell 5.x,
# so define a local variable and set it to True
if (-Not (Get-Variable IsWindows -Scope Global -ErrorAction SilentlyContinue )) {
    $IsWindows = $true
}

Function Test-Administrator() {
    if ($IsWindows) {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        $user_principal = New-Object Security.Principal.WindowsPrincipal $user
        $role_admin = [Security.Principal.WindowsBuiltinRole]::Administrator
        return $user_principal.IsInRole($role_admin)
    } else {
        return ((id -u) -eq 0)
    }
}

# Get the path variable
Function Get-PathVariable {
    $env:Path -split ';'
}

# Set the path variable
Function Set-PathVariable {
    param (
        [string]$AddPath,
        [string]$RemovePath
    )
    $regexPaths = @()
    if ($PSBoundParameters.Keys -contains 'AddPath'){
        $regexPaths += [regex]::Escape($AddPath)
    }

    if ($PSBoundParameters.Keys -contains 'RemovePath'){
        $regexPaths += [regex]::Escape($RemovePath)
    }

    $arrPath = $env:Path -split ';'
    foreach ($path in $regexPaths) {
        $arrPath = $arrPath | Where-Object {$_ -notMatch "^$path\\?"}
    }
    $env:Path = ($arrPath + $addPath) -join ';'
}

# Set the PSReadLine Colors
function Set-PSReadLineColors {
    [alias("srlc")]
    [OutputType("none")]
    Param(
        [Parameter(Position = 0, HelpMessage = "Specify if the current background is dark or light. Default background is light.")]
        [ValidateSet("Dark", "Light")]
        [string]$Background = 'Light'
    )

    if ($Background -eq 'Dark') {
        Set-PSReadLineOption -Color @{
            Command   = "Yellow"
            Number    = "White"
        }
    }
    else {
        Set-PSReadLineOption -Color @{
            Command   = "DarkYellow"
            # ContinuationPrompt = 'DarkGray'
            Default   = 'DarkGray'
            Number    = 'DarkGray'
            Type      = 'DarkGray'
        }
    }
}

# Head, display 10 lines or a number provided from the start (head) of a file.
function head {
    param (
        [string]$file,
        [int]$lines = 10
        )
    Get-Content $file -Head $lines
}

# Tail, display 10 lines or a number provided from the end (tail) of a file.  
function tail {
    param (
        [string]$file,
        [int]$lines = 10
        )
    Get-Content $file -Tail $lines
}

# take - Make a directory and change into it
function take {
    [CmdletBinding()]
    param(
	[Parameter(Mandatory = $true)]
	$path
    )
    New-Item -Path $Path -ItemType directory
    Set-Location -Path $Path
}

# Prompt - customize the powershell prompt
Function Prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    $userName = [Environment]::UserName
    $computerName = [Environment]::MachineName

    $defaultForegroundColor = 'White'
    $userForegroundColor = 'Cyan'
    $hostForegroundColor = 'Cyan'
    $pathForegroundColor = 'Yellow'
    if (Test-Administrator)
    {
        $userForegroundColor='Red'
        $hostForegroundColor='Red'
    }

    # Write the prompt using the following format:
    # username@hostname currentdir [git status]
    # > _
    #
    Write-Host($userName) -noNewLine -ForegroundColor $userForegroundColor
    Write-Host("@") -noNewLine -ForegroundColor $defaultForegroundColor
    Write-Host($computerName) -noNewLine -ForegroundColor $hostForegroundColor
    Write-Host(" in ") -nonewline -ForegroundColor $defaultForegroundColor
    Write-Host(Convert-Path(Get-Location)) -nonewline -ForegroundColor $pathForegroundColor
    if (${function:Write-VcsStatus})
    {
        Write-Host -noNewLine (Write-VcsStatus)
    }
    Write-Host("")

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "$('>' * ($nestedPromptLevel + 1)) "
}

##
# Refresh the desktop

# Define the necessary API functions for Refresh-Desktop
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Shell {
    [DllImport("Shell32.dll")]
    public static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);
}
"@

function Refresh-Desktop {
    # Call the SHChangeNotify function
    # SHCNE_ASSOCCHANGED is defined as 0x8000000
    # SHCNF_FLUSH is defined as 0x1000
    $result = [Shell]::SHChangeNotify(0x8000000, 0x1000, [IntPtr]::Zero, [IntPtr]::Zero)
}

##
# Toogle showing version information on desktop
function Toggle-DesktopVersion {
    $regKey = "hkcu:\control panel\desktop\"
    $value = [int](-not (Get-ItemPropertyValue $regKey -name PaintDesktopVersion))
    Set-ItemProperty $regKey -name PaintDesktopVersion -value $value
    Refresh-Desktop
}
