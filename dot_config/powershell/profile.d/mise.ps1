# mise.ps1 -- init mise for powershell
# https://mise.jdx.dev/installing-mise.html#powershell
# Mike Barker <mike@thebarkers.com>
# July 15th, 2025

# Check for mise.exe and running in powershell version 7 or later
if ((Get-Command mise.exe -ErrorAction SilentlyContinue) -and 
    ($PSVersionTable.PSVersion.Major -ge 7)){
  mise activate pwsh | Out-String | Invoke-Expression
}
