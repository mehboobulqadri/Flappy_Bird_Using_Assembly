@echo off
echo ============================================
echo    Flappy Bird - C Version Launcher
echo ============================================
echo.

if exist flappy_bird_c.exe (
    echo Starting C version...
    echo.
    start flappy_bird_c.exe
    exit
)

echo Game not built yet. Building now...
echo.
call build_c.bat

if exist flappy_bird_c.exe (
    echo.
    echo Starting game...
    start flappy_bird_c.exe
) else (
    echo.
    echo ERROR: Build failed. Cannot start game.
    pause
)
