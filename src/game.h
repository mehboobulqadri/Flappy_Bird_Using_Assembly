#ifndef GAME_H
#define GAME_H

#include <windows.h>

// Game constants (Desktop Resolution - 1280x720 Landscape)
#define WINDOW_WIDTH 1280
#define WINDOW_HEIGHT 720
#define BIRD_SIZE 60
#define BIRD_HITBOX_SIZE 48  // 20% smaller hitbox (60 * 0.8 = 48)
#define BIRD_X 350
#define PIPE_WIDTH 104
#define PIPE_GAP 200
#define BASE_PIPE_SPEED 4.0f
#define GRAVITY 0.8f
#define JUMP_STRENGTH -12.0f
#define GROUND_HEIGHT 112
#define MAX_VELOCITY 15
#define MAX_PARTICLES 50
#define HIGHSCORE_FILE "flappy_highscore.dat"

// Animation constants
#define BIRD_ANIMATION_SPEED 8
#define GROUND_SCROLL_SPEED 4

// Particle structure
typedef struct {
    float x, y;
    float vx, vy;
    int life;
    COLORREF color;
} Particle;

// Bird structure
typedef struct {
    float y;
    float velocity;
    int alive;
    float rotation;
} Bird;

// Pipe structure
typedef struct {
    int x;
    int topHeight;
    int scored;
} Pipe;

// Game state structure
typedef struct {
    Bird bird;
    Pipe pipes[3];
    int score;
    int highScore;
    int gameOver;
    int started;
    float pipeSpeed;
    int frameCount;
    float backgroundOffset;
    float groundOffset;
    int screenShake;
    int flashEffect;
    int birdFrame;  // Animation frame (0, 1, 2)
} GameState;

// Global game state
extern GameState game;
extern Particle particles[MAX_PARTICLES];

// Game functions
void InitGame();
void UpdateGame();
void ResetPipes();
void LoadHighScore();
void SaveHighScore();

// Particle functions
void AddParticle(float x, float y, COLORREF color);
void UpdateParticles();

#endif // GAME_H
