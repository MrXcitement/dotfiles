# Mike Barker's 💤 LazyVim configuration for Neovim

## Description

This folder and sub-folders contain my Neovim configuration. The configuration is managed using the [Chezmoi](https://www.chezmoi.io/) dotfile manager. If the `nvim` command is found on a machine a `chezmoi apply` will add the `.config/nvim` folder to the system. If you are running a *MS Windows* system, Neovim expects to find it's configuration files in the %LOCALAPPDATA%/nvim folder. In this case a symlink will be created that points to the `.config\nvim` folder.

My Neovim configuration is a [LazyVim](https://www.lazyvim.org/) setup. I started by following the [LazyVim installation](https://lazyvim.github.io/installation) and using the [LazyVim starter](https://github.com/LazyVim/starter) repository.

## References

- [Chezmoi](https://www.chezmoi.io/)
- [LazyVim documentation](https://lazyvim.github.io/)
- [LazyVim repository](https://github.com/LazyVim/LazyVim)
