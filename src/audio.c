#include "audio.h"
#include <stdio.h>
#include <string.h>

// Audio enabled flag
static BOOL audioEnabled = TRUE;

// Initialize audio system
void InitAudio() {
    // Check if audio is available
    UINT numDevices = waveOutGetNumDevs();
    if (numDevices == 0) {
        audioEnabled = FALSE;
        return;
    }
    audioEnabled = TRUE;
}

// Cleanup audio system
void CleanupAudio() {
    // Windows will automatically clean up PlaySound resources
}

// Play a sound effect asynchronously
void PlaySoundEffect(const char* soundName) {
    if (!audioEnabled) return;
    
    char filePath[256];
    sprintf(filePath, "assets\\audio\\%s.wav", soundName);
    
    // Play sound asynchronously without blocking
    PlaySound(filePath, NULL, SND_FILENAME | SND_ASYNC | SND_NODEFAULT);
}
