# gh.ps1 -- init gh for powershell
# https://github.com/ajeetdsouza/gh
# Mike Barker <mike@thebarkers.com>
# May 19th 2022

if (Get-Command gh -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(gh completion -s powershell | Out-String)
}
