# Navigate one directory up from the directory where this script is located
Set-Location -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')

# Define the output file path correctly
$output_file = Join-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..') -ChildPath 'util\outputs\folder_structure.txt'

# Use the `tree` command to list the directory structure
# If `tree` is not available, or to ensure all files are listed, we can use `Get-ChildItem` to achieve a similar result
if (Get-Command tree -ErrorAction SilentlyContinue) {
    tree /F . | Out-File -FilePath $output_file
} else {
    Get-ChildItem -Recurse -File | ForEach-Object { $_.FullName } | Out-File -FilePath $output_file
}

Write-Host "Folder structure has been saved to $output_file"
