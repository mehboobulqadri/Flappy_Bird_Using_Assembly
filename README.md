# Flappy Bird — COAL Assembly Project

A Flappy Bird clone written in C, with a fully documented x86-64 assembly translation.
Academic project for **Computer Organization and Assembly Language (COAL)**.

> **Note:** The game uses Win32 and GDI+ APIs — it targets Windows. Linux users build via MinGW-W64 cross-compiler and run via Wine.

---

## Requirements

| Platform | Compiler | Assembler | Runtime |
|----------|----------|-----------|---------|
| Windows  | MinGW-W64 `g++` | `as` (bundled) | — |
| Linux    | `mingw-w64` (`x86_64-w64-mingw32-g++`) | `x86_64-w64-mingw32-as` | Wine |

**Windows install:** https://winlibs.com or https://www.mingw-w64.org  
**Linux install:**
```bash
sudo apt install mingw-w64 wine     # Debian/Ubuntu
sudo dnf install mingw64-gcc-c++ wine  # Fedora
```

---

## Build & Run

> On Windows use **Git Bash** or **MSYS2** to run `.sh` scripts.

```bash
chmod +x build.sh run.sh   # Linux only (once)

./build.sh          # build C version
./run.sh            # run C version

./build.sh --asm    # build assembly version
./run.sh --asm      # run assembly version
```

---

## Controls

| Key | Action |
|-----|--------|
| `SPACE` | Flap / Start |
| `R` | Restart after game over |
| `ESC` | Exit |

---

## Project Structure

```
COAL/
  src/
    main.c       — Win32 window, message loop, WndProc
    game.c       — physics, collision, particles, pipes, scoring
    render.c     — GDI+ double-buffered sprite rendering
    audio.c      — Win32 PlaySound WAV playback
    game.h / render.h / audio.h
  assembly/
    audio.asm    — simplest file; good intro to Win32 API calls in asm
    game.asm     — physics, gravity, AABB collision, particle system
    main.asm     — Win32 message dispatch, switch-to-jump-table translation
    render.asm   — GDI+ draw pipeline, C++ vtables & name mangling
  assets/
    sprites_desktop/   — PNG sprites
    audio/             — WAV + OGG sound files
  build/               — object files (git-ignored)
  build.sh             — build script (Linux / Git Bash / MSYS2)
  run.sh               — run script  (Linux / Git Bash / MSYS2)
```

---

## Assembly Files

| File | Lines | Covers |
|------|-------|--------|
| `audio.asm` | ~325 | Win32 PlaySound, import table calls |
| `game.asm` | ~2258 | Physics, gravity, AABB collision, particles |
| `main.asm` | ~818 | WinMain, WndProc, message-dispatch jump table |
| `render.asm` | ~4370 | GDI+ pipeline, C++ vtables, name mangling |

Generated with:
```
g++ -S -O0 -masm=intel -fno-omit-frame-pointer -fverbose-asm src/FILE.c -o assembly/FILE.asm
```

Every `.asm` file explains: instructions mapped to C source, stack frame layout, Windows x64 calling convention (RCX/RDX/R8/R9, 32-byte shadow space), and Win32/GDI+ API calls in plain English.

---

## Game Features

- 1280×720 window, GDI+ double-buffered (no flicker)
- 3-frame bird animation
- Procedural pipes with increasing speed
- Particle effects on collision and scoring
- Medal system: Bronze (10+) · Silver (20+) · Gold (30+) · Platinum (40+)
- High score persisted to `flappy_highscore.dat`

---

## Credits

Original concept: Flappy Bird by Dong Nguyen  
Sprites: Original Flappy Bird assets  
Implementation: C/C++ with Win32 GDI+ API
