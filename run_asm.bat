@echo off
echo ============================================
echo    Flappy Bird - Assembly Version Launcher
echo ============================================
echo.

if exist flappy_bird_asm.exe (
    echo Starting Assembly version...
    echo.
    start flappy_bird_asm.exe
    exit
)

echo flappy_bird_asm.exe not found. Building now...
echo.
call build_asm.bat

if exist flappy_bird_asm.exe (
    echo.
    echo Starting game...
    start flappy_bird_asm.exe
) else (
    echo.
    echo ERROR: Build failed. Cannot start game.
    echo        Check build_asm.bat output for details.
    pause
)
