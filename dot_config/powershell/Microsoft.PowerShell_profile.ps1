# Microsoft.Powershell_profile.ps1 --- Default PowerShell console startup commands
#
# Mike Barker <mike@thebarkers.com>
# June 26th, 2015

# Notes:
# Place commands here that are unique to powershell when run in a console shell.
# If you have commands that should run when starting both the console or the ISE shell, but them in profile.ps1
# If you have commands that should run only in the ISE shell, put them in Microsoft.PowerShellISE_profile.ps1


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
 
