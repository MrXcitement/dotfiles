# 00-environment.ps1 --- Add environment variables
# Mike Barker <mike@thebarkers.com>
# Created: February 17th, 2026
# Updated: July 31st, 2026

# If running on a Windows system
if (($null -ne $IsWIndows) -and $IsWIndows) {
    # If the user does not have a environment variable HOME defined,
    # Create it using the HOMEDRIVE and HOMEPATH variables.
    if (-Not [Environment]::GetEnvironmentVariable("HOME", "User")) {
        $Env:HOME="$Env:HOMEDRIVE$Env:HOMEPATH"
        [Environment]::SetEnvironmentVariable("HOME", $Env:HOME, "User")
    }
    # Python 3.7+ use UTF-8 encoding by default
    if (-Not [Environment]::GetEnvironmentVariable("PYTHONUTF8", "User")) {
        $Env:PYTHONUTF8=1
        [Environment]::SetEnvironmentVariable("PYTHONUTF8", $Env:PYTHONUTF8, "User")
    }
    if  (-Not [Environment]::GetEnvironmentVariable("PYTHONIOENCODING", "User")) {
        $Env:PYTHONIOENCODING="utf-8"
        [Environment]::SetEnvironmentVariable("PYTHONIOENCODING", $Env:PYTHONIOENCODING, "User")
    }
}
