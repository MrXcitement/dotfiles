##
# Useful aliases

# chezmoi aliases
if (Get-Command "chezmoi" -ErrorAction SilentlyContinue) {
    Set-Alias -Name cm -Value chezmoi
}

# emacs aliases
if (Get-Command "emacs" -ErrorAction SilentlyContinue) {
   Set-ALias -Name e -Value emacs
   Set-ALias -Name ec -Value emacsclient
}
