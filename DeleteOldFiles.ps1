<#
.SYNOPSIS
    Deletes files and folders older than specified days in a target directory.
.DESCRIPTION
    This script recursively deletes files and folders older than X days from the specified path.
    It logs all actions to a log file and displays progress in the console.
.NOTES
    File Name      : DeleteOldFiles.ps1
    Author         : Abdul Mozid
    Prerequisite   : PowerShell 5.1 or later
#>

param (
    [string]$TargetFolder = "C:\Users\abmozid\Pictures\Screenshots",  # Change this to your target path
    [int]$DaysOld = 7,
    [string]$LogFile = "C:\Users\abmozid\Pictures\Screenshots\FileCleanup.log"       # Change log path if needed
)

# Create log directory if it doesn't exist
$logDirectory = Split-Path -Path $LogFile -Parent
if (-not (Test-Path -Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory | Out-Null
}

# Function to write to log file
function Write-Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $message"
    Add-Content -Path $LogFile -Value $logMessage
    Write-Output $logMessage
}

try {
    Write-Log "Script started"
    Write-Log "Target folder: $TargetFolder"
    Write-Log "Deleting items older than $DaysOld days"

    # Check if target folder exists
    if (-not (Test-Path -Path $TargetFolder)) {
        Write-Log "Error: Target folder does not exist"
        exit 1
    }

    # Get current date
    $currentDate = Get-Date

    # Calculate cutoff date
    $cutoffDate = $currentDate.AddDays(-$DaysOld)

    # Delete old files
    $files = Get-ChildItem -Path $TargetFolder -File -Recurse | Where-Object { $_.CreationTime -lt $cutoffDate }
    $fileCount = $files.Count
    Write-Log "Found $fileCount files to delete"

    foreach ($file in $files) {
        try {
            Remove-Item -Path $file.FullName -Force
            Write-Log "Deleted file: $($file.FullName)"
        }
        catch {
            Write-Log "Error deleting file $($file.FullName): $_"
        }
    }

    # Delete empty folders (optional - uncomment if you want this)
    <#
    $folders = Get-ChildItem -Path $TargetFolder -Directory -Recurse | Where-Object { $_.LastWriteTime -lt $cutoffDate }
    $folderCount = $folders.Count
    Write-Log "Found $folderCount folders to delete"

    foreach ($folder in $folders) {
        try {
            # Only delete if folder is empty
            if ((Get-ChildItem -Path $folder.FullName -Recurse -Force | Measure-Object).Count -eq 0) {
                Remove-Item -Path $folder.FullName -Force -Recurse
                Write-Log "Deleted folder: $($folder.FullName)"
            }
        }
        catch {
            Write-Log "Error deleting folder $($folder.FullName): $_"
        }
    }
    #>

    Write-Log "Script completed successfully"
}
catch {
    Write-Log "Error in script: $_"
    exit 1
}