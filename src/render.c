#include "render.h"
#include <stdio.h>
#include <string.h>

// Graphics handles
HDC hdcBackBuffer;
HBITMAP hbmBackBuffer;
ULONG_PTR gdiplusToken;

// Sprite images
Image* imgBackground = NULL;
Image* imgGround = NULL;
Image* imgPipeGreen = NULL;
Image* imgBirdFrames[3] = {NULL, NULL, NULL};
Image* imgNumbers[10] = {NULL};
Image* imgGameOver = NULL;
Image* imgMessage = NULL;

// Get medal text based on score
const char* GetMedalText(int score) {
    if (score >= 40) return "PLATINUM";
    if (score >= 30) return "GOLD";
    if (score >= 20) return "SILVER";
    if (score >= 10) return "BRONZE";
    return NULL;
}

// Get medal color based on score
COLORREF GetMedalColor(int score) {
    if (score >= 40) return RGB(229, 228, 226);
    if (score >= 30) return RGB(255, 215, 0);
    if (score >= 20) return RGB(192, 192, 192);
    if (score >= 10) return RGB(205, 127, 50);
    return RGB(255, 255, 255);
}

// Load all sprite images
BOOL LoadImages() {
    imgBackground = Image::FromFile(L"assets/sprites_desktop/background-day.png");
    if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
    
    imgGround = Image::FromFile(L"assets/sprites_desktop/base.png");
    if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
    
    imgPipeGreen = Image::FromFile(L"assets/sprites_desktop/pipe-green.png");
    if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
    
    imgBirdFrames[0] = Image::FromFile(L"assets/sprites_desktop/yellowbird-downflap.png");
    imgBirdFrames[1] = Image::FromFile(L"assets/sprites_desktop/yellowbird-midflap.png");
    imgBirdFrames[2] = Image::FromFile(L"assets/sprites_desktop/yellowbird-upflap.png");
    for (int i = 0; i < 3; i++) {
        if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
    }
    
    WCHAR numPath[256];
    for (int i = 0; i < 10; i++) {
        swprintf(numPath, 256, L"assets/sprites_desktop/%d.png", i);
        imgNumbers[i] = Image::FromFile(numPath);
        if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
    }
    
    imgGameOver = Image::FromFile(L"assets/sprites_desktop/gameover.png");
    if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
    
    imgMessage = Image::FromFile(L"assets/sprites_desktop/message.png");
    if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
    
    return TRUE;
}

void InitGraphics(HWND hwnd) {
    GdiplusStartupInput gdiplusStartupInput;
    GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);
    
    HDC hdc = GetDC(hwnd);
    hdcBackBuffer = CreateCompatibleDC(hdc);
    hbmBackBuffer = CreateCompatibleBitmap(hdc, WINDOW_WIDTH, WINDOW_HEIGHT);
    SelectObject(hdcBackBuffer, hbmBackBuffer);
    ReleaseDC(hwnd, hdc);
    
    if (!LoadImages()) {
        MessageBox(hwnd, "Failed to load game sprites!\nMake sure assets/sprites_desktop folder exists.", "Error", MB_ICONERROR);
    }
}

void CleanupGraphics() {
    if (imgBackground) delete imgBackground;
    if (imgGround) delete imgGround;
    if (imgPipeGreen) delete imgPipeGreen;
    for (int i = 0; i < 3; i++) if (imgBirdFrames[i]) delete imgBirdFrames[i];
    for (int i = 0; i < 10; i++) if (imgNumbers[i]) delete imgNumbers[i];
    if (imgGameOver) delete imgGameOver;
    if (imgMessage) delete imgMessage;
    
    DeleteObject(hbmBackBuffer);
    DeleteDC(hdcBackBuffer);
    GdiplusShutdown(gdiplusToken);
}

