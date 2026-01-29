# Flutter Installation Script for Windows
# This script helps install Flutter SDK

Write-Host "Flutter Installation Helper" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Note: Some steps may require administrator privileges" -ForegroundColor Yellow
}

# Suggested installation directory
$flutterPath = "$env:USERPROFILE\flutter"

Write-Host "Flutter will be installed to: $flutterPath" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter already exists
if (Test-Path "$flutterPath\bin\flutter.bat") {
    Write-Host "Flutter already exists at $flutterPath" -ForegroundColor Green
    Write-Host "Adding to PATH..." -ForegroundColor Yellow
    
    # Add to user PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$flutterPath\bin*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterPath\bin", "User")
        Write-Host "Flutter added to PATH. Please restart your terminal." -ForegroundColor Green
    }
    exit 0
}

Write-Host "Step 1: Downloading Flutter SDK..." -ForegroundColor Yellow
Write-Host "Please download Flutter from: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Cyan
Write-Host ""
Write-Host "Or use this direct link:" -ForegroundColor Cyan
Write-Host "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip" -ForegroundColor White
Write-Host ""
Write-Host "After downloading:" -ForegroundColor Yellow
Write-Host "1. Extract the zip file to: $flutterPath" -ForegroundColor White
Write-Host "2. Run this script again to add Flutter to PATH" -ForegroundColor White
Write-Host ""

# Check if download location exists
$downloadPath = "$env:USERPROFILE\Downloads\flutter_windows_*.zip"
$zipFile = Get-ChildItem -Path $downloadPath -ErrorAction SilentlyContinue | Select-Object -First 1

if ($zipFile) {
    Write-Host "Found Flutter zip file: $($zipFile.FullName)" -ForegroundColor Green
    $response = Read-Host "Extract it now? (Y/N)"
    if ($response -eq 'Y' -or $response -eq 'y') {
        Write-Host "Extracting Flutter..." -ForegroundColor Yellow
        Expand-Archive -Path $zipFile.FullName -DestinationPath $env:USERPROFILE -Force
        Write-Host "Extraction complete!" -ForegroundColor Green
    }
}

# Check if Flutter was extracted
if (Test-Path "$flutterPath\bin\flutter.bat") {
    Write-Host "Flutter found! Adding to PATH..." -ForegroundColor Green
    
    # Add to user PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$flutterPath\bin*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterPath\bin", "User")
        Write-Host "Flutter added to PATH!" -ForegroundColor Green
        Write-Host "Please restart your terminal and run: flutter doctor" -ForegroundColor Yellow
    } else {
        Write-Host "Flutter is already in PATH" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "Manual Installation Steps:" -ForegroundColor Yellow
    Write-Host "1. Download Flutter SDK from https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
    Write-Host "2. Extract to: $flutterPath" -ForegroundColor White
    Write-Host "3. Add to PATH: $flutterPath\bin" -ForegroundColor White
    Write-Host "4. Restart terminal and run: flutter doctor" -ForegroundColor White
}

Write-Host ""
Write-Host "After installation, you'll also need:" -ForegroundColor Yellow
Write-Host "- Android Studio (for Android development)" -ForegroundColor White
Write-Host "- Or Visual Studio (for Windows development)" -ForegroundColor White
Write-Host "- Or Xcode (for iOS development on Mac)" -ForegroundColor White
