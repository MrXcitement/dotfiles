##
# Useful aliases

# chezmoi aliases
if (Get-Command "chezmoi" -ErrorAction SilentlyContinue) {
    Set-Alias -Name cm -Value chezmoi
}
