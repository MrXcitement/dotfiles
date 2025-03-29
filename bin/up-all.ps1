# up.all.ps1 -- Upgrade all apps and services
# Mike Barker <mike@thebarkers.com>
# August 12th, 2024

up-scoop
gsudo {
    echo ""
    up-winget
    echo ""
    up-windows
}

