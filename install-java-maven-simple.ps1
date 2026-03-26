# Simple Java JDK and Maven installation using Chocolatey
# Run this script as Administrator in PowerShell

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "=== Installing Java JDK and Maven using Chocolatey ===" -ForegroundColor Cyan

# Install Chocolatey if not already installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "1. Installing Chocolatey package manager..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Chocolatey installed successfully" -ForegroundColor Green
} else {
    Write-Host "1. Chocolatey already installed" -ForegroundColor Green
}

# Refresh environment to make choco available
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install OpenJDK
Write-Host "2. Installing OpenJDK 17..." -ForegroundColor Yellow
choco install openjdk17 -y
Write-Host "OpenJDK 17 installed" -ForegroundColor Green

# Install Maven
Write-Host "3. Installing Apache Maven..." -ForegroundColor Yellow
choco install maven -y
Write-Host "Maven installed" -ForegroundColor Green

# Refresh environment variables
Write-Host "4. Refreshing environment variables..." -ForegroundColor Yellow
refreshenv

Write-Host ""
Write-Host "=== Installation Complete! ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Close and reopen your terminal/PowerShell for changes to take effect!" -ForegroundColor Yellow
Write-Host ""
Write-Host "After reopening terminal, verify installation with:" -ForegroundColor White
Write-Host "  java -version" -ForegroundColor White
Write-Host "  mvn -version" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"