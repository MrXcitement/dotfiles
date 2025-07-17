# up-winget.ps1 -- Upgrade apps using winget

echo "Upgrading Windows apps (winget)..."
echo "----------------------------------"

gsudo winget update --all
