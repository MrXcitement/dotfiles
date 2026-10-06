# 50-modules.ps1 --- Configure powershell modules
 
# Mike Barker <mike@thebarkers.com>
# Created: October 6th, 2026
# Updated:
 
# Description:
# Configure powershell modules

# Code:

##
# Configure the posh-git module

# If git installed and posh-git module available
# Then import the posh-git module.
# https://github.com/dahlbyk/posh-git
# if ((Get-Command "git" -ErrorAction SilentlyContinue) -And
#     (Get-Module -ListAvailable -Name "Posh-Git"))
# {
#     Write-Output "Import module posh-git"
#     Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
#     Import-Module posh-git
#     Pop-Location
# }

##
# Configure the PsFzf Module

# If the fzf executable and PSFzf module are available, init the PSFzf module.
if ((Get-Command fzf -ErrorAction SilentlyContinue) -And 
    (Get-Module -ListAvailable 'PSFzf')) {
    Import-Module 'PSFzf'
    Set-PsFzfOption -TabExpansion
    Set-PsFzfOption -EnableAliasFuzzyEdit
    Set-PsFzfOption -EnableAliasFuzzyGitStatus
    Set-PsFzfOption -EnableAliasFuzzyHistory
    Set-PsFzfOption -EnableAliasFuzzyKillProcess
    Set-PsFzfOption -EnableAliasFuzzySetLocation
}

##
# Configure the PSReadLine command line editing experience
if (Get-Module 'PSReadLine') {
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    if (Get-Module 'PSFzf') {
        Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    } else {
        Set-PSReadLineKeyHandler -Key Tab -Function Complete
    }
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    # Only set the PSReadlineOption colors if not running in Powershell ISE
    if ((Get-Host).Name -NotLike "* ISE *") {
        # See: https://github.com/microsoft/terminal/issues/15452
        Set-PSReadLineColors -Background Light
    }
}
