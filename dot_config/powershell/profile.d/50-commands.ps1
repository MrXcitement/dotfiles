# 50-commands.ps1 --- Configure cli tools
# Mike Barker <mike@thebarkers.com>
# Created: October 6th, 2026
 
# If chezmoi installed, configure chezmoi aliases
if (Get-Command "chezmoi" -ErrorAction SilentlyContinue) {
    Set-Alias -Name cm -Value chezmoi
}

# If devcontainer installed, add it's location to the path
$devcontainer_cli_path="$Env:APPDATA\Code\User\globalStorage\ms-vscode-remote.remote-containers\cli-bin"
if (Test-Path $devcontainer_cli_path) {
    Set-PathVariable -AddPath $devcontainer_cli_path
}

# If emacs installed, configure emacs aliases
if (Get-Command "emacs" -ErrorAction SilentlyContinue) {
    Set-ALias -Name e -Value emacs
    # If emacsclient installed, configure emacsclient helper functions
    if (Get-Command "emacsclient" -ErrorAction SilentlyContinue) {
	function ec() {
	    emacsclient -a "" @args
	}
    }
}

# If git installed, configure gh completion for powershell
if (Get-Command gh -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(gh completion -s powershell | Out-String)
}

# If glab installed, configure glab completion for powershell
if (Get-Command glab -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(glab completion -s powershell | Out-String)
}

# If mise.exe installed and running in powershell version 7 or later
# Then configure mise for powershell
if ((Get-Command mise -ErrorAction SilentlyContinue) -and ($PSVersionTable.PSVersion.Major -ge 7)) {
    mise activate pwsh | Out-String | Invoke-Expression
}

# If the host is not Powershell ISE and starship is installed
# The configure starship for powershell
if ((-not ((Get-Host).Name -like "* ISE *")) -and (Get-Command starship -ErrorAction Ignore)) {
    Invoke-Expression (&starship init powershell)
}

# If zoxide is installed, configure zoxide for powershell
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
        (zoxide init --cmd cd --hook $hook powershell | Out-String)
    })
}

