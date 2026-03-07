# ZZ-chezmoi.ps1 --- Update chezmoi and show the current status
# https://www.chezmoi.io/
# Mike Barker <mike@thebarkers.com>
# Created: March 7th, 2026

# This file starts with 'ZZ-' to force it to run near the end of
# loading other profile scripts.

# Is chezmoi installed?
if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
   # Update chezmoi local repo and working copy, but don't apply
   # and show any changed file in the home directory / working copy.
   chezmoi update -a=False
   chezmoi status
}