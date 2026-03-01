@echo off
echo ================================================
echo Starting MSS301 Project Services
echo ================================================
echo.

REM Check if Docker Desktop is running
echo [1/4] Checking Docker Desktop...
docker ps >nul 2>&1
if errorlevel 1 (
    echo Docker Desktop is not running. Starting...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo Waiting 30 seconds for Docker to initialize...
    timeout /t 30 /nobreak >nul
) else (
    echo Docker Desktop is already running
)

echo.
echo [2/4] Starting Docker containers...
docker start postgres-user redis
timeout /t 5 /nobreak >nul

echo.
echo [3/4] Checking Docker containers status...
docker ps --format "table {{.Names}}\t{{.Status}}"

echo.
echo [4/4] Starting Frontend (Next.js)...
cd /d D:\FPT\MSS301\Projects\MSS301-BE\fe
start "Next.js Frontend" cmd /k "npx next dev -p 3000"

echo.
echo ================================================
echo Services Starting...
echo ================================================
echo.
echo Please wait 20-30 seconds for all services to start.
echo.
echo Then:
echo   - Frontend: http://localhost:3000/login
echo   - User Service: Start manually in IntelliJ
echo.
echo Opening login page in 15 seconds...
timeout /t 15 /nobreak >nul
start http://localhost:3000/login
echo.
echo Done!
pause

