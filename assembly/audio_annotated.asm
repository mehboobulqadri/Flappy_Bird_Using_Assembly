# ========================================================================
# FLAPPY BIRD - AUDIO MODULE (Annotated Assembly)
# ========================================================================
# This file contains the audio system for the Flappy Bird game.
# Generated from: src/audio.c
# Compiler: GCC 15.2.0 (MinGW-W64)
# Syntax: Intel (easier to read than AT&T)
# Architecture: x86-64 (64-bit Windows)
# ========================================================================

	.file	"audio.c"
	.intel_syntax noprefix    # Use Intel syntax instead of AT&T

# ========================================================================
# COMPILER METADATA
# ========================================================================
# GNU C++17 (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) version 15.2.0 (x86_64-w64-mingw32)
# compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64

# ========================================================================
# SECTION: .text (Executable Code)
# ========================================================================
	.text

# ========================================================================
# SECTION: .data (Initialized Data)
# ========================================================================
	.data
	.align 4                   # Align on 4-byte boundary for performance
	
# -----------------------------------------------------------------------
# STATIC VARIABLE: audioEnabled
# -----------------------------------------------------------------------
# C code: static BOOL audioEnabled = TRUE;
# Purpose: Tracks whether audio system is available and enabled
# Type: BOOL (4 bytes / DWORD)
# Initial value: 1 (TRUE)
# Storage: Static (file-scope, not visible to other modules)
# -----------------------------------------------------------------------
_ZL12audioEnabled:             # Mangled name for audioEnabled
	.long	1                  # Initialize to 1 (TRUE)

# ========================================================================
# SECTION: .text (Back to Code)
# ========================================================================
	.text

# ========================================================================
# FUNCTION: InitAudio()
# ========================================================================
# C Signature: void InitAudio()
# Purpose: Initialize the audio system and check if audio devices are available
# Parameters: None
# Returns: void
# Side Effects: Sets audioEnabled flag based on device availability
# ========================================================================
	.globl	_Z9InitAudiov         # Make function globally visible
	.def	_Z9InitAudiov;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9InitAudiov     # Start SEH (Structured Exception Handling) metadata

_Z9InitAudiov:                    # Function label
.LFB6484:                         # Local Function Begin label

	# -------------------------------------------------------------------
	# FUNCTION PROLOGUE: Set up stack frame
	# -------------------------------------------------------------------
	push	rbp                # Save old base pointer on stack
	.seh_pushreg	rbp        # SEH: Record that we pushed rbp
	mov	rbp, rsp               # Set base pointer to current stack pointer
	.seh_setframe	rbp, 0     # SEH: Record frame pointer setup
	sub	rsp, 48                # Allocate 48 bytes of stack space for local variables
	.seh_stackalloc	48         # SEH: Record stack allocation
	.seh_endprologue           # SEH: End of prologue metadata

	# -------------------------------------------------------------------
	# C code: UINT numDevices = waveOutGetNumDevs();
	# -------------------------------------------------------------------
	# Purpose: Query how many audio output devices are available
	# waveOutGetNumDevs() is a Windows API function from winmm.dll
	# Returns: Number of devices in EAX
	# -------------------------------------------------------------------
	mov	rax, QWORD PTR __imp_waveOutGetNumDevs[rip]  # Load address of waveOutGetNumDevs function
	                                                      # RIP-relative addressing for position-independent code
	call	rax                                      # Call waveOutGetNumDevs()
	
	# -------------------------------------------------------------------
	# Store return value (number of devices) to local variable
	# -------------------------------------------------------------------
	mov	DWORD PTR -4[rbp], eax   # Store numDevices at [rbp-4]
	                                  # Local variable at offset -4 from base pointer

	# -------------------------------------------------------------------
	# C code: if (numDevices == 0) {
	# -------------------------------------------------------------------
	# Purpose: Check if no audio devices are available
	# -------------------------------------------------------------------
	cmp	DWORD PTR -4[rbp], 0     # Compare numDevices with 0
	jne	.L2                      # If not equal (devices exist), jump to .L2

	# -------------------------------------------------------------------
	# TRUE BRANCH: No devices available
	# C code: audioEnabled = FALSE;
	# -------------------------------------------------------------------
	mov	DWORD PTR _ZL12audioEnabled[rip], 0  # Set audioEnabled to FALSE (0)
	
	# -------------------------------------------------------------------
	# C code: return;
	# -------------------------------------------------------------------
	jmp	.L1                      # Jump to function epilogue

