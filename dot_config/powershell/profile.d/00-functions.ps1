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
