@echo off
setlocal

:: Prompt for the program name
set /p prog=[+] program name (without extension): 

:: Set paths to tools (adjust these paths as necessary)
set ML_PATH="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.39.33519\bin\Hostx64\x64\ml64.exe"
set LINK_PATH="C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\link.exe"

:: Assemble the program
%ML_PATH% %prog%.asm /link /subsystem:windows ^
/defaultlib:"C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\ntdll.lib" ^
/defaultlib:"C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\kernel32.lib" ^
/defaultlib:"C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\User32.lib" ^
/defaultlib:"C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64\Gdi32.lib" ^
/entry:Start ^
/LARGEADDRESSAWARE:NO ^
/out:%prog%.exe ^
/RELEASE

:: Check if the assembly and linking were successful
if errorlevel 1 (
    echo Assembly and linking failed. Please check your code.
    pause
    exit /b 1
)

:: Clean up the object and link files
del %prog%.obj
del *.lnk

echo Build successful! Press any key to continue...
pause