.L2:
	# -------------------------------------------------------------------
	# FALSE BRANCH: Devices are available
	# C code: audioEnabled = TRUE;
	# -------------------------------------------------------------------
	mov	DWORD PTR _ZL12audioEnabled[rip], 1  # Set audioEnabled to TRUE (1)

.L1:
	# -------------------------------------------------------------------
	# FUNCTION EPILOGUE: Clean up and return
	# -------------------------------------------------------------------
	add	rsp, 48                  # Deallocate stack space (restore stack pointer)
	pop	rbp                      # Restore old base pointer
	ret                              # Return to caller
	.seh_endproc                    # End SEH metadata

# ========================================================================
# FUNCTION: CleanupAudio()
# ========================================================================
# C Signature: void CleanupAudio()
# Purpose: Clean up audio resources (currently does nothing as Windows handles cleanup)
# Parameters: None
# Returns: void
# Side Effects: None
# ========================================================================
	.globl	_Z12CleanupAudiov
	.def	_Z12CleanupAudiov;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z12CleanupAudiov

_Z12CleanupAudiov:
.LFB6485:
	# -------------------------------------------------------------------
	# FUNCTION PROLOGUE
	# -------------------------------------------------------------------
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue

	# -------------------------------------------------------------------
	# C code: // Windows will automatically clean up PlaySound resources
	# -------------------------------------------------------------------
	# This function body is empty - just a NOP (no operation)
	nop

	# -------------------------------------------------------------------
	# FUNCTION EPILOGUE
	# -------------------------------------------------------------------
	pop	rbp
	ret
	.seh_endproc

# ========================================================================
# SECTION: .rdata (Read-Only Data)
# ========================================================================
	.section .rdata,"dr"
	
# -----------------------------------------------------------------------
# STRING CONSTANT: File path format string
# -----------------------------------------------------------------------
# C code: "assets\\audio\\%s.wav"
# Purpose: Format string for sprintf to build audio file paths
# Note: Double backslash (\\) because \ is an escape character
# -----------------------------------------------------------------------
.LC0:
	.ascii "assets\\audio\\%s.wav\0"  # Null-terminated string

# ========================================================================
# SECTION: .text (Back to Code)
# ========================================================================
	.text

# ========================================================================
# FUNCTION: PlaySoundEffect(const char* soundName)
# ========================================================================
# C Signature: void PlaySoundEffect(const char* soundName)
# Purpose: Play a WAV sound effect asynchronously
# Parameters:
#   RCX = soundName (pointer to sound name string)
# Returns: void
# Side Effects: Plays sound if audio is enabled
# Calling Convention: x64 Windows (fastcall)
#   - First param in RCX
#   - Return value in RAX
# ========================================================================
	.globl	_Z15PlaySoundEffectPKc
	.def	_Z15PlaySoundEffectPKc;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z15PlaySoundEffectPKc

