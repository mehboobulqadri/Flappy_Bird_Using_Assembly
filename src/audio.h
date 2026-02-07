#ifndef AUDIO_H
#define AUDIO_H

#include <windows.h>
#include <mmsystem.h>

// Audio functions
void InitAudio();
void CleanupAudio();
void PlaySoundEffect(const char* soundName);

// Sound types
#define SOUND_WING "wing"
#define SOUND_POINT "point"
#define SOUND_HIT "hit"
#define SOUND_DIE "die"
#define SOUND_SWOOSH "swoosh"

#endif // AUDIO_H
