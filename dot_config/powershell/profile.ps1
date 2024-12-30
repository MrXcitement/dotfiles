# profile.ps1 --- Default power shell config
#
# Mike Barker <mike@thebarkers.com>
# June 26th, 2015

# Notes:
# There are many different profile files used by powershell at
# startup. There are files for the system and for the user. The system
# profiles are placed in C:\Programs Files\WindowsPowerShell and the
# users profiles are located in the WindowsPowerShell folder under the
# users Documents folder. The profile files that can exist in both of
# these locations have a specific nameing convention.

# Default profile, loaded by both cmd and ISE powershell
# profile.ps1

# Default cmd powershell profile.
# Microsoft.PowerShell_profile.ps1

# Default ISE powershell profile.
# Microsoft.PowerShellISE_profile.ps1

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

