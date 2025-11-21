# profile.ps1 --- Default power shell config
#
# Mike Barker <mike@thebarkers.com>
# Created: June 26th, 2015
# Updated: November 20th, 2025

# Warning!
# You should only edit if this file is ~\.config\powershell\profile.ps1
#
# Notes:
# This file is managed by chezmoi and will be copied to the default user
# profile folders. Powershell uses 'Documents\Powershell\' and Windows
# Powershell uses 'Documents\WindowsPowershell\' as the profile folders. If
# OneDrive is set to Backup the Documents folder, it will be in the OneDrive
# location, otherwise it will be in the users home directory.
# Use $PROFILE | Select * to see the folders defined.
#
# Chezmoi is configured to run a script when the profile.ps1 file it is
# managing is changed. The script will copy the profile file to the correct
# profile folders.
#
# It is expected that configuration files for both powershell hosts will be
# located in the .config\powershell\profile.d folder.  These files will be
# loaded by both Powershell and Windows Powershell hosts.  If your
# configuration should only run on a specific host, you will need to check the
# current host and only run the configuration if on the correct host.

function Assert-IsInteractiveShell {

    $commandline_args = [Environment]::GetCommandLineArgs()

    # A list of command line args that indicate an interactive session
    $interactive_args = '-login', '-l', '-noexit', '-noe'

    # If any of the interactive args are found, return true
    if ($commandline_args | Where-Object -FilterScript {$PSItem -in $interactive_args}) {
        return $True
    }

    # A list of command line args that indicate a non interactive session
    $non_interactive_args = '-command', '-c', '-encodedcommand', '-e', '-ec', '-file', '-f', '-noni', '-noninteractive'

    # If any of the non interactive args are found, return false, otherwise true
    return -not ($commandline_args | Where-Object -FilterScript {$PSItem -in $non_interactive_args})
}

if (-not (Assert-IsInteractiveShell)) {
    exit
}

Write-Host "Loading profile.ps1..."
$scripts = Get-Item "$home\.config\powershell\profile.d\*.ps1"
foreach ($script in $scripts) {
    Write-Host "Loading $($script.Name)..."
    . $script
}

