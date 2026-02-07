# 🎮 Flappy Bird - Desktop Edition

A complete Flappy Bird clone fully optimized for desktop gaming with authentic sprites, smooth animations, and full audio integration!

## ✨ Features

- **🖥️ Desktop Resolution** - 1280x720 landscape (perfect for desktop gaming)
- **🎨 High-Quality Sprites** - 2x upscaled authentic Flappy Bird assets
- **🔊 Full Audio Integration** - wing flaps, scoring, hits, and death sounds
- **🎭 Smooth Animations** - 3-frame bird animation (down-flap, mid-flap, up-flap)
- **🎯 Improved Hitbox** - 20% smaller for more forgiving gameplay
- **✨ Particle Effects** - visual feedback on collision and scoring
- **📈 Progressive Difficulty** - speed increases with score
- **🏆 High Score Persistence** - saves your best score
- **🥇 Medal System** - Bronze (10+), Silver (20+), Gold (30+), Platinum (40+)
- **🌊 Scrolling Ground** - smooth parallax animation

## 🚀 Quick Start

### Play the Game
**Double-click:** `run_c_game.bat`

The game will automatically compile if needed and launch!

## 🎮 Controls

- `SPACE` - Flap / Start game
- `R` - Restart after game over
- `ESC` - Exit

## 📁 Project Structure

```
├── src/                    # C source code
│   ├── game.h/c           # Game logic and physics
│   ├── render.h/c         # Graphics rendering with GDI+
│   ├── audio.h/c          # Audio system using Windows API
│   └── main.c             # Windows entry point
├── assets/
│   ├── sprites_desktop/   # 2x upscaled sprites (1280x720 optimized)
│   └── audio/             # WAV sound files
├── build/                 # Compiled object files
├── build_c.bat            # Build script
├── run_c_game.bat         # Run script
└── flappy_bird_c.exe      # Compiled game executable
```

## 🔧 Building from Source

### Requirements
- **G++** (MinGW or similar)
- **Windows** (uses GDI+ for PNG support)

### Compile
```batch
build_c.bat
```

Or manually:
```batch
g++ -c src/game.c -o build/game.o
g++ -c src/render.c -o build/render.o
g++ -c src/audio.c -o build/audio.o
g++ -c src/main.c -o build/main.o
g++ build/game.o build/render.o build/audio.o build/main.o -o flappy_bird_c.exe -lgdi32 -lgdiplus -luser32 -lwinmm -mwindows
```

## 🎨 Graphics System

Uses **GDI+** for:
- PNG sprite loading with 2.5x upscaling
- Alpha transparency
- High-quality bicubic interpolation
- Smooth rendering
- Rotation (for upside-down pipes)

## 🔊 Audio System

Uses **Windows Multimedia API** for:
- WAV file playback
- Asynchronous sound effects
- Wing flap sounds
- Point scoring sounds
- Collision and death sounds

## 📊 Game Mechanics

- **Authentic feel** - tuned to match original Flappy Bird
- **Pixel-perfect collision** detection
- **60 FPS** smooth gameplay
- **Physics** - gravity, velocity, jump mechanics

## 🏆 Scoring

- Pass through pipes to score
- Speed increases every 5 points
- Earn medals based on final score

## 📝 Technical Details

- **Language:** C/C++ (compiled with g++)
- **Graphics:** Windows GDI+ (for PNG rendering with alpha transparency)
- **Audio:** Windows Multimedia API (winmm)
- **Window Size:** 1280x720 landscape (desktop optimized)
- **Sprite Scaling:** 2x upscale from original assets
- **Hitbox:** 20% smaller than visual sprite for better gameplay
- **Frame Rate:** 60 FPS smooth gameplay
- **Dependencies:** None - uses Windows built-in APIs only

## 🎯 Development Status

- ✅ Desktop landscape resolution (1280x720)
- ✅ High-quality sprite graphics
- ✅ Smooth 3-frame bird animation
- ✅ Scrolling ground with parallax
- ✅ Full audio integration (5 sound effects)
- ✅ Optimized hitbox (20% smaller)
- ✅ Particle effects system
- ✅ Progressive difficulty
- ✅ Medal system with persistence

**Future Ideas:**
- 🔲 Multiple bird colors (red, blue, yellow)
- 🔲 Day/night background toggle
- 🔲 Fullscreen mode
- 🔲 Leaderboard system

## 🎓 Learning Points

This project demonstrates:
- **GDI+ image loading** in C++
- **Game loop** architecture
- **Sprite animation** system
- **Physics simulation**
- **File I/O** for high scores
- **Windows API** programming

## 🐛 Troubleshooting

**Game won't start:**
- Make sure `assets/sprites_desktop/` folder exists with 26 PNG files
- Check that `assets/audio/` folder contains 5 WAV files
- Ensure MinGW/g++ is installed and in PATH

**Compilation errors:**
- Install MinGW with g++
- Make sure gdiplus is available

**Graphics look wrong:**
- Ensure sprites are in correct folder
- Check file paths in render.c

## 📜 Credits

**Original Game:** Flappy Bird by Dong Nguyen  
**Sprites:** Flappy Bird assets  
**Implementation:** C/C++ with GDI+

## 🎉 Enjoy!

Have fun playing! Try to beat your high score and earn all the medals!
