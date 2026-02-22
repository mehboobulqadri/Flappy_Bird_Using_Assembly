	.file	"audio.c"
	.intel_syntax noprefix

# ============================================================================
# FILE:    audio.asm
# SOURCE:  src/audio.c
# PURPOSE: Audio system for Flappy Bird
#          Handles sound device detection and async WAV playback.
#
# FUNCTIONS IN THIS FILE:
#   InitAudio()           - Check if audio hardware exists, set enabled flag
#   CleanupAudio()        - No-op (Windows cleans up PlaySound automatically)
#   PlaySoundEffect(name) - Build file path and play a .wav asynchronously
#
# HOW THIS FILE WAS GENERATED:
#   g++ -S -O0 -masm=intel -fno-omit-frame-pointer -fverbose-asm src/audio.c
#   Flags used:
#     -S              : stop after assembly generation (no linking)
#     -O0             : ZERO optimizations - code maps directly to C source
#     -masm=intel     : Intel syntax  (mov rax, 5)  not AT&T  (mov $5, %rax)
#     -fno-omit-frame-pointer : keep RBP-based stack frames for readability
#     -fverbose-asm   : compiler adds C variable names as inline comments
#
# WINDOWS x64 CALLING CONVENTION (Microsoft ABI):
#   - Integer/pointer arguments 1-4 go in: RCX, RDX, R8, R9
#   - Floating-point arguments 1-4 go in:  XMM0, XMM1, XMM2, XMM3
#   - Return value (integer/pointer) comes back in: RAX
#   - Return value (float/double) comes back in: XMM0
#   - Caller MUST reserve 32 bytes of "shadow space" on the stack before CALL
#   - Stack must be 16-byte aligned at point of every CALL instruction
#
# C++ NAME MANGLING:
#   The compiler mangles C++ function names to encode type information.
#   This lets the linker distinguish overloaded functions.
#   Demangled names are shown next to each symbol below.
#     _Z9InitAudiov          = InitAudio(void)
#     _Z12CleanupAudiov      = CleanupAudio(void)
#     _Z15PlaySoundEffectPKc = PlaySoundEffect(const char*)
#
# WINDOWS SEH (Structured Exception Handling) DIRECTIVES:
#   .seh_proc, .seh_pushreg, .seh_setframe, .seh_stackalloc,
#   .seh_endprologue, .seh_endproc
#   These emit metadata into the .pdata section so Windows knows how to
#   unwind the stack during exception handling. They do not generate
#   executable instructions - they are metadata only.
# ============================================================================


# ============================================================================
# DATA SECTION - Initialized global/static variables
# ============================================================================
	.text
	.data
	.align 4

# static BOOL audioEnabled = TRUE;
# 'static' means it is local to this file (not exported).
# BOOL is a 32-bit integer (typedef'd as int in windows.h).
# TRUE = 1, FALSE = 0.
# The mangled name _ZL12audioEnabled encodes: Z=mangled, L=local(static),
# 12=length of name, audioEnabled.
_ZL12audioEnabled:
	.long	1                       # Initial value = 1 (TRUE = audio enabled)


# ============================================================================
# TEXT SECTION - Executable code
# ============================================================================
	.text

# ----------------------------------------------------------------------------
# FUNCTION: InitAudio()
# C SOURCE: src/audio.c lines 9-17
#
# PURPOSE:  Detect whether a WAVE output device exists on this machine.
#           If yes  -> set audioEnabled = TRUE  (1)
#           If no   -> set audioEnabled = FALSE (0), so PlaySoundEffect is skipped
#
# PARAMETERS: none
# RETURNS:    void
#
# STACK FRAME LAYOUT (after prologue):
#
#   Higher addresses
#   +------------------+
#   | return address   |  [rbp + 8]   (pushed by CALL instruction)
#   +------------------+
#   | saved rbp        |  [rbp + 0]   (pushed by: push rbp)
#   +------------------+  <-- rbp points here after: mov rbp, rsp
#   | numDevices (UINT)|  [rbp - 4]   local variable: number of wave devices
#   +------------------+
#   | padding (12 B)   |  [rbp - 16]  alignment padding
#   +------------------+
#   | shadow space     |  [rbp - 48]  32 bytes reserved for callee use (Win64 ABI)
#   +------------------+  <-- rsp points here after: sub rsp, 48
#   Lower addresses
#
# REGISTER USAGE:
#   rax - scratch / return value from waveOutGetNumDevs()
#   rsp - stack pointer
#   rbp - base pointer (frame reference)
# ----------------------------------------------------------------------------
	.globl	_Z9InitAudiov           # Export symbol so other .o files can call InitAudio()
	.def	_Z9InitAudiov;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9InitAudiov   # Begin SEH unwind metadata for this function

