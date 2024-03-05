#!/bin/zsh

# .zshenv --- Usually run for every zsh
# Mike Barker <mike@thebarkers.com>
# November 3rd, 2022


# Export environment key-value files in ~/.env directory
if [[ -d ${HOME}/.env ]]; then
    for f (${HOME}/.env/*.env); do
        export $(cat $f | sed -e /^$/d -e /^#/d | xargs)
    done
fi

# If on macos, use path_helper to seed the path
PATH_HELPER=/usr/libexec/path_helper
if [[ -x  $PATH_HELPER ]]; then
    unset PATH
    eval $($PATH_HELPER -s)
fi
unset PATH_HELPER

# Configure homebrew environment
BREW=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    test -x "/opt/homebrew/bin/brew" && BREW=/opt/homebrew/bin/brew

elif [[ "$OSTYPE" == "linux-gnu"* ]] then
    test -d "$HOME/.linuxbrew" && BREW="$HOME/.linuxbrew/bin/brew"
    test -d "/home/linuxbrew/.linuxbrew" && BREW="/home/linuxbrew/.linuxbrew/bin/brew"
fi

# Use brew command to set shell environment
if [[ "$BREW" != "" ]]; then
    eval "$($BREW shellenv)"
fi
unset BREW

# Configure pyenv environment
if [[ -d ${HOME}/.pyenv ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

# Configure rbenv environment
if [[ $(command -v rbenv) ]]; then
    eval "$(rbenv init -)"
fi

## Configure the path
# Feel free to add system specific paths here
# since any path that does not exist on the
# current system will not be added to the
# system path.

# Add paths before existing paths
newpath=(
~/bin
~/.local/bin
~/.dotnet/tools
/opt/microsoft/bin
# Add existing paths
$path
# Add paths after existing path
/usr/local/sbin)

# Replace the system path using the newpath array,
# only existing paths will be added to the new path.
path=($^newpath(N))
unset newpath

# Remove duplicate entries from the system path
typeset -U path
