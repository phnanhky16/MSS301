# Install Java JDK and Maven automatically
# Run this script as Administrator in PowerShell

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "=== Installing Java JDK and Maven ===" -ForegroundColor Cyan

# Create tools directory
$toolsDir = "C:\tools"
if (!(Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir -Force
    Write-Host "Created $toolsDir directory" -ForegroundColor Green
}

# Download and install Java JDK 21 (latest LTS)
Write-Host "1. Downloading Java JDK 21..." -ForegroundColor Yellow
$jdkUrl = "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.zip"
$jdkZip = "$toolsDir\openjdk21.zip"
$jdkDir = "$toolsDir\jdk-21"

try {
    Invoke-WebRequest -Uri $jdkUrl -OutFile $jdkZip -UseBasicParsing
    Write-Host "JDK downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to download JDK: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Extract JDK
Write-Host "2. Extracting Java JDK..." -ForegroundColor Yellow
if (Test-Path $jdkDir) {
    Remove-Item $jdkDir -Recurse -Force
}
Expand-Archive -Path $jdkZip -DestinationPath $toolsDir -Force
Write-Host "JDK extracted to $jdkDir" -ForegroundColor Green

# Download Maven
Write-Host "3. Downloading Apache Maven..." -ForegroundColor Yellow
$mavenUrl = "https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
$mavenZip = "$toolsDir\maven.zip"
$mavenDir = "$toolsDir\apache-maven-3.9.6"

try {
    Invoke-WebRequest -Uri $mavenUrl -OutFile $mavenZip -UseBasicParsing
    Write-Host "Maven downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to download Maven: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Extract Maven
Write-Host "4. Extracting Maven..." -ForegroundColor Yellow
if (Test-Path $mavenDir) {
    Remove-Item $mavenDir -Recurse -Force
}
Expand-Archive -Path $mavenZip -DestinationPath $toolsDir -Force
Write-Host "Maven extracted to $mavenDir" -ForegroundColor Green

# Set environment variables
Write-Host "5. Setting environment variables..." -ForegroundColor Yellow

# Set JAVA_HOME
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkDir, [EnvironmentVariableTarget]::Machine)
Write-Host "Set JAVA_HOME = $jdkDir" -ForegroundColor Green

# Set M2_HOME
[Environment]::SetEnvironmentVariable("M2_HOME", $mavenDir, [EnvironmentVariableTarget]::Machine)
Write-Host "Set M2_HOME = $mavenDir" -ForegroundColor Green

# Update PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)
$javaBinPath = "$jdkDir\bin"
$mavenBinPath = "$mavenDir\bin"

if ($currentPath -notlike "*$javaBinPath*") {
    $newPath = "$currentPath;$javaBinPath"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, [EnvironmentVariableTarget]::Machine)
    Write-Host "Added Java to PATH" -ForegroundColor Green
}

if ($currentPath -notlike "*$mavenBinPath*") {
    $finalPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)
    $finalPath = "$finalPath;$mavenBinPath"
    [Environment]::SetEnvironmentVariable("PATH", $finalPath, [EnvironmentVariableTarget]::Machine)
    Write-Host "Added Maven to PATH" -ForegroundColor Green
}

# Clean up zip files
Remove-Item $jdkZip -Force
Remove-Item $mavenZip -Force
Write-Host "Cleaned up temporary files" -ForegroundColor Green

Write-Host ""
Write-Host "=== Installation Complete! ===" -ForegroundColor Cyan
Write-Host "Java JDK 17 installed at: $jdkDir" -ForegroundColor Green
Write-Host "Maven installed at: $mavenDir" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT: Close and reopen your terminal/PowerShell for changes to take effect!" -ForegroundColor Yellow
Write-Host ""
Write-Host "After reopening terminal, verify installation with:" -ForegroundColor White
Write-Host "  java -version" -ForegroundColor White
Write-Host "  mvn -version" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"