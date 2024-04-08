# glab.ps1 -- init glab completion for powershell
# Mike Barker <mike@thebarkers.com>
# April 8 (Eclipse day) 2024

if (Get-Command glab -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(glab completion -s powershell | Out-String)
}
