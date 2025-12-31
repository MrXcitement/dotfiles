<#
.SYNOPSIS
    Manage and run other 'up-*' scripts.

.DESCRIPTION
    The up.ps1 script is a PowerShell utility that helps you manage and run other scripts in
    the same directory that follow the naming convention 'up-*.ps1' or 'up<digit>-*.ps1'.
    It supports listing available scripts, running a specific script, or running all scripts.
    In addition, scripts may optionally include a single numeric prefix (0–9) immediately
    after 'up' to influence execution order. This allows certain scripts to be forced
    earlier or later in the run sequence without additional configuration.

        up-windows.ps1     → normal priority
        up3-office.ps1     → runs after all non-numbered scripts
        up9-security.ps1   → runs last (highest priority number)

    This design follows "convention over configuration" and avoids the need for a separate
    configuration file to control execution order.

.PARAMETER Command
    The name of a specific upgrade script to run (without the 'up-' or 'up<digit>-' prefix).
    Tab completion is supported for available scripts.

.PARAMETER All
    Run all 'up-*.ps1' and 'up<digit>-*.ps1' scripts in the script directory.

.PARAMETER List
    List all available 'up-*.ps1' and 'up<digit>-*.ps1' scripts in the script directory (without the
    'up-' or 'up<digit>-' prefix).

.PARAMETER Help
    Show usage information for this script.

.PARAMETER Version
    Show the version of this script.

.EXAMPLE
    .\up.ps1 winget
    Runs the script 'up-winget.ps1' if it exists.

.EXAMPLE
    .\up.ps1 -List
    Lists all available 'up-*' and 'up<digit>-*' scripts as command names (without prefix).

.EXAMPLE
    .\up.ps1 -All
    Runs all available 'up-*' and 'up<digit>-*' scripts in sorted order. For example, given:

        up-windows.ps1
        up3-office.ps1
        up9-security.ps1

    Execution order would be: windows → office → security

.NOTES
    Author: Mike Barker <mike@thebarkers.com>
    Created: May 22nd, 2025
    Updated: December 31st, 2025
#>

[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [ArgumentCompleter({
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
        # Reuse the canonical list from Get-UpScripts
        $scriptNames = . $MyInvocation.MyCommand.ScriptBlock.Module Get-UpScripts

        foreach ($name in $scriptNames) {
            if ($name -like "$wordToComplete*") {
                [System.Management.Automation.CompletionResult]::new(
                    $name, $name, 'ParameterValue', $name
                )
            }
        }
    })]
    [string]$Command,

    [switch]$All,
    [switch]$List,
    [switch]$Help,
    [switch]$Version
)

$ErrorActionPreference = "Stop"
$scriptVersion = "2.0.0"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

function Get-UpScripts {
    Get-ChildItem -Path $scriptDir -Filter "up*.ps1" -File |
        Where-Object { $_.Name -notmatch '^up\.ps1$' } |
        Sort-Object Name |
        ForEach-Object {
            # Return just the usable name (strip "up" + number + hyphen)
            $_.BaseName -replace '^up(\d+)?-',''
        }
}

function Invoke-UpScript {
    param([string]$Name)

    # Accept scripts with or without number prefixes
    $pattern = "^up(\d+)?-$Name\.ps1$"
    $match = Get-ChildItem -Path $scriptDir |
                Where-Object { $_.Name -match $pattern }

    if ($match) {
        & $match.FullName
    } else {
        throw "Script matching '$pattern' not found in $scriptDir"
    }
}

function Invoke-AllUpScripts {
    Get-UpScripts | ForEach-Object {
        Invoke-UpScript $_
    }
}


# Main logic
if ($Help -or -not $Command -and -not ($All -or $List -or $Version)) {
    Get-Help $MyInvocation.MyCommand.Definition
    return
}

if ($Version) {
    Write-Output "up.ps1 version $scriptVersion"
    return
}

if ($List) {
    Get-UpScripts
    return
}

if ($All) {
    Invoke-AllUpScripts
    return
}

if ($Command) {
    Invoke-UpScript -Name $Command
    return
}
