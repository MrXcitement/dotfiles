##
# Configure the PSStyle colors.
# In an attempt to handle displaying Get-ChildItem colors using a color that handles both light and dark modes, I am changing the $PSStyle.FileINfo.Direcotory to use "`e38;1m" when I tried this color code, in light mode the text is bold black and in dark mode the text si bold white. This works well
# See the following for more info about the $PSStyle variable
# https://learn.microsoft.com/en-au/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.5#psstyle
# https://learn.microsoft.com/en-au/powershell/module/microsoft.powershell.core/about/about_ansi_terminals?view=powershell-7.5
# https://superuser.com/questions/1756130/change-color-of-powershell-7-get-childitem-result#:~:text=PSAnsiRenderingFileInfo,-feature

# Only change $PSStyle on Powershell 7.2.0 or greater
$currentVersion = $PSVersionTable.PSVersion
if ($currentVersion -ge [version]::Parse("7.2.0")) {
   $PSStyle.FileInfo.Directory = "`e[38;1m"
}
