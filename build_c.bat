@echo off
echo ============================================
echo    Building Flappy Bird from C Source
echo ============================================
echo.

REM Compile C source files (C++ mode for GDI+)
echo Compiling C source files...
g++ -c src/game.c -o build/game.o -Wall
g++ -c src/render.c -o build/render.o -Wall
g++ -c src/audio.c -o build/audio.o -Wall
g++ -c src/main.c -o build/main.o -Wall

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Compilation failed!
    pause
    exit /b 1
)

echo.
echo Linking object files...
g++ build/game.o build/render.o build/audio.o build/main.o -o flappy_bird_c.exe -lgdi32 -lgdiplus -luser32 -lwinmm -mwindows

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Linking failed!
    pause
    exit /b 1
)

echo.
echo ============================================
echo    Build Successful!
echo    Executable: flappy_bird_c.exe
echo ============================================
echo.
pause
