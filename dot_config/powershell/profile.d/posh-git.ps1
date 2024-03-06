##
# Load posh-git module and start the ssh agent
# https://github.com/dahlbyk/posh-git
if ((Get-Command "git" -ErrorAction SilentlyContinue) -And
    (Get-Module -ListAvailable -Name "Posh-Git"))
{
    Write-Output "Import module posh-git"
    Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
    Import-Module posh-git
    Pop-Location
}

