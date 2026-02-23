#!/usr/bin/env bash

MODE="${1:-c}"

if [[ "$MODE" == "--asm" ]]; then
    EXE="flappy_bird_asm.exe"
    BUILD_ARG="--asm"
else
    EXE="flappy_bird_c.exe"
    BUILD_ARG=""
fi

if [[ ! -f "$EXE" ]]; then
    echo "$EXE not found. Building now..."
    echo
    bash build.sh $BUILD_ARG
fi

if [[ ! -f "$EXE" ]]; then
    echo "ERROR: Build failed. Cannot start game."
    exit 1
fi

OS="$(uname -s 2>/dev/null || echo Windows)"

if [[ "$OS" == Linux* ]]; then
    if ! command -v wine &>/dev/null; then
        echo "ERROR: Wine is required to run the game on Linux."
        echo "       Install: sudo apt install wine   (Debian/Ubuntu)"
        echo "                sudo dnf install wine   (Fedora)"
        exit 1
    fi
    echo "Starting $EXE with Wine..."
    wine "$EXE"
else
    echo "Starting $EXE ..."
    cmd //c start "" "$EXE"
fi