_Z15PlaySoundEffectPKc:
.LFB6486:
	# -------------------------------------------------------------------
	# FUNCTION PROLOGUE
	# -------------------------------------------------------------------
	push	rbp                      # Save base pointer
	.seh_pushreg	rbp
	sub	rsp, 288                 # Allocate 288 bytes for:
	                                  # - 256 bytes for filePath buffer
	                                  # - 32 bytes for shadow space (x64 calling convention)
	.seh_stackalloc	288
	lea	rbp, 128[rsp]            # Set base pointer 128 bytes into stack
	.seh_setframe	rbp, 128
	.seh_endprologue
	
	# -------------------------------------------------------------------
	# SAVE PARAMETER
	# -------------------------------------------------------------------
	mov	QWORD PTR 176[rbp], rcx  # Save soundName parameter at [rbp+176]

	# -------------------------------------------------------------------
	# C code: if (!audioEnabled) return;
	# -------------------------------------------------------------------
	# Purpose: Check if audio is enabled before trying to play sound
	# -------------------------------------------------------------------
	mov	eax, DWORD PTR _ZL12audioEnabled[rip]  # Load audioEnabled into EAX
	test	eax, eax                 # Test if EAX is 0 (bitwise AND with itself)
	                                  # ZF (Zero Flag) set if EAX == 0
	je	.L9                          # If zero (FALSE), jump to .L9 (early return)

	# -------------------------------------------------------------------
	# C code: sprintf(filePath, "assets\\audio\\%s.wav", soundName);
	# -------------------------------------------------------------------
	# Purpose: Build full file path by combining format string with soundName
	# Function: __mingw_sprintf(dest, format, arg)
	# Parameters (x64 Windows calling convention):
	#   RCX = dest (filePath buffer)
	#   RDX = format string
	#   R8  = soundName
	# -------------------------------------------------------------------
	mov	rcx, QWORD PTR 176[rbp]  # Load soundName into RCX
	lea	rdx, .LC0[rip]           # Load address of format string into RDX
	lea	rax, -96[rbp]            # Calculate address of filePath buffer [rbp-96]
	mov	r8, rcx                  # Move soundName to R8 (3rd parameter)
	mov	rcx, rax                 # Move filePath address to RCX (1st parameter)
	call	__mingw_sprintf          # Call sprintf to build file path

	# -------------------------------------------------------------------
	# C code: PlaySound(filePath, NULL, SND_FILENAME | SND_ASYNC | SND_NODEFAULT);
	# -------------------------------------------------------------------
	# Purpose: Play the WAV file asynchronously
	# Function: PlaySoundA(lpszName, hModule, fdwSound)
	# Parameters:
	#   RCX = lpszName (file path string)
	#   RDX = hModule (NULL - not using resource)
	#   R8  = fdwSound (flags)
	#         SND_FILENAME (0x00020000) = string is filename
	#         SND_ASYNC    (0x00000001) = play asynchronously
	#         SND_NODEFAULT(0x00000002) = don't play default sound if file not found
	#         Combined: 0x00020003 = 131075 decimal
	# -------------------------------------------------------------------
	lea	rax, -96[rbp]            # Load address of filePath into RAX
	mov	r8d, 131075              # Load flags (SND_FILENAME | SND_ASYNC | SND_NODEFAULT)
	mov	edx, 0                   # NULL for hModule
	mov	rcx, rax                 # filePath as first parameter
	mov	rax, QWORD PTR __imp_PlaySoundA[rip]  # Load address of PlaySoundA
	call	rax                      # Call PlaySoundA

	# -------------------------------------------------------------------
	# Jump to epilogue
	# -------------------------------------------------------------------
	jmp	.L5

.L9:
	# -------------------------------------------------------------------
	# EARLY RETURN LABEL (audio disabled)
	# -------------------------------------------------------------------
	nop                              # No operation - just placeholder

.L5:
	# -------------------------------------------------------------------
	# FUNCTION EPILOGUE
	# -------------------------------------------------------------------
	add	rsp, 288                 # Deallocate stack space
	pop	rbp                      # Restore base pointer
	ret                              # Return to caller
	.seh_endproc

# ========================================================================
# COMPILER IDENTIFICATION
# ========================================================================
	.ident	"GCC: (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) 15.2.0"

# ========================================================================
# END OF FILE
# ========================================================================
# Key Assembly Concepts Used:
# - Stack frames (rbp/rsp)
# - Function calling conventions (x64 Windows fastcall)
# - RIP-relative addressing (position-independent code)
# - SEH (Structured Exception Handling) for Windows
# - Shadow space (32 bytes required by x64 calling convention)
# - String operations (sprintf)
# - Windows API calls (waveOutGetNumDevs, PlaySoundA)
# ========================================================================
