@echo off
REM Build script for MeshFlow-Markets and its dependencies (Windows version)
REM This ensures the base image is always rebuilt before the main application

setlocal enabledelayedexpansion

echo ======================================
echo Building MeshFlow-Markets Docker Images
echo ======================================
echo.

REM Step 1: Build the base image from solace-agent-meshwise
echo [1/2] Building base image (my-sam-base:latest)...
echo       Location: solace-agent-meshwise\
echo       Building without cache to ensure WebUI changes are included
echo.

cd solace-agent-meshwise

docker build --no-cache -t my-sam-base:latest .
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to build base image
    exit /b 1
)

echo.
echo [SUCCESS] Base image built successfully
echo.

REM Step 2: Build MeshFlow-Markets (using fresh base image with your local changes)
echo [2/2] Building MeshFlow-Markets image...
echo       Location: MeshFlow-Markets\
echo       Note: Using local solace-agent-mesh from base image (not PyPI)
echo.

cd ..\MeshFlow-Markets

docker build -t meshflow-markets:latest .
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to build MeshFlow-Markets image
    exit /b 1
)

echo.
echo [SUCCESS] MeshFlow-Markets image built successfully
echo.

REM Success message with run instructions
echo ======================================
echo Build Complete!
echo ======================================
echo.

echo To run the application:
echo   docker run --name sam-app -p 8000:8000 -p 5002:5002 meshflow-markets:latest
echo.

echo To run with environment variables from .env file:
echo   docker run --name sam-app --env-file MeshFlow-Markets\.env -p 8000:8000 -p 5002:5002 meshflow-markets:latest
echo.

echo Images created:
docker images | findstr /R "my-sam-base meshflow-markets"

cd ..