void DrawParticles(Graphics* graphics) {
    for (int i = 0; i < MAX_PARTICLES; i++) {
        if (particles[i].life > 0) {
            int alpha = (particles[i].life * 255) / 40;
            if (alpha > 255) alpha = 255;
            
            Color color(alpha, GetRValue(particles[i].color), 
                       GetGValue(particles[i].color), GetBValue(particles[i].color));
            SolidBrush brush(color);
            graphics->FillEllipse(&brush, (int)particles[i].x, (int)particles[i].y, 4, 4);
        }
    }
}

void DrawScore(Graphics* graphics, int score, int centerX, int y) {
    char scoreStr[16];
    sprintf(scoreStr, "%d", score);
    int len = strlen(scoreStr);
    
    int totalWidth = 0;
    for (int i = 0; i < len; i++) {
        int digit = scoreStr[i] - '0';
        if (imgNumbers[digit]) totalWidth += imgNumbers[digit]->GetWidth();
    }
    
    int x = centerX - totalWidth / 2;
    for (int i = 0; i < len; i++) {
        int digit = scoreStr[i] - '0';
        if (imgNumbers[digit]) {
            graphics->DrawImage(imgNumbers[digit], x, y);
            x += imgNumbers[digit]->GetWidth();
        }
    }
}

void DrawGame(HDC hdc) {
    Graphics graphics(hdcBackBuffer);
    graphics.SetInterpolationMode(InterpolationModeNearestNeighbor);
    
    int shakeX = 0, shakeY = 0;
    if (game.screenShake > 0) {
        shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
        shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
    }
    
    // Draw background
    if (imgBackground) {
        graphics.DrawImage(imgBackground, shakeX, shakeY, (INT)WINDOW_WIDTH, (INT)WINDOW_HEIGHT);
    }
    
    // Draw pipes
    if (imgPipeGreen) {
        INT pipeW = (INT)imgPipeGreen->GetWidth();
        INT pipeH = (INT)imgPipeGreen->GetHeight();
        
        for (int i = 0; i < 3; i++) {
            INT pipeX = game.pipes[i].x + shakeX;
            INT topHeight = game.pipes[i].topHeight;
            
            // Top pipe (upside down) - position so bottom of image is at topHeight
            graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
            graphics.RotateTransform(180);
            graphics.DrawImage(imgPipeGreen, -(pipeW/2), 0, pipeW, pipeH);
            graphics.ResetTransform();
            
            // Bottom pipe - starts at topHeight + PIPE_GAP
            INT bottomPipeY = topHeight + PIPE_GAP + shakeY;
            graphics.DrawImage(imgPipeGreen, pipeX, bottomPipeY, pipeW, pipeH);
        }
    }
    
    // Draw ground (scrolling)
    if (imgGround) {
        INT groundW = (INT)imgGround->GetWidth();
        INT groundH = (INT)imgGround->GetHeight();
        INT groundY = WINDOW_HEIGHT - GROUND_HEIGHT;
        
        INT x = (INT)game.groundOffset + shakeX;
        while (x < WINDOW_WIDTH) {
            graphics.DrawImage(imgGround, x, groundY + shakeY);
            x += groundW;
        }
    }
    
    // Draw bird
    if (imgBirdFrames[game.birdFrame]) {
        graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
    }
    
    // Draw particles
    DrawParticles(&graphics);
    
    // Draw score
    if (game.started && !game.gameOver) {
        DrawScore(&graphics, game.score, WINDOW_WIDTH / 2, 30);
    }
    
    // Draw start message
    if (!game.started && imgMessage) {
        INT msgW = (INT)imgMessage->GetWidth();
        INT msgH = (INT)imgMessage->GetHeight();
        graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
    }
    
    // Draw game over
    if (game.gameOver) {
        if (imgGameOver) {
            INT goW = (INT)imgGameOver->GetWidth();
            graphics.DrawImage(imgGameOver, (WINDOW_WIDTH - goW) / 2, 80);
        }
        
        // Draw final score
        DrawScore(&graphics, game.score, WINDOW_WIDTH / 2, 200);
    }
    
    // Copy to screen
    BitBlt(hdc, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, hdcBackBuffer, 0, 0, SRCCOPY);
}
