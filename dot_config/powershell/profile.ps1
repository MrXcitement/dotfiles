# profile.ps1 --- Default powershell config

# Mike Barker <mike@thebarkers.com>
# Created: June 26th, 2015
# Updated: October 28th, 2026

# Notes:
# It is expected that configuration files for both the core and desktop
# powershell hosts will be located in the ~\.config\powershell\profile.d folder.
# If your configuration should only run on a specific host, you will need to
# check the current host and only run the configuration if on the correct host.

function Assert-IsInteractiveShell {

    # Get the current commandline arguments.
    $commandline_args = [Environment]::GetCommandLineArgs()

    # A list of command line args that indicate a non interactive session.
    $non_interactive_args =
        '-command', '-c',
        '-encodedcommand', '-e', '-ec',
        '-file', '-f',
        '-noninteractive', '-noni'

    # If any of the non interactive args are found, return false
    if ($commandline_args | Where-Object -FilterScript {$PSItem -in $non_interactive_args}) {
        return $False
    }
    return $True
}

# If we being called from within a Psmux session, or this is an interactive shell
# Load our profile files.
if (($env:PSMUX_SESSION) -Or (Assert-IsInteractiveShell)) {
    Write-Host "Loading profile scripts..."
    if ($env:USERPROFILE) {
        $profileDir = "$env:USERPROFILE/.config/powershell/profile.d"
    } else {
        $profileDir = "$env:HOME/.config/powershell/profile.d"
    }
    $scripts = Get-Item -ErrorAction SilentlyContinue "$profileDir/*.ps1"
    foreach ($script in $scripts) {
        Write-Host "Loading $($script.Name)..."
        . $script
    }
}

