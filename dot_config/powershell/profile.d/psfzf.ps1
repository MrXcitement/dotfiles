# Configure the PsFzf Module

# Mike Barker <mike@thebarkers.com>
# April 1, 2022

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
