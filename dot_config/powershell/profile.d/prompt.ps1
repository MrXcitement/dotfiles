##
# Configure the prompt

# If the host is Powershell ISE, just exit
if ((Get-Host).Name -like "* ISE *") {
    Exit
}

# If the starship prompt utility is installed, use it
if (Get-Command starship -ErrorAction Ignore) {
    Invoke-Expression (&starship init powershell)
    Exit
}

Function Prompt
{
    $realLASTEXITCODE = $LASTEXITCODE

    $userName = [Environment]::UserName
    $computerName = [Environment]::MachineName

    $defaultForegroundColor = 'White'
    $userForegroundColor = 'Cyan'
    $hostForegroundColor = 'Cyan'
    $pathForegroundColor = 'Yellow'
    if (Test-Administrator)
    {
        $userForegroundColor='Red'
        $hostForegroundColor='Red'
    }

    # Write the prompt using the following format:
    # username@hostname currentdir [git status]
    # > _
    #
    Write-Host($userName) -noNewLine -ForegroundColor $userForegroundColor
    Write-Host("@") -noNewLine -ForegroundColor $defaultForegroundColor
    Write-Host($computerName) -noNewLine -ForegroundColor $hostForegroundColor
    Write-Host(" in ") -nonewline -ForegroundColor $defaultForegroundColor
    Write-Host(Convert-Path(Get-Location)) -nonewline -ForegroundColor $pathForegroundColor
    if (${function:Write-VcsStatus})
    {
        Write-Host -noNewLine (Write-VcsStatus)
    }
    Write-Host("")

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "$('>' * ($nestedPromptLevel + 1)) "
}
# Function Prompt
# {
#     $realLASTEXITCODE = $LASTEXITCODE

#     $userName = [Environment]::UserName
#     $computerName = [Environment]::MachineName

#     $defaultForegroundColor = 'White'
#     $userForegroundColor = 'Cyan'
#     $hostForegroundColor = 'Cyan'
#     $pathForegroundColor = 'Yellow'
#     if (Test-Administrator)
#     {
#         $userForegroundColor='Red'
#         $hostForegroundColor='Red'
#     }

#     # Write the prompt using the following format:
#     # username@hostname currentdir [git status]
#     # > _
#     #
#     Write-Host($userName) -noNewLine -ForegroundColor $userForegroundColor
#     Write-Host("@") -noNewLine -ForegroundColor $defaultForegroundColor
#     Write-Host($computerName) -noNewLine -ForegroundColor $hostForegroundColor
#     Write-Host(" in ") -nonewline -ForegroundColor $defaultForegroundColor
#     Write-Host(Convert-Path(Get-Location)) -nonewline -ForegroundColor $pathForegroundColor
#     if (${function:Write-VcsStatus})
#     {
#         Write-Host -noNewLine (Write-VcsStatus)
#     }
#     Write-Host("")

#     $global:LASTEXITCODE = $realLASTEXITCODE
#     return "$('>' * ($nestedPromptLevel + 1)) "
# }

