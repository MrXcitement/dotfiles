# ~/.local/share/chezmoi/run_once_after_powershell.ps1
# ============================================================================
# Runs after `chezmoi apply` to relocate PowerShell's configuration files.
#
# This batch file copies the configuration files to their proper destinations
# on Windows. Chezmoi will skip this script on other operating systems.
# See https://www.chezmoi.io/docs/how-to/
#
# {{- /* This file supports Go's text/template language. */}}

function Test-IsElevated {
    return -Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
}

function Get-WindowsBuildNumber {
    return [int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber)
}

if (Test-IsElevated -And (Get-WindowsBuildNumber -ge 6000)) {
    Write-Warning "This script requires local admin privileges. Elevating..."
    gsudo "& '$($MyInvocation.MyCommand.Source)'" $args
    if ($LastExitCode -eq 999 ) {
        Write-error 'Failed to elevate.'
    }
    return
}

# You are elevated. Do admin stuff here.

# The source folder that holds the powershell profile files
$source_path = "$Env:USERPROFILE\.config\powershell"

# A list of target folders that will get symlink files and folders
$target_path_list = @("$Env:USERPROFILE\Documents\PowerShell", "$Env:USERPROFILE\Documents\WindowsPowerShell")

# Get a list of files and folders in the source directory
$items = Get-ChildItem "$source_path\*.ps1"
$items += Get-ChildItem -Directory "$source_path\"

# Target paths to link to
foreach ($target_path in $target_path_list) {
    # Create the target path, ignore errors if it already exists
    New-Item -Type Directory -ErrorAction Ignore -Path "$target_path" | Out-Null

    # Link the source files and folders to the target files and folders
    foreach ($file in $items) {
        $source = $file.FullName
        $target = "$target_path\$($file.Name)"

        # Create a target symlink to the source item
        if (-Not (Test-Path $target)) {
            Write-Output "Linking: $source to $target"
            New-Item -ItemType SymbolicLink -Path $target -Value $source -Force | Out-Null
        }
    }
}
