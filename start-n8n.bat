@echo off
echo ================================
echo       n8n Startup Script
echo ================================
echo.

REM Check if Docker Desktop is running
echo [1/4] Checking Docker Desktop...
docker version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker Desktop is not running!
    echo Please start Docker Desktop and try again.
    echo.
    pause
    exit /b 1
)
echo ✓ Docker Desktop is running

REM Check if .env file exists, if not copy from example
echo.
echo [2/4] Setting up configuration...
if not exist ".env" (
    if exist "env.example" (
        copy "env.example" ".env" >nul
        echo ✓ Created .env file from template
        echo.
        echo IMPORTANT: Please edit .env file with your secure passwords!
        echo - Set a secure PGPASSWORD
        echo - Set a long ENCRYPTION_KEY (at least 32 characters)
        echo.
        echo Opening .env file for editing...
        notepad .env
        echo.
        echo Press any key after you've saved your .env file...
        pause >nul
    ) else (
        echo ERROR: env.example file not found!
        pause
        exit /b 1
    )
) else (
    echo ✓ Configuration file (.env) already exists
)

REM Start all services
echo.
echo [3/4] Starting n8n services...
echo This may take a few moments on first run...
echo.
docker-compose up -d

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Failed to start services!
    echo Check the error messages above.
    pause
    exit /b 1
)

REM Wait a moment for services to start
timeout /t 3 /nobreak >nul

REM Check service status
echo.
echo [4/4] Checking service status...
docker-compose ps

echo.
echo ================================
echo        n8n is Ready! 🎉
echo ================================
echo.
echo ✓ n8n Web UI:     http://localhost:5678
echo ✓ PostgreSQL:    localhost:5432
echo ✓ Redis:         localhost:6379
echo.
echo Your data is persistent and will survive reboots!
echo.
echo Useful commands:
echo   - View logs:        docker-compose logs -f n8n-primary
echo   - Stop services:    docker-compose down
echo   - Restart:          docker-compose restart
echo.
echo Opening n8n in your default browser...
start http://localhost:5678
echo.
echo Press any key to exit this window...
pause >nul 