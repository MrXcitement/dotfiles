# mise.ps1 -- init mise for powershell
# https://mise.jdx.dev/installing-mise.html#powershell
# Mike Barker <mike@thebarkers.com>
# July 15th, 2025

if (Get-Command mise -ErrorAction SilentlyContinue) {
  mise activate pwsh | Out-String | Invoke-Expression
  # Add mise shims to PATH so all the downloaded packages work correctly
  $shim = "$env:LOCALAPPDATA\mise\shims"
  if (Test-Path $shim) {
    $env:PATH = "$shim;$env:PATH"
  }
}
