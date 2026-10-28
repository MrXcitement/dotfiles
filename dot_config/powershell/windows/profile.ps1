# profile.ps1 --- Windows dot-source the file in defualt profile.ps1

# Mike Barker <mike@thebarkers.com>
# Created: October 6th, 2026
# Updated: October 28th, 2026

# Warning!
# You should only edit if this file is ~\.config\powershell\windows\profile.ps1

# Notes:
# On Windows systems:
# Powershell 7+ (Core) points to: '~\Documents\Powershell\profile.ps1'
# Windows Powershell 5+ (Desktop) points to: '~\Documents\WindowsPowershell\profile.ps1'.
# If OneDrive is setup to Backup the Documents folder, they will be under the OneDrive
# folder, otherwise it they will be under the users home folder.
# Use $PROFILE | Select * to see the folders defined.

# Chezmoi is configured to run a script when this profile.ps1 file is changed.
# The script will copy this profile.ps1 file to the correct profile folders.

# If the default profile.ps1 exists, source it.
$profilePath = "$Env:USERPROFILE/.config/powershell/profile.ps1"
if (Test-Path $profilePath -ErrorAction SilentlyContinue)
{
    . $profilePath
}
