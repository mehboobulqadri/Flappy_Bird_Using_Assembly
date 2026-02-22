@echo off
echo ============================================================
echo    Flappy Bird — Assemble and Link from .asm files
echo ============================================================
echo.
echo  The .asm files in assembly/ are annotated Intel-syntax x86-64
echo  assembly generated from the C source with:
echo    g++ -S -O0 -masm=intel -fno-omit-frame-pointer -fverbose-asm
echo.
echo  This script ASSEMBLES the .asm files and LINKS them into
echo  flappy_bird_asm.exe.  The annotated .asm files are NOT
echo  regenerated — regenerating would overwrite all comments.
echo  (To regenerate cleanly from C, see the REM block below.)
echo ============================================================
echo.

REM ----------------------------------------------------------------
REM  HOW TO REGENERATE .asm FROM C (destroys all hand-added comments):
REM    g++ -S -O0 -masm=intel -fno-omit-frame-pointer -fverbose-asm src/game.c   -o assembly/game.asm
REM    g++ -S -O0 -masm=intel -fno-omit-frame-pointer -fverbose-asm src/audio.c  -o assembly/audio.asm
REM    g++ -S -O0 -masm=intel -fno-omit-frame-pointer -fverbose-asm src/main.c   -o assembly/main.asm
REM    g++ -S -O0 -masm=intel -fno-omit-frame-pointer              src/render.c -o assembly/render.asm
REM  (-fverbose-asm is omitted for render.asm because GDI+ inlines make it too noisy)
REM ----------------------------------------------------------------

REM Create build directory if it does not exist
if not exist build mkdir build

echo [Step 1/3] Assembling game.asm ...
as --64 assembly\game.asm -o build\game_asm.o
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to assemble game.asm
    echo        Check that 'as' (GNU Assembler) is on your PATH.
    pause
    exit /b 1
)
echo         OK: build\game_asm.o

echo [Step 1/3] Assembling audio.asm ...
as --64 assembly\audio.asm -o build\audio_asm.o
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to assemble audio.asm
    pause
    exit /b 1
)
echo         OK: build\audio_asm.o

echo [Step 1/3] Assembling main.asm ...
as --64 assembly\main.asm -o build\main_asm.o
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to assemble main.asm
    pause
    exit /b 1
)
echo         OK: build\main_asm.o

echo [Step 1/3] Assembling render.asm ...
as --64 assembly\render.asm -o build\render_asm.o
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to assemble render.asm
    pause
    exit /b 1
)
echo         OK: build\render_asm.o

echo.
echo [Step 2/3] All four .asm files assembled successfully.
echo.

echo [Step 3/3] Linking into flappy_bird_asm.exe ...
g++ build\game_asm.o build\render_asm.o build\audio_asm.o build\main_asm.o ^
    -o flappy_bird_asm.exe ^
    -lgdi32 -lgdiplus -luser32 -lwinmm -mwindows
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Linking failed!
    echo        Make sure MinGW-W64 g++ is on your PATH.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo    Build Successful!
echo    Executable: flappy_bird_asm.exe
echo    Run it with: run_asm.bat
echo ============================================================
echo.
pause
