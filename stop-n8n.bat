@echo off
echo ================================
echo      n8n Stop Script
echo ================================
echo.

REM Check if Docker Desktop is running
echo Checking Docker Desktop...
docker version >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker Desktop is not running - nothing to stop.
    echo.
    pause
    exit /b 0
)

echo Stopping n8n services...
docker-compose down

if %errorlevel% neq 0 (
    echo.
    echo WARNING: Some services may not have stopped cleanly.
) else (
    echo.
    echo ✓ All n8n services stopped successfully!
    echo ✓ Your data remains safely stored and will be available when you restart.
)

echo.
echo Press any key to exit...
pause >nul 