#!/usr/bin/env bash
set -e

MODE="${1:-c}"

OS="$(uname -s 2>/dev/null || echo Windows)"

if [[ "$OS" == Linux* ]]; then
    GPP="x86_64-w64-mingw32-g++"
    AS_CMD="x86_64-w64-mingw32-as"
    echo "[INFO] Linux detected  ->  using mingw-w64 cross-compiler"
    echo "[INFO] Install: sudo apt install mingw-w64   (Debian/Ubuntu)"
    echo "[INFO]          sudo dnf install mingw64-gcc-c++   (Fedora)"
    echo
else
    GPP="g++"
    AS_CMD="as"
fi

mkdir -p build

if [[ "$MODE" == "--asm" ]]; then

    echo "============================================================"
    echo "   Flappy Bird - Assemble and Link from .asm files"
    echo "============================================================"
    echo

    echo "[Step 1/5] Assembling game.asm ..."
    $AS_CMD --64 assembly/game.asm -o build/game_asm.o
    echo "         OK: build/game_asm.o"

    echo "[Step 2/5] Assembling audio.asm ..."
    $AS_CMD --64 assembly/audio.asm -o build/audio_asm.o
    echo "         OK: build/audio_asm.o"

    echo "[Step 3/5] Assembling main.asm ..."
    $AS_CMD --64 assembly/main.asm -o build/main_asm.o
    echo "         OK: build/main_asm.o"

    echo "[Step 4/5] Assembling render.asm ..."
    $AS_CMD --64 assembly/render.asm -o build/render_asm.o
    echo "         OK: build/render_asm.o"

    echo
    echo "[Step 5/5] Linking into flappy_bird_asm.exe ..."
    $GPP build/game_asm.o build/render_asm.o build/audio_asm.o build/main_asm.o \
        -o flappy_bird_asm.exe \
        -lgdi32 -lgdiplus -luser32 -lwinmm -mwindows

    echo
    echo "============================================================"
    echo "   Build Successful!  ->  flappy_bird_asm.exe"
    echo "   Run with:  ./run.sh --asm"
    echo "============================================================"

else

    echo "============================================"
    echo "   Building Flappy Bird from C Source"
    echo "============================================"
    echo

    echo "[Step 1/5] Compiling game.c ..."
    $GPP -c src/game.c -o build/game.o -Wall
    echo "         OK: build/game.o"

    echo "[Step 2/5] Compiling render.c ..."
    $GPP -c src/render.c -o build/render.o -Wall
    echo "         OK: build/render.o"

    echo "[Step 3/5] Compiling audio.c ..."
    $GPP -c src/audio.c -o build/audio.o -Wall
    echo "         OK: build/audio.o"

    echo "[Step 4/5] Compiling main.c ..."
    $GPP -c src/main.c -o build/main.o -Wall
    echo "         OK: build/main.o"

    echo
    echo "[Step 5/5] Linking into flappy_bird_c.exe ..."
    $GPP build/game.o build/render.o build/audio.o build/main.o \
        -o flappy_bird_c.exe \
        -lgdi32 -lgdiplus -luser32 -lwinmm -mwindows

    echo
    echo "============================================"
    echo "   Build Successful!  ->  flappy_bird_c.exe"
    echo "   Run with:  ./run.sh"
    echo "============================================"

fi