_Z9InitAudiov:                          # === InitAudio() entry point ===

	# --- FUNCTION PROLOGUE ---
	# Standard x64 frame setup. Every function does this.
	push	rbp                     # Save caller's base pointer onto the stack
	.seh_pushreg	rbp             # (SEH metadata: we pushed rbp)
	mov	rbp, rsp                # Set rbp = current stack top (our frame base)
	.seh_setframe	rbp, 0          # (SEH metadata: rbp is frame pointer at offset 0)
	sub	rsp, 48                 # Allocate 48 bytes on stack:
	                                #   4 bytes for 'numDevices' local variable
	                                #   12 bytes padding (alignment)
	                                #   32 bytes shadow space (Win64 ABI requirement)
	.seh_stackalloc	48              # (SEH metadata: we allocated 48 bytes)
	.seh_endprologue                # (SEH metadata: prologue is done)

	# --- C LINE: UINT numDevices = waveOutGetNumDevs(); ---
	# waveOutGetNumDevs() is a Win32 API (winmm.dll) that returns the
	# number of WAVE audio output devices on this system.
	# It takes no arguments, returns UINT in EAX.
	# The __imp_ prefix means the call goes through the Windows import table
	# (dynamic linking to winmm.dll).
	mov	rax, QWORD PTR __imp_waveOutGetNumDevs[rip]  # Load the function pointer
	call	rax                     # Call waveOutGetNumDevs() -> result in EAX

	# Store the return value into numDevices (local var at [rbp-4])
	mov	DWORD PTR -4[rbp], eax  # numDevices = eax (number of audio devices found)

	# --- C LINE: if (numDevices == 0) { ---
	# Compare numDevices against 0 to see if any audio device exists
	cmp	DWORD PTR -4[rbp], 0    # Compare numDevices with 0
	jne	.L2                     # If numDevices != 0, jump to .L2 (audio is available)

	# --- C LINE: audioEnabled = FALSE;  (numDevices WAS 0 - no audio device) ---
	mov	DWORD PTR _ZL12audioEnabled[rip], 0  # audioEnabled = 0 (FALSE)

	# --- C LINE: return; ---
	jmp	.L1                     # Jump to function epilogue

.L2:
	# --- C LINE: audioEnabled = TRUE;  (numDevices > 0 - audio device exists) ---
	mov	DWORD PTR _ZL12audioEnabled[rip], 1  # audioEnabled = 1 (TRUE)

.L1:
	# --- FUNCTION EPILOGUE ---
	# Undo the prologue and return to caller.
	add	rsp, 48                 # Deallocate the 48 bytes we reserved
	pop	rbp                     # Restore caller's base pointer
	ret                             # Return to caller (pops return address from stack)
	.seh_endproc                    # (SEH metadata: function ends here)


# ----------------------------------------------------------------------------
# FUNCTION: CleanupAudio()
# C SOURCE: src/audio.c lines 20-22
#
# PURPOSE:  This is intentionally empty. The Win32 PlaySound API manages its
#           own resources. No manual cleanup is needed.
#           The function body is just a NOP (no operation).
#
# PARAMETERS: none
# RETURNS:    void
#
# STACK FRAME LAYOUT:
#   +------------------+
#   | return address   |  [rbp + 8]
#   +------------------+
#   | saved rbp        |  [rbp + 0]
#   +------------------+  <-- rbp
#   (no locals, no shadow space needed - no calls made)
# ----------------------------------------------------------------------------
	.globl	_Z12CleanupAudiov
	.def	_Z12CleanupAudiov;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z12CleanupAudiov

_Z12CleanupAudiov:                      # === CleanupAudio() entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	# NOTE: No 'sub rsp' here because this function makes no calls.
	# No shadow space is needed when you never CALL another function.

	# --- C LINE: } (empty function body) ---
	nop                             # No OPeration - placeholder for empty body

	# --- FUNCTION EPILOGUE ---
	pop	rbp                     # Restore caller's base pointer
	ret                             # Return to caller
	.seh_endproc


# ============================================================================
# READ-ONLY DATA SECTION - String constants (read-only, not modifiable)
# ============================================================================
	.section .rdata,"dr"

# Format string used by sprintf() to build the audio file path.
# "dr" = data, read-only
.LC0:
	.ascii "assets\\audio\\%s.wav\0"  # Null-terminated C string
	                                   # The %s will be replaced by the sound name
	                                   # e.g. "assets\audio\wing.wav"
	                                   # Note: \\ in .ascii = single backslash


# ============================================================================
# TEXT SECTION (back to code)
# ============================================================================
	.text

