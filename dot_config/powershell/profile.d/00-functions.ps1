##
# Useful functions

# IsWindows variable is not defined in Windows Powershell 5.x,
# so define a local variable and set it to True
if (-Not (Get-Variable IsWindows -Scope Global -ErrorAction SilentlyContinue )) {
    $IsWindows = $true
}
Function Test-Administrator() {
    if ($IsWindows) {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        $user_principal = New-Object Security.Principal.WindowsPrincipal $user
        $role_admin = [Security.Principal.WindowsBuiltinRole]::Administrator
        return $user_principal.IsInRole($role_admin)
    } else {
        return ((id -u) -eq 0)
    }
}

# Get the path variable
Function Get-PathVariable {
    $env:Path -split ';'
}

# Set the path variable
Function Set-PathVariable {
    param (
        [string]$AddPath,
        [string]$RemovePath
    )
    $regexPaths = @()
    if ($PSBoundParameters.Keys -contains 'AddPath'){
        $regexPaths += [regex]::Escape($AddPath)
    }

    if ($PSBoundParameters.Keys -contains 'RemovePath'){
        $regexPaths += [regex]::Escape($RemovePath)
    }

    $arrPath = $env:Path -split ';'
    foreach ($path in $regexPaths) {
        $arrPath = $arrPath | Where-Object {$_ -notMatch "^$path\\?"}
    }
    $env:Path = ($arrPath + $addPath) -join ';'
}

# Set the PSReadLine Colors
function Set-PSReadLineColors {
    [alias("srlc")]
    [OutputType("none")]
    Param(
        [Parameter(Position = 0, HelpMessage = "Specify if the current background is dark or light. Default background is light.")]
        [ValidateSet("Dark", "Light")]
        [string]$Background = 'Light'
    )

    if ($Background -eq 'Dark') {
        Set-PSReadLineOption -Color @{
            Command   = "Yellow"
            Number    = "White"
        }
    }
    else {
        Set-PSReadLineOption -Color @{
            Command   = "DarkYellow"
            # ContinuationPrompt = 'DarkGray'
            Default   = 'DarkGray'
            Number    = 'DarkGray'
            Type      = 'DarkGray'
        }
    }
}

# Emacs helper functions
if (Get-Command "emacsclient" -ErrorAction SilentlyContinue) {
   function ec() {
      emacsclient -a "" @args
   }
}
