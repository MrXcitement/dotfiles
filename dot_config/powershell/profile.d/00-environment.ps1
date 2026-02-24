# 00-environment.ps1 --- Add environment variables
# Mike Barker <mike@thebarkers.com>
# Created: February 17th, 2026
# Updated: February 17th, 2026

# If the user does not have a environment variable HOME defined,
# Create it using the HOMEDRIVE and HOMEPATH variables.
if (-Not [Environment]::GetEnvironmentVariable("HOME", "User")) {
   [Environment]::SetEnvironmentVariable("HOME","$Env:HOMEDRIVE$Env:HOMEPATH", "User")
   $Env:HOME="$Env:HOMEDRIVE$Env:HOMEPATH"
}