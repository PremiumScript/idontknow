@echo off
setlocal

:: Get the BIOS serial number
for /f "tokens=2 delims==" %%I in ('wmic bios get serialnumber /value') do set "biosSerial=%%I"

:: Define a list of known virtual machine BIOS serial patterns
:: (Modify these values based on known VM patterns, e.g., VMware, VirtualBox, etc.)
set "vmSerialPatterns=VMware|VirtualBox|KVM|Xen"

:: Check if the BIOS serial number contains any of the VM patterns
set "vmDetected=0"
for %%P in (%vmSerialPatterns%) do (
    echo %biosSerial% | find /I "%%P" >nul
    if "%ERRORLEVEL%"=="0" (
        set "vmDetected=1"
        goto :foundVM
    )
)

:foundVM
if "%vmDetected%"=="1" (
    echo Virtual machine detected based on BIOS serial number.
    :: Add additional actions if needed
) else (
    echo No virtual machine detected based on BIOS serial number.
    :: Add additional actions if needed
)

endlocal
