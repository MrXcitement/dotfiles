# upgrade-windows.ps1 --- Upgrade windows using Windows Update
# Mike Barker <mike@thebarkers.com>
# June 24th, 2022
  
# Run Windows Update from PowerShell
# https://www.techielass.com/run-windows-update-from-powershell/

Write-Output "Upgrading Windows..."
Write-Output "--------------------"

# TLS Setting
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Trust PowerShell Gallery - this will avoid you getting any prompts that it's untrusted
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Install NuGet
# Install-PackageProvider -name NuGet -Force

# Install Module
Install-Module PSWindowsUpdate -Force

# Check what updates are required for this server
# Save the output in $output to see if we have any updates to install
Write-Output "`nChecking for windows updates..."
Get-WindowsUpdate -Verbose 4>&1 | Tee-Object -Variable output

# If updates where found
if ( $output[1] -notmatch "\bFound \[0\] " ) {

    # Accept and install all the updates that it's found are required
    Write-Output "`nInstalling windows updates..."
    Install-WindowsUpdate -AcceptAll
}
