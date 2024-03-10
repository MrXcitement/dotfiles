# zoxide.ps1 -- init zoxide for powershell
# https://github.com/ajeetdsouza/zoxide
# Mike Barker <mike@thebarkers.com>
# May 19th 2022

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
        (zoxide init --cmd cd --hook $hook powershell | Out-String)
    })
}
