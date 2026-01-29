# Automated Flutter Installation Script
Write-Host "Starting Flutter Installation..." -ForegroundColor Green

$flutterPath = "$env:USERPROFILE\flutter"
$flutterZip = "$env:TEMP\flutter_windows.zip"
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip"

# Check if Flutter already exists
if (Test-Path "$flutterPath\bin\flutter.bat") {
    Write-Host "Flutter already installed at: $flutterPath" -ForegroundColor Green
    $flutterPath
    exit 0
}

Write-Host "Step 1: Downloading Flutter SDK (this may take a few minutes)..." -ForegroundColor Yellow
try {
    # Download Flutter
    Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip -UseBasicParsing
    Write-Host "Download complete!" -ForegroundColor Green
} catch {
    Write-Host "Download failed. Please download manually from:" -ForegroundColor Red
    Write-Host "https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Cyan
    exit 1
}

Write-Host "Step 2: Extracting Flutter..." -ForegroundColor Yellow
try {
    # Remove existing flutter directory if it exists
    if (Test-Path $flutterPath) {
        Remove-Item -Path $flutterPath -Recurse -Force
    }
    
    # Extract to user profile
    Expand-Archive -Path $flutterZip -DestinationPath $env:USERPROFILE -Force
    Write-Host "Extraction complete!" -ForegroundColor Green
    
    # Clean up zip file
    Remove-Item -Path $flutterZip -Force
} catch {
    Write-Host "Extraction failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Step 3: Adding Flutter to PATH..." -ForegroundColor Yellow
try {
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$flutterPath\bin*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterPath\bin", "User")
        Write-Host "Flutter added to PATH!" -ForegroundColor Green
    } else {
        Write-Host "Flutter already in PATH" -ForegroundColor Green
    }
} catch {
    Write-Host "Failed to add to PATH. Please add manually: $flutterPath\bin" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "Flutter installed at: $flutterPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Please restart your terminal/IDE for PATH changes to take effect." -ForegroundColor Yellow
Write-Host "Then run: flutter doctor" -ForegroundColor Cyan

$flutterPath
