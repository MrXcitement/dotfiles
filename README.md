# Dotfiles

Manage my dotfiles on any host using [chezmoi](https://www.chezmoi.io/)

## Summary

I am currently managing the following application's configuration files. Chezmoi
has been configured to only apply an applications configuration if it is
installed. I am using the `.chezmoiignore` file to accomplish this. I do not use
chezmoi to setup a particular machine to have the correct applications, but to
just make sure that the configuration for a particular set of applications
exists and is up to date.

## Managed Configurations

App | Description
--|--
[atuin](https://atuin.sh/) | A shell `history` alternative.
[emacs](https://www.gnu.org/software/emacs/) | An extensible, customizable, free/libre text editor — and more[^1].
[git](https://git-scm.com/) | Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
[ohmyzsh](https://ohmyz.sh/) | A delightful, open source, community-driven framework for managing your Zsh configuration.
[powershell](https://learn.microsoft.com/en-us/powershell/) | PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a configuration management framework. PowerShell runs on Windows, Linux, and macOS[^2].
[ssh](https://man.openbsd.org/ssh.1) | A program for logging into a remote machine and for executing commands on a remote machine.
[starship](https://starship.rs/) | The minimal, blazing-fast, and infinitely customizable prompt for any shell!
[tmux](https://github.com/tmux/tmux/wiki) | A terminal multiplexer. It lets you switch easily between several programs in one terminal, detach them (they keep running in the background) and reattach them to a different terminal[^3].
[vim](https://www.vim.org/) | A highly configurable text editor built to make creating and changing any kind of text very efficient.
[wezterm](https://wezfurlong.org/wezterm/index.html) | a powerful cross-platform terminal emulator and multiplexer written by [@wez](https://github.com/wez) and implemented in [Rust](https://www.rust-lang.org/).
[zsh](https://zsh.sourceforge.io/) | A shell designed for interactive use, although it is also a powerful scripting language. Many of the useful features of bash, ksh, and tcsh were incorporated into zsh; many original features were added.

[^1]: My Emacs configuration is using
[chemacs2](https://github.com/plexus/chemacs2) to allow you to choose an emacs
profile to run. I am also using chezmoi's `.chezmoiexternal` to clone my various
github `dot-emacs-???` profiles for use by *chemacs2* into the my `~/.config/`
folder.

[^2]: My PowerShell configuration files are written to be used by both
PowerShell 7+ and Windows PowerShell 5+. If they are installed on a Windows
machine, they will be symlinked to be used by Windows PowerShell.

[^3]: My tmux configuration depends on the [Tmux Plugin
Manager](https://github.com/tmux-plugins/tpm) I am using chezmoi's
`.chezmoiexternal` file to make sure that the `tpm` github repository is cloned
and available for use by the `tmux` configuration.
