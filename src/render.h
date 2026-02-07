#ifndef RENDER_H
#define RENDER_H

#include <windows.h>
#include <gdiplus.h>
#include "game.h"

using namespace Gdiplus;

// Graphics handles
extern HDC hdcBackBuffer;
extern HBITMAP hbmBackBuffer;
extern ULONG_PTR gdiplusToken;

// Sprite images
extern Image* imgBackground;
extern Image* imgGround;
extern Image* imgPipeGreen;
extern Image* imgBirdFrames[3];  // 3 animation frames
extern Image* imgNumbers[10];
extern Image* imgGameOver;
extern Image* imgMessage;

// Rendering functions
void InitGraphics(HWND hwnd);
void CleanupGraphics();
void DrawGame(HDC hdc);
void DrawParticles(HDC hdc);
BOOL LoadImages();

// Medal functions
const char* GetMedalText(int score);
COLORREF GetMedalColor(int score);

#endif // RENDER_H
