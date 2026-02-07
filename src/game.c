#include "game.h"
#include "audio.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Global game state
GameState game;
Particle particles[MAX_PARTICLES];

// Initialize game state
void InitGame() {
    game.bird.y = WINDOW_HEIGHT / 2.0f - 50;
    game.bird.velocity = 0;
    game.bird.alive = 1;
    game.bird.rotation = 0;
    game.score = 0;
    game.gameOver = 0;
    game.started = 0;
    game.pipeSpeed = BASE_PIPE_SPEED;
    game.frameCount = 0;
    game.backgroundOffset = 0;
    game.groundOffset = 0;
    game.screenShake = 0;
    game.flashEffect = 0;
    game.birdFrame = 0;
    
    LoadHighScore();
    ResetPipes();
    
    // Clear particles
    for (int i = 0; i < MAX_PARTICLES; i++) {
        particles[i].life = 0;
    }
}

// Reset pipes to initial positions
void ResetPipes() {
    for (int i = 0; i < 3; i++) {
        game.pipes[i].x = WINDOW_WIDTH + i * 400;  // Spacing for landscape
        // topHeight ranges for landscape layout
        // Total playable height = WINDOW_HEIGHT - GROUND_HEIGHT = 720 - 112 = 608
        // topHeight + PIPE_GAP (200) + bottom pipe should fit in 608 pixels
        // Range: 100 to 308 ensures gap always fits with room on both sides
        game.pipes[i].topHeight = 100 + rand() % 208;
        game.pipes[i].scored = 0;
    }
}

// Load high score from file
void LoadHighScore() {
    FILE* file = fopen(HIGHSCORE_FILE, "rb");
    if (file) {
        fread(&game.highScore, sizeof(int), 1, file);
        fclose(file);
    } else {
        game.highScore = 0;
    }
}

// Save high score to file
void SaveHighScore() {
    if (game.score > game.highScore) {
        game.highScore = game.score;
        FILE* file = fopen(HIGHSCORE_FILE, "wb");
        if (file) {
            fwrite(&game.highScore, sizeof(int), 1, file);
            fclose(file);
        }
    }
}

// Add a particle effect
void AddParticle(float x, float y, COLORREF color) {
    for (int i = 0; i < MAX_PARTICLES; i++) {
        if (particles[i].life <= 0) {
            particles[i].x = x;
            particles[i].y = y;
            particles[i].vx = (rand() % 100 - 50) / 10.0f;
            particles[i].vy = (rand() % 100 - 50) / 10.0f;
            particles[i].life = 20 + rand() % 20;
            particles[i].color = color;
            break;
        }
    }
}

// Update particles
void UpdateParticles() {
    for (int i = 0; i < MAX_PARTICLES; i++) {
        if (particles[i].life > 0) {
            particles[i].x += particles[i].vx;
            particles[i].y += particles[i].vy;
            particles[i].vy += 0.3f; // gravity
            particles[i].life--;
        }
    }
}

// Update game logic
void UpdateGame() {
    game.frameCount++;
    
    // Update effects
    if (game.screenShake > 0) game.screenShake--;
    if (game.flashEffect > 0) game.flashEffect--;
    
    // Update particles always
    UpdateParticles();
    
    // Update ground scrolling
    game.groundOffset -= GROUND_SCROLL_SPEED;
    if (game.groundOffset <= -WINDOW_WIDTH) game.groundOffset = 0;
    
    // Update bird animation
    if (game.frameCount % BIRD_ANIMATION_SPEED == 0) {
        game.birdFrame = (game.birdFrame + 1) % 3;
    }
    
    if (game.gameOver || !game.started) return;
    
    // Update bird physics
    game.bird.velocity += GRAVITY;
    
    // Cap maximum falling speed
    if (game.bird.velocity > MAX_VELOCITY) {
        game.bird.velocity = MAX_VELOCITY;
    }
    
    game.bird.y += game.bird.velocity;
    
    // Update bird rotation based on velocity
    game.bird.rotation = game.bird.velocity * 3;
    if (game.bird.rotation > 90) game.bird.rotation = 90;
    if (game.bird.rotation < -30) game.bird.rotation = -30;
    
    // Progressive difficulty - speed increases every 5 points
    game.pipeSpeed = BASE_PIPE_SPEED + (game.score / 5) * 0.5f;
    if (game.pipeSpeed > BASE_PIPE_SPEED + 3) game.pipeSpeed = BASE_PIPE_SPEED + 3;
    
    // Update background parallax
    game.backgroundOffset -= game.pipeSpeed * 0.3f;
    if (game.backgroundOffset < -WINDOW_WIDTH) game.backgroundOffset = 0;
    
    // Check ground and ceiling collision (using smaller hitbox)
    int hitboxOffset = (BIRD_SIZE - BIRD_HITBOX_SIZE) / 2;
    if (game.bird.y + hitboxOffset > WINDOW_HEIGHT - GROUND_HEIGHT - BIRD_HITBOX_SIZE || game.bird.y + hitboxOffset < 0) {
        game.gameOver = 1;
        game.bird.alive = 0;
        game.screenShake = 15;
        game.flashEffect = 10;
        SaveHighScore();
        PlaySoundEffect(SOUND_HIT);
        PlaySoundEffect(SOUND_DIE);
        
        // Create particles on death
        for (int i = 0; i < 15; i++) {
            AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 215, 0));
            AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 140, 0));
        }
    }
    
    // Update pipes
    for (int i = 0; i < 3; i++) {
        game.pipes[i].x -= (int)game.pipeSpeed;
        
        // Reset pipe when it goes off screen
        if (game.pipes[i].x < -PIPE_WIDTH) {
            game.pipes[i].x = WINDOW_WIDTH;
            // topHeight ranges for landscape: 100 to 308
            game.pipes[i].topHeight = 100 + rand() % 208;
            game.pipes[i].scored = 0;
        }
        
        // Score increment - when bird passes the pipe
        if (!game.pipes[i].scored && game.pipes[i].x + PIPE_WIDTH < BIRD_X) {
            game.score++;
            game.pipes[i].scored = 1;
            PlaySoundEffect(SOUND_POINT);
            
            // Particle effect on score
            for (int j = 0; j < 5; j++) {
                AddParticle(BIRD_X + BIRD_SIZE, game.bird.y + BIRD_SIZE/2, RGB(255, 255, 0));
            }
        }
        
        // Collision detection with pipes (using smaller hitbox for better gameplay)
        int hitboxOffset = (BIRD_SIZE - BIRD_HITBOX_SIZE) / 2;
        float birdHitboxY = game.bird.y + hitboxOffset;
        int birdHitboxX = BIRD_X + hitboxOffset;
        
        if (birdHitboxY < game.pipes[i].topHeight || 
            birdHitboxY + BIRD_HITBOX_SIZE > game.pipes[i].topHeight + PIPE_GAP) {
            if (birdHitboxX + BIRD_HITBOX_SIZE > game.pipes[i].x && 
                birdHitboxX < game.pipes[i].x + PIPE_WIDTH) {
                game.gameOver = 1;
                game.bird.alive = 0;
                game.screenShake = 15;
                game.flashEffect = 10;
                SaveHighScore();
                PlaySoundEffect(SOUND_HIT);
                PlaySoundEffect(SOUND_DIE);
                
                // Create particles on collision
                for (int j = 0; j < 20; j++) {
                    AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 0, 0));
                    AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 215, 0));
                }
            }
        }
    }
}