# ----------------------------------------------------------------------------
# FUNCTION: PlaySoundEffect(const char* soundName)
# C SOURCE: src/audio.c lines 25-33
#
# PURPOSE:  Build the full file path to a .wav file and play it asynchronously.
#           Example: soundName="wing" -> plays "assets\audio\wing.wav"
#           If audio is disabled (no device found), returns immediately.
#
# PARAMETERS:
#   RCX = const char* soundName  (e.g. "wing", "hit", "die", "point", "swoosh")
#
# RETURNS: void
#
# STACK FRAME LAYOUT:
#
#   This function has an unusual frame setup because of the large local buffer.
#   The compiler places rbp at offset 128 from rsp (instead of the top).
#
#   [rbp + 176] = soundName (parameter saved from RCX)
#   [rbp -  96] = filePath[256] - local char buffer for the constructed path
#
#   Full stack allocation: sub rsp, 288
#     = 256 bytes for filePath[]
#     + 16 bytes parameter save area
#     + 16 bytes padding/alignment
#
# REGISTER USAGE:
#   rcx, rdx, r8 - arguments to sprintf() and PlaySound()
#   rax          - address calculations, function pointers
#   eax          - audioEnabled flag value
#
# SOUND FLAGS FOR PlaySound():
#   SND_FILENAME  = 0x00020000 (131072) - pszSound is a file name
#   SND_ASYNC     = 0x00000001 (1)      - play asynchronously (don't block)
#   SND_NODEFAULT = 0x00000002 (2)      - if file not found, don't play default
#   Combined:  131072 | 1 | 2 = 131075  (= 0x00020003)
# ----------------------------------------------------------------------------
	.globl	_Z15PlaySoundEffectPKc
	.def	_Z15PlaySoundEffectPKc;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z15PlaySoundEffectPKc

_Z15PlaySoundEffectPKc:                 # === PlaySoundEffect(const char*) entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 288                # Allocate 288 bytes total for this frame
	.seh_stackalloc	288
	lea	rbp, 128[rsp]           # rbp = rsp + 128 (unusual: shifted base pointer)
	                                # This gives rbp space to reference both
	                                # locals below rbp AND parameters above rbp
	.seh_setframe	rbp, 128        # (SEH: frame pointer at rsp+128)
	.seh_endprologue

	# Save the incoming parameter (soundName pointer from RCX) onto the stack
	mov	QWORD PTR 176[rbp], rcx # [rbp+176] = soundName (save parameter)

	# --- C LINE: if (!audioEnabled) return; ---
	# Load the static audioEnabled flag and test if it's zero (disabled)
	mov	eax, DWORD PTR _ZL12audioEnabled[rip]  # eax = audioEnabled (0 or 1)
	test	eax, eax                # Bitwise AND eax with itself to set CPU flags
	                                # ZF (zero flag) = 1 if eax == 0
	je	.L9                     # Jump if ZF=1 (audioEnabled == FALSE) -> skip to end

	# --- C LINE: sprintf(filePath, "assets\\audio\\%s.wav", soundName); ---
	# Build:  filePath = "assets\audio\<soundName>.wav"
	# sprintf(char* buf, const char* fmt, ...) -> Win64: RCX=buf, RDX=fmt, R8=arg1
	mov	rcx, QWORD PTR 176[rbp] # rcx = soundName  (the %s argument)
	lea	rdx, .LC0[rip]          # rdx = address of format string "assets\\audio\\%s.wav"
	lea	rax, -96[rbp]           # rax = address of filePath buffer [rbp-96]
	mov	r8, rcx                 # r8  = soundName  (3rd argument to sprintf)
	mov	rcx, rax                # rcx = filePath   (1st argument: destination buffer)
	                                # rdx already = format string (2nd argument)
	call	__mingw_sprintf         # sprintf(filePath, "assets\\audio\\%s.wav", soundName)
	                                # Result stored in filePath[] at [rbp-96]

	# --- C LINE: PlaySound(filePath, NULL, SND_FILENAME | SND_ASYNC | SND_NODEFAULT); ---
	# Win32 PlaySound(LPCSTR pszSound, HMODULE hmod, DWORD fdwSound)
	# Win64 calling convention: RCX=arg1, RDX=arg2, R8=arg3
	lea	rax, -96[rbp]           # rax = address of filePath buffer
	mov	r8d, 131075             # r8d = flags: SND_FILENAME|SND_ASYNC|SND_NODEFAULT
	                                #       = 0x20000 | 0x1 | 0x2 = 0x20003 = 131075
	mov	edx, 0                  # rdx = NULL (hmod, not used with SND_FILENAME)
	mov	rcx, rax                # rcx = filePath (the .wav file path string)
	mov	rax, QWORD PTR __imp_PlaySoundA[rip]  # Load PlaySound function pointer
	call	rax                     # PlaySoundA(filePath, NULL, 131075)
	                                # This plays the .wav file in the background
	                                # and returns immediately (SND_ASYNC)

	jmp	.L5                     # Jump to epilogue

.L9:
	# audioEnabled was FALSE - skip sound playback entirely
	nop                             # No OPeration (placeholder for empty branch)

.L5:
	# --- FUNCTION EPILOGUE ---
	add	rsp, 288                # Deallocate the 288 bytes we reserved
	pop	rbp                     # Restore caller's base pointer
	ret                             # Return to caller
	.seh_endproc

	.ident	"GCC: (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) 15.2.0"
