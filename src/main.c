#include <windows.h>
#include <stdlib.h>
#include <time.h>
#include "game.h"
#include "render.h"
#include "audio.h"

// Window procedure
LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
        case WM_CREATE: {
            // Initialize graphics
            InitGraphics(hwnd);
            
            // Initialize audio
            InitAudio();
            
            // Initialize game
            srand(time(NULL));
            InitGame();
            
            // Set timer for game loop (60 FPS)
            SetTimer(hwnd, 1, 16, NULL);
            break;
        }
        
        case WM_TIMER: {
            UpdateGame();
            InvalidateRect(hwnd, NULL, FALSE);
            break;
        }
        
        case WM_PAINT: {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);
            DrawGame(hdc);
            EndPaint(hwnd, &ps);
            break;
        }
        
        case WM_KEYDOWN: {
            switch (wParam) {
                case VK_SPACE:
                    if (!game.started) {
                        game.started = 1;
                        PlaySoundEffect(SOUND_SWOOSH);
                    }
                    if (game.bird.alive) {
                        game.bird.velocity = JUMP_STRENGTH;
                        PlaySoundEffect(SOUND_WING);
                    }
                    break;
                    
                case 'R':
                case 'r':
                    if (game.gameOver) {
                        InitGame();
                    }
                    break;
                    
                case VK_ESCAPE:
                    PostQuitMessage(0);
                    break;
            }
            break;
        }
        
        case WM_DESTROY: {
            // Cleanup
            KillTimer(hwnd, 1);
            CleanupAudio();
            CleanupGraphics();
            PostQuitMessage(0);
            break;
        }
        
        default:
            return DefWindowProc(hwnd, msg, wParam, lParam);
    }
    return 0;
}

// Main function
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, 
                   LPSTR lpCmdLine, int nCmdShow) {
    // Register window class
    WNDCLASSEX wc = {0};
    wc.cbSize = sizeof(WNDCLASSEX);
    wc.lpfnWndProc = WndProc;
    wc.hInstance = hInstance;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    wc.lpszClassName = "FlappyBirdClass";
    
    if (!RegisterClassEx(&wc)) {
        MessageBox(NULL, "Window Registration Failed!", "Error", MB_ICONERROR);
        return 0;
    }
    
    // Calculate window size
    RECT windowRect = {0, 0, WINDOW_WIDTH, WINDOW_HEIGHT};
    AdjustWindowRect(&windowRect, WS_OVERLAPPEDWINDOW, FALSE);
    
    // Create window
    HWND hwnd = CreateWindowEx(
        0,
        "FlappyBirdClass",
        "Flappy Bird - Press SPACE to Jump",
        WS_OVERLAPPEDWINDOW & ~WS_THICKFRAME & ~WS_MAXIMIZEBOX,
        CW_USEDEFAULT, CW_USEDEFAULT,
        windowRect.right - windowRect.left,
        windowRect.bottom - windowRect.top,
        NULL, NULL, hInstance, NULL
    );
    
    if (hwnd == NULL) {
        MessageBox(NULL, "Window Creation Failed!", "Error", MB_ICONERROR);
        return 0;
    }
    
    ShowWindow(hwnd, nCmdShow);
    UpdateWindow(hwnd);
    
    // Message loop
    MSG msg = {0};
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    
    return msg.wParam;
}
