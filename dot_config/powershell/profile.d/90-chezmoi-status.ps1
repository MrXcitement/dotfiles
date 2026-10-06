# 90-chezmoi-status.ps1 --- Update chezmoi and show status
# Mike Barker <mike@thebarkers.com>
# Created: March 7th, 2026
# Updated: October 6th, 2026

# If chezmoi installed, update and show any changes
# https://www.chezmoi.io/
if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
    # Update chezmoi local repo and working copy, but don't apply
    # and show any changed file in the home directory / working copy.
    $cmUpdate = $(chezmoi update -a=False)
    chezmoi status
}
