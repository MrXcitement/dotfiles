# 00-environment.ps1 --- Add environment variables
# Mike Barker <mike@thebarkers.com>
# Created: February 17th, 2026
# Updated: July 31st, 2026

# Description:
# Configure the Powershell and Windows environment variables

# Code:

##
# Configure Windows environment

# If running on a Windows system
if (($null -ne $IsWindows) -and $IsWindows) {
    # If the user does not have an environment variable HOME defined,
    # Create it using the USERPROFILE variable.
    if (-Not [Environment]::GetEnvironmentVariable("HOME", "User")) {
        $Env:HOME="$Env:USERPROFILE"
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

##
# Configure the PSStyle colors.

# In an attempt to handle displaying Get-ChildItem colors using a color that handles both light and dark modes, I am changing the $PSStyle.FileINfo.Direcotory to use "`e38;1m" when I tried this color code, in light mode the text is bold black and in dark mode the text si bold white. This works well
# See the following for more info about the $PSStyle variable
# https://learn.microsoft.com/en-au/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.5#psstyle
# https://learn.microsoft.com/en-au/powershell/module/microsoft.powershell.core/about/about_ansi_terminals?view=powershell-7.5
# https://superuser.com/questions/1756130/change-color-of-powershell-7-get-childitem-result#:~:text=PSAnsiRenderingFileInfo,-feature

# Only change $PSStyle on Powershell 7.2.0 or greater
if ($PSVersionTable.PSVersion -ge [version]::Parse("7.2.0")) {
   $PSStyle.FileInfo.Directory = "`e[38;1m"
}
