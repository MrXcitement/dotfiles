# profile.ps1 --- Windows stub profile.ps1
#
# Mike Barker <mike@thebarkers.com>
# Created: October 6th, 2026
# Updated: 

# Warning!
# You should only edit if this file is ~\.config\powershell\windows\profile.ps1
#
# Notes:
# This file is managed by chezmoi and on windows it will be copied to
# the default user profile folders. Powershell 7+ uses
# 'Documents\Powershell\' and Windows Powershell 5.x uses
# 'Documents\WindowsPowershell\' as the profile folders. If OneDrive
# is set to Backup the Documents folder, Documents will be in the OneDrive
# location, otherwise it will be in the users USERPROFILE directory.
# Use: $PROFILE | Select * to see the folders defined.
#
# Chezmoi is configured to run a script when this profile.ps1 file is
# changed. The script will copy this file to the correct powershell
# profile folders.
#

# If the default profile.ps1 exists, source it.
$profilePath = "$Env:USERPROFILE/.config/powershell/profile.ps1"
if (Test-Path $profilePath -ErrorAction SilentlyContinue)
{
    . $profilePath
}
