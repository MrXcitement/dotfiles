# devcontainer-cli.ps1
# If devcontainer cli is installed, add it's location to the path
# Mike Barker <mike@thebarkers.com>
# February 10th, 2023
 
$devcontainer_cli_path="c:\Users\mike\AppData\Roaming\Code\User\globalStorage\ms-vscode-remote.remote-containers\cli-bin"
if (Test-Path $devcontainer_cli_path) {
    Set-PathVariable -AddPath $devcontainer_cli_path
}
