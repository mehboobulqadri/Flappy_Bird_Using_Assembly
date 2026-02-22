	.file	"main.c"
	.intel_syntax noprefix

# ============================================================================
# FILE:    main.asm
# SOURCE:  src/main.c
# PURPOSE: Win32 window creation, message loop, and event handling
#          for Flappy Bird.
#
# FUNCTIONS IN THIS FILE:
#   WndProc(hwnd, msg, wParam, lParam) - Window procedure (message handler)
#   WinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow) - Entry point
#
# WINDOWS MESSAGE FLOW:
#   WinMain registers window class -> creates window -> enters message loop
#   OS sends messages to WndProc:
#     WM_CREATE  (1)   -> initialize graphics, audio, game; start 60fps timer
#     WM_TIMER   (275) -> called ~60 times/second: UpdateGame + redraw
#     WM_PAINT   (15)  -> called when window needs redraw: DrawGame
#     WM_KEYDOWN (256) -> SPACE=jump, R=restart, ESC=quit
#     WM_DESTROY (2)   -> cleanup and exit
#
# C++ NAME MANGLING (see audio.asm header for full explanation):
#   _Z7WndProcP6HWND__jyx      = WndProc(HWND*, unsigned int, long, long)
#   _Z12InitGraphicsP6HWND__   = InitGraphics(HWND*)
#   _Z9InitAudiov              = InitAudio(void)
#   _Z8InitGamev               = InitGame(void)
#   _Z10UpdateGamev            = UpdateGame(void)
#   _Z8DrawGameP5HDC__         = DrawGame(HDC*)
#   _Z15PlaySoundEffectPKc     = PlaySoundEffect(const char*)
#   _Z12CleanupAudiov          = CleanupAudio(void)
#   _Z15CleanupGraphicsv       = CleanupGraphics(void)
#
# WINDOWS x64 CALLING CONVENTION (see audio.asm header for full explanation):
#   Args 1-4:  RCX, RDX, R8, R9  (integers/pointers)
#   Args 5+:   pushed onto stack (right to left)
#   Return:    RAX
#   Caller must reserve 32-byte "shadow space" before each CALL
# ============================================================================


# ============================================================================
# READ-ONLY DATA SECTION - String constants and float constants
# ============================================================================
	.text
	.section .rdata,"dr"

	# GDI+ library constants (included via gdiplus.h in render.h)
	# These are used by the GDI+ initialization code in render.asm
	.align 4
_ZN7GdiplusL15FlatnessDefaultE:
	.long	1048576000              # GDI+ FlatnessDefault = 0.25f (IEEE 754)
	.align 4
_ZN7GdiplusL25GDIP_EMFPLUSFLAGS_DISPLAYE:
	.long	1                       # GDI+ EMF+ display flag

# Sound name strings (passed to PlaySoundEffect as the soundName argument)
.LC0:
	.ascii "swoosh\0"               # SOUND_SWOOSH - played when game starts
.LC2:
	.ascii "wing\0"                 # SOUND_WING   - played when bird flaps


# ============================================================================
# TEXT SECTION - Executable code
# ============================================================================
	.text

# ----------------------------------------------------------------------------
# FUNCTION: WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
# C SOURCE: src/main.c lines 9-81
#
# PURPOSE:  Windows "Window Procedure" - the callback function that Windows
#           calls every time something happens to our window (mouse click,
#           keyboard press, timer tick, paint request, etc.)
#           Each event type has a unique integer ID called a "message code".
#
# PARAMETERS (Windows x64 calling convention):
#   RCX = HWND hwnd     - handle to our window (an opaque pointer)
#   RDX = UINT msg      - message code (which event happened)
#   R8  = WPARAM wParam - message-specific data (e.g. which key was pressed)
#   R9  = LPARAM lParam - message-specific data (e.g. mouse coordinates)
#
# RETURNS:
#   RAX = LRESULT - result code (0 = handled, or DefWindowProc result)
#
# STACK FRAME LAYOUT (after prologue):
#
#   [rbp + 40] = lParam  (saved from R9)
#   [rbp + 32] = wParam  (saved from R8)
#   [rbp + 24] = msg     (saved from RDX, 32-bit)
#   [rbp + 16] = hwnd    (saved from RCX)
#   [rbp +  8] = return address
#   [rbp +  0] = saved rbp
#   [rbp -  8] = hdc     (local: HDC for WM_PAINT handler)
#   [rbp - 80] = ps      (local: PAINTSTRUCT, 72 bytes, for BeginPaint/EndPaint)
#
#   Total allocated: sub rsp, 112
#     = 8  bytes for hdc
#     = 72 bytes for PAINTSTRUCT ps
#     = 32 bytes shadow space
#
# HOW switch(msg) IS COMPILED:
#   A C 'switch' on non-contiguous values becomes a chain of CMP+JE/JA
#   instructions - a binary search tree. The compiler orders cases by value
#   to minimize the number of comparisons needed.
#   Message codes: WM_CREATE=1, WM_DESTROY=2, WM_PAINT=15,
#                  WM_KEYDOWN=256, WM_TIMER=275
# ----------------------------------------------------------------------------
	.globl	_Z7WndProcP6HWND__jyx
	.def	_Z7WndProcP6HWND__jyx;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z7WndProcP6HWND__jyx

_Z7WndProcP6HWND__jyx:                  # === WndProc() entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp                     # Save caller's frame pointer
	.seh_pushreg	rbp
	mov	rbp, rsp                # Establish our frame pointer
	.seh_setframe	rbp, 0
	sub	rsp, 112                # Allocate 112 bytes for locals + shadow space
	.seh_stackalloc	112
	.seh_endprologue

	# Save all 4 incoming parameters to stack (home/shadow area above rbp)
	mov	QWORD PTR 16[rbp], rcx  # [rbp+16] = hwnd
	mov	DWORD PTR 24[rbp], edx  # [rbp+24] = msg    (32-bit message code)
	mov	QWORD PTR 32[rbp], r8   # [rbp+32] = wParam (key code, timer ID, etc.)
	mov	QWORD PTR 40[rbp], r9   # [rbp+40] = lParam (extra data)

	# --- C LINE: switch (msg) { ---
	# The compiler generates a binary-search-style chain of comparisons.
	# It checks for WM_TIMER(275) first as a pivot, then branches left/right.
	#
	# Decision tree:
	#   msg == 275? -> .L2 (WM_TIMER)
	#   msg >  275? -> .L3 (default: DefWindowProc)
	#   msg == 256? -> .L4 (WM_KEYDOWN)
	#   msg >  256? -> .L3 (default)
	#   msg ==  15? -> .L5 (WM_PAINT)
	#   msg >   15? -> .L3 (default)
	#   msg ==   1? -> .L6 (WM_CREATE)
	#   msg ==   2? -> .L7 (WM_DESTROY)
	#   else        -> .L3 (default)

	cmp	DWORD PTR 24[rbp], 275  # Is msg == WM_TIMER (275)?
	je	.L2                     # Yes -> handle WM_TIMER
	cmp	DWORD PTR 24[rbp], 275  # Is msg > WM_TIMER?
	ja	.L3                     # Yes -> unhandled message, go to default
	cmp	DWORD PTR 24[rbp], 256  # Is msg == WM_KEYDOWN (256)?
	je	.L4                     # Yes -> handle WM_KEYDOWN
	cmp	DWORD PTR 24[rbp], 256  # Is msg > WM_KEYDOWN (and <= WM_TIMER)?
	ja	.L3                     # Yes -> unhandled, go to default
	cmp	DWORD PTR 24[rbp], 15   # Is msg == WM_PAINT (15)?
	je	.L5                     # Yes -> handle WM_PAINT
	cmp	DWORD PTR 24[rbp], 15   # Is msg > WM_PAINT (and < WM_KEYDOWN)?
	ja	.L3                     # Yes -> unhandled, go to default
	cmp	DWORD PTR 24[rbp], 1    # Is msg == WM_CREATE (1)?
	je	.L6                     # Yes -> handle WM_CREATE
	cmp	DWORD PTR 24[rbp], 2    # Is msg == WM_DESTROY (2)?
	je	.L7                     # Yes -> handle WM_DESTROY
	jmp	.L3                     # No match -> default handler

# ============================================================
# CASE WM_CREATE (1): Window was just created
# C SOURCE: src/main.c lines 11-25
# ============================================================
.L6:
	# --- C LINE: InitGraphics(hwnd); ---
	# Set up GDI+ back buffer for double-buffered rendering
	mov	rax, QWORD PTR 16[rbp]  # rax = hwnd
	mov	rcx, rax                # rcx = hwnd (1st argument)
	call	_Z12InitGraphicsP6HWND__ # InitGraphics(hwnd)

	# --- C LINE: InitAudio(); ---
	# Check for audio devices, set audioEnabled flag
	call	_Z9InitAudiov           # InitAudio()

	# --- C LINE: srand(time(NULL)); ---
	# Seed the random number generator with current time
	# time(NULL) returns seconds since Unix epoch (Jan 1, 1970)
	mov	ecx, 0                  # NULL (pass 0 as pointer argument)
	call	_time64                 # time(NULL) -> timestamp in RAX

	# srand(unsigned int seed) -> Win64: seed in ECX
	mov	ecx, eax                # ecx = (unsigned int)timestamp (lower 32 bits)
	call	srand                   # srand(time(NULL)) - seed random generator

	# --- C LINE: InitGame(); ---
	# Initialize all game state (bird position, pipes, score, etc.)
	call	_Z8InitGamev            # InitGame()

	# --- C LINE: SetTimer(hwnd, 1, 16, NULL); ---
	# SetTimer creates a repeating timer that sends WM_TIMER messages.
	# Timer fires every 16ms ~ 62.5 fps (close to 60fps target).
	# Win32 SetTimer(HWND, UINT_PTR nIDEvent, UINT uElapse, TIMERPROC)
	# Win64 args: RCX=hwnd, RDX=timerID, R8=interval_ms, R9=callback
	mov	rax, QWORD PTR 16[rbp]  # rax = hwnd
	mov	r9d, 0                  # r9  = NULL (no callback, use WM_TIMER messages)
	mov	r8d, 16                 # r8  = 16 milliseconds per tick
	mov	edx, 1                  # rdx = timer ID = 1
	mov	rcx, rax                # rcx = hwnd
	mov	rax, QWORD PTR __imp_SetTimer[rip]  # Load SetTimer function pointer
	call	rax                     # SetTimer(hwnd, 1, 16, NULL)

	jmp	.L8                     # -> break (go to end of switch)

# ============================================================
# CASE WM_TIMER (275): Timer fired (~60 times per second)
# C SOURCE: src/main.c lines 27-31
# ============================================================
.L2:
	# --- C LINE: UpdateGame(); ---
	# Advance all game state by one frame:
	# - Apply gravity to bird, move bird
	# - Move pipes, check if pipe passed (score++)
	# - Detect collisions (bird vs pipe, bird vs ground)
	# - Update particles, screen shake, animation frame
	call	_Z10UpdateGamev         # UpdateGame()

	# --- C LINE: InvalidateRect(hwnd, NULL, FALSE); ---
	# Tell Windows that the entire window needs to be redrawn.
	# This causes Windows to send a WM_PAINT message.
	# Win32 InvalidateRect(HWND, const RECT*, BOOL bErase)
	# NULL rect = entire window, FALSE = don't erase background (we draw everything)
	mov	rax, QWORD PTR 16[rbp]  # rax = hwnd
	mov	r8d, 0                  # r8  = FALSE (don't erase - we draw full frame)
	mov	edx, 0                  # rdx = NULL (invalidate entire window)
	mov	rcx, rax                # rcx = hwnd
	mov	rax, QWORD PTR __imp_InvalidateRect[rip]
	call	rax                     # InvalidateRect(hwnd, NULL, FALSE)

	jmp	.L8                     # -> break

# ============================================================
# CASE WM_PAINT (15): Window needs to be redrawn
# C SOURCE: src/main.c lines 33-39
# ============================================================
.L5:
	# --- C LINE: HDC hdc = BeginPaint(hwnd, &ps); ---
	# BeginPaint prepares the window for painting:
	# - Validates the "dirty" region set by InvalidateRect
	# - Returns an HDC (Handle to Device Context) for drawing
	# - Fills the PAINTSTRUCT ps with info about what needs painting
	# ps (PAINTSTRUCT) is stored at [rbp-80], it's 72 bytes
	lea	rdx, -80[rbp]           # rdx = &ps (address of PAINTSTRUCT local variable)
	mov	rax, QWORD PTR 16[rbp]  # rax = hwnd
	mov	rcx, rax                # rcx = hwnd
	mov	rax, QWORD PTR __imp_BeginPaint[rip]
	call	rax                     # BeginPaint(hwnd, &ps) -> HDC in RAX
	mov	QWORD PTR -8[rbp], rax  # hdc = RAX (save the device context handle)

	# --- C LINE: DrawGame(hdc); ---
	# Draw the entire game frame to the back buffer, then blit to screen
	mov	rax, QWORD PTR -8[rbp]  # rax = hdc
	mov	rcx, rax                # rcx = hdc (1st argument)
	call	_Z8DrawGameP5HDC__      # DrawGame(hdc)

	# --- C LINE: EndPaint(hwnd, &ps); ---
	# EndPaint releases the device context and marks painting complete
	lea	rdx, -80[rbp]           # rdx = &ps
	mov	rax, QWORD PTR 16[rbp]  # rax = hwnd
	mov	rcx, rax                # rcx = hwnd
	mov	rax, QWORD PTR __imp_EndPaint[rip]
	call	rax                     # EndPaint(hwnd, &ps)

	jmp	.L8                     # -> break

# ============================================================
# CASE WM_KEYDOWN (256): A key was pressed
# C SOURCE: src/main.c lines 41-66
# ============================================================
.L4:
	# wParam contains the Virtual Key code of the key that was pressed.
	# Virtual Key codes: VK_SPACE=32, VK_ESCAPE=27, 'R'=82, 'r'=114
	#
	# switch(wParam) - another binary search:
	#   wParam == 114 ('r') -> .L9 (restart)
	#   wParam >  114       -> .L16 (unknown key, break)
	#   wParam ==  82 ('R') -> .L9 (restart)
	#   wParam >   82       -> .L16 (unknown key, break)
	#   wParam ==  27 (ESC) -> .L11 (quit)
	#   wParam ==  32 (SPC) -> SPACE handler
	#   else                -> .L16 (unknown key, break)

	cmp	QWORD PTR 32[rbp], 114  # Is wParam == 'r' (114)?
	je	.L9                     # Yes -> handle R/r (restart)
	cmp	QWORD PTR 32[rbp], 114  # Is wParam > 'r'?
	ja	.L16                    # Yes -> unrecognized key, break
	cmp	QWORD PTR 32[rbp], 82   # Is wParam == 'R' (82)?
	je	.L9                     # Yes -> handle R/r (restart)
	cmp	QWORD PTR 32[rbp], 82   # Is wParam > 'R' (and < 'r')?
	ja	.L16                    # Yes -> unrecognized key
	cmp	QWORD PTR 32[rbp], 27   # Is wParam == VK_ESCAPE (27)?
	je	.L11                    # Yes -> handle ESC (quit)
	cmp	QWORD PTR 32[rbp], 32   # Is wParam == VK_SPACE (32)?
	jne	.L16                    # No  -> unrecognized key

	# --- SPACE KEY HANDLER ---
	# C: if (!game.started) { game.started = 1; PlaySoundEffect(SOUND_SWOOSH); }

	# game is a global struct. In main.asm it's accessed via .refptr.game
	# (an indirection pointer because game is defined in game.asm).
	# game.started is at offset 64 from the start of the GameState struct.
	mov	rax, QWORD PTR .refptr.game[rip]  # rax = address of 'game' global struct
	mov	eax, DWORD PTR 64[rax]  # eax = game.started (offset 64 in GameState)
	test	eax, eax                # Is game.started == 0?
	jne	.L12                    # Not zero -> game already started, skip

	# --- C LINE: game.started = 1; ---
	mov	rax, QWORD PTR .refptr.game[rip]
	mov	DWORD PTR 64[rax], 1    # game.started = 1 (mark game as started)

	# --- C LINE: PlaySoundEffect(SOUND_SWOOSH); ---
	lea	rax, .LC0[rip]          # rax = address of "swoosh" string
	mov	rcx, rax                # rcx = "swoosh" (1st argument)
	call	_Z15PlaySoundEffectPKc  # PlaySoundEffect("swoosh")

.L12:
	# --- C LINE: if (game.bird.alive) { game.bird.velocity = JUMP_STRENGTH; ... } ---
	# game.bird.alive is at offset 8 in GameState (bird.y=0, bird.velocity=4, bird.alive=8)
	mov	rax, QWORD PTR .refptr.game[rip]
	mov	eax, DWORD PTR 8[rax]   # eax = game.bird.alive (1=alive, 0=dead)
	test	eax, eax                # Is bird alive?
	je	.L17                    # No (dead) -> skip jump

	# --- C LINE: game.bird.velocity = JUMP_STRENGTH; (-12.0f) ---
	# .LC1 holds -12.0f as IEEE 754 = 0xC1400000 = -1052770304 (signed int)
	# movss loads a 32-bit float into an XMM register
	mov	rax, QWORD PTR .refptr.game[rip]
	movss	xmm0, DWORD PTR .LC1[rip]  # xmm0 = -12.0f (JUMP_STRENGTH)
	movss	DWORD PTR 4[rax], xmm0    # game.bird.velocity = -12.0f
	                                   # (offset 4 in GameState = bird.velocity)
	                                   # Negative = upward movement (Y axis is down)

	# --- C LINE: PlaySoundEffect(SOUND_WING); ---
	lea	rax, .LC2[rip]          # rax = address of "wing" string
	mov	rcx, rax                # rcx = "wing" (1st argument)
	call	_Z15PlaySoundEffectPKc  # PlaySoundEffect("wing")

	jmp	.L17                    # -> break (end of SPACE handler)

	# --- R / r KEY HANDLER ---
	# C: if (game.gameOver) { InitGame(); }
.L9:
	# game.gameOver is at offset 60 in GameState
	mov	rax, QWORD PTR .refptr.game[rip]
	mov	eax, DWORD PTR 60[rax]  # eax = game.gameOver
	test	eax, eax                # Is game over?
	je	.L18                    # No -> don't restart, skip

	# --- C LINE: InitGame(); ---
	call	_Z8InitGamev            # InitGame() - reset all game state

	jmp	.L18                    # -> break

	# --- ESC KEY HANDLER ---
	# C: PostQuitMessage(0);
.L11:
	# PostQuitMessage puts a WM_QUIT message in the message queue.
	# WM_QUIT causes GetMessage() to return 0, ending the message loop.
	mov	ecx, 0                  # ecx = exit code 0
	mov	rax, QWORD PTR __imp_PostQuitMessage[rip]
	call	rax                     # PostQuitMessage(0)

	jmp	.L10                    # -> break

.L17:                                   # End of SPACE handler
	nop
	jmp	.L16                    # -> break
.L18:                                   # End of R handler
	nop
.L10:                                   # End of ESC handler
	jmp	.L16                    # -> break

# ============================================================
# CASE WM_DESTROY (2): Window is being destroyed (user closed it)
# C SOURCE: src/main.c lines 68-75
# ============================================================
.L7:
	# --- C LINE: KillTimer(hwnd, 1); ---
	# Stop the 60fps timer we created in WM_CREATE
	mov	rax, QWORD PTR 16[rbp]  # rax = hwnd
	mov	edx, 1                  # rdx = timer ID = 1 (same ID we used in SetTimer)
	mov	rcx, rax                # rcx = hwnd
	mov	rax, QWORD PTR __imp_KillTimer[rip]
	call	rax                     # KillTimer(hwnd, 1)

	# --- C LINE: CleanupAudio(); ---
	call	_Z12CleanupAudiov       # CleanupAudio() (no-op, but good practice)

	# --- C LINE: CleanupGraphics(); ---
	# Free GDI+ objects, delete back buffer bitmap, shutdown GDI+
	call	_Z15CleanupGraphicsv    # CleanupGraphics()

	# --- C LINE: PostQuitMessage(0); ---
	mov	ecx, 0                  # exit code = 0
	mov	rax, QWORD PTR __imp_PostQuitMessage[rip]
	call	rax                     # PostQuitMessage(0) -> ends message loop

	jmp	.L8                     # -> break

# ============================================================
# DEFAULT CASE: Unrecognized message -> let Windows handle it
# C SOURCE: src/main.c line 78
# ============================================================
.L3:
	# --- C LINE: return DefWindowProc(hwnd, msg, wParam, lParam); ---
	# DefWindowProc provides default handling for messages we don't handle.
	# For example: WM_MOVE, WM_SIZE, WM_MOUSEMOVE, etc.
	# Win32: DefWindowProc(HWND, UINT, WPARAM, LPARAM)
	# Win64: RCX=hwnd, RDX=msg, R8=wParam, R9=lParam
	mov	r8, QWORD PTR 40[rbp]   # r8  = lParam  (NOTE: loaded as r8 first)
	mov	rcx, QWORD PTR 32[rbp]  # rcx = wParam  (temporary)
	mov	edx, DWORD PTR 24[rbp]  # rdx = msg
	mov	rax, QWORD PTR 16[rbp]  # rax = hwnd
	mov	r9, r8                  # r9  = lParam  (final position)
	mov	r8, rcx                 # r8  = wParam  (final position)
	mov	rcx, rax                # rcx = hwnd    (final position)
	mov	rax, QWORD PTR __imp_DefWindowProcA[rip]
	call	rax                     # DefWindowProcA(hwnd, msg, wParam, lParam)
	# Return value in RAX is forwarded as our return value

	jmp	.L15                    # Jump to epilogue (preserve RAX as return value)

.L16:                                   # End of WM_KEYDOWN switch (unknown key)
	nop
.L8:                                    # End of outer switch - handled cases return 0
	# --- C LINE: return 0; ---
	mov	eax, 0                  # Return value = 0 (message handled)

.L15:
	# --- FUNCTION EPILOGUE ---
	add	rsp, 112                # Deallocate locals + shadow space
	pop	rbp                     # Restore caller's frame pointer
	ret                             # Return to Windows (which dispatched the message)
	.seh_endproc


# ============================================================================
# READ-ONLY DATA SECTION - More string/float constants for WinMain
# ============================================================================
	.section .rdata,"dr"

# Window class name - identifies this window type to Windows
.LC3:
	.ascii "FlappyBirdClass\0"      # Window class name string

# Error dialog strings
.LC4:
	.ascii "Error\0"                # MessageBox title
.LC5:
	.ascii "Window Registration Failed!\0"  # Error message for RegisterClassEx fail

# Window title bar text
	.align 8
.LC6:
	.ascii "Flappy Bird - Press SPACE to Jump\0"

# Error message for CreateWindowEx fail
.LC7:
	.ascii "Window Creation Failed!\0"


# ============================================================================
# TEXT SECTION (back to code)
# ============================================================================
	.text

# ----------------------------------------------------------------------------
# FUNCTION: WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
#                   LPSTR lpCmdLine, int nCmdShow)
# C SOURCE: src/main.c lines 84-132
#
# PURPOSE:  The Windows application entry point (equivalent to main() in
#           console apps). Responsible for:
#           1. Registering the window class (tells Windows about WndProc)
#           2. Creating the window (allocates the Win32 window object)
#           3. Showing the window
#           4. Running the message loop until the user quits
#
# PARAMETERS (Win64 calling convention):
#   RCX = HINSTANCE hInstance     - handle to this executable in memory
#   RDX = HINSTANCE hPrevInstance - always NULL in modern Windows
#   R8  = LPSTR lpCmdLine         - command line arguments string
#   R9  = int nCmdShow            - how to display window (SW_SHOW, etc.)
#
# RETURNS:
#   RAX = int (exit code, from msg.wParam)
#
# STACK FRAME LAYOUT (after prologue):
#
#   This function uses a shifted frame: rbp is at rsp+128.
#
#   [rbp + 168] = nCmdShow    (from R9d)
#   [rbp + 160] = lpCmdLine   (from R8)
#   [rbp + 152] = hPrevInstance (from RDX)
#   [rbp + 144] = hInstance   (from RCX)
#   [rbp + 120] = hwnd        (local: created window handle)
#   [rbp +  96] = wc.lpszClassName (WNDCLASSEX field)
#   [rbp +  80] = wc.hbrBackground
#   [rbp +  72] = wc.hCursor
#   [rbp +  56] = wc.hInstance
#   [rbp +  40] = wc.lpfnWndProc
#   [rbp +  32] = wc.cbSize   (start of WNDCLASSEX struct)
#   [rbp +  28] = windowRect.bottom
#   [rbp +  24] = windowRect.right
#   [rbp +  20] = windowRect.top
#   [rbp +  16] = windowRect.left
#   [rbp -  16] = msg (start of MSG struct, 48 bytes total)
#
# WNDCLASSEX STRUCTURE (80 bytes total, at [rbp+32]):
#   offset  0: cbSize       (UINT, 4 bytes)  = sizeof(WNDCLASSEX) = 80
#   offset  4: style        (UINT, 4 bytes)  = 0 (default)
#   offset  8: lpfnWndProc  (pointer, 8 bytes) = &WndProc
#   offset 16: cbClsExtra   (int, 4 bytes)   = 0
#   offset 20: cbWndExtra   (int, 4 bytes)   = 0
#   offset 24: hInstance    (pointer, 8 bytes) = hInstance
#   offset 32: hIcon        (pointer, 8 bytes) = NULL
#   offset 40: hCursor      (pointer, 8 bytes) = arrow cursor
#   offset 48: hbrBackground (pointer, 8 bytes) = COLOR_WINDOW+1
#   offset 56: lpszMenuName (pointer, 8 bytes) = NULL
#   offset 64: lpszClassName (pointer, 8 bytes) = "FlappyBirdClass"
#   offset 72: hIconSm      (pointer, 8 bytes) = NULL
# ----------------------------------------------------------------------------
	.globl	WinMain                 # WinMain is the Windows GUI application entry point
	.def	WinMain;	.scl	2;	.type	32;	.endef
	.seh_proc	WinMain

WinMain:                                # === WinMain() entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 256                # Allocate 256 bytes (large frame for WNDCLASSEX + MSG)
	.seh_stackalloc	256
	lea	rbp, 128[rsp]           # Shifted frame: rbp = rsp + 128
	.seh_setframe	rbp, 128
	.seh_endprologue

	# Save incoming parameters to their stack slots
	mov	QWORD PTR 144[rbp], rcx # hInstance
	mov	QWORD PTR 152[rbp], rdx # hPrevInstance (unused)
	mov	QWORD PTR 160[rbp], r8  # lpCmdLine (unused)
	mov	DWORD PTR 168[rbp], r9d # nCmdShow

	# --- C LINE: WNDCLASSEX wc = {0}; ---
	# Zero-initialize the entire 80-byte WNDCLASSEX struct at [rbp+32].
	# MOVAPS moves 16 bytes (128 bits) at once using XMM registers.
	# 5 * 16 = 80 bytes cleared with 5 instructions.
	pxor	xmm0, xmm0              # xmm0 = 0x00000000000000000000000000000000
	movaps	XMMWORD PTR 32[rbp], xmm0  # Clear wc bytes  0-15
	movaps	XMMWORD PTR 48[rbp], xmm0  # Clear wc bytes 16-31
	movaps	XMMWORD PTR 64[rbp], xmm0  # Clear wc bytes 32-47
	movaps	XMMWORD PTR 80[rbp], xmm0  # Clear wc bytes 48-63
	movaps	XMMWORD PTR 96[rbp], xmm0  # Clear wc bytes 64-79

	# --- C LINE: wc.cbSize = sizeof(WNDCLASSEX); ---
	# sizeof(WNDCLASSEX) = 80 bytes
	mov	DWORD PTR 32[rbp], 80   # wc.cbSize = 80 (at offset 0 in struct = rbp+32)

	# --- C LINE: wc.lpfnWndProc = WndProc; ---
	# Store a pointer to our WndProc function in the struct
	lea	rax, _Z7WndProcP6HWND__jyx[rip]  # rax = address of WndProc
	mov	QWORD PTR 40[rbp], rax  # wc.lpfnWndProc = &WndProc (at offset 8)

	# --- C LINE: wc.hInstance = hInstance; ---
	mov	rax, QWORD PTR 144[rbp] # rax = hInstance
	mov	QWORD PTR 56[rbp], rax  # wc.hInstance = hInstance (at offset 24)

	# --- C LINE: wc.hCursor = LoadCursor(NULL, IDC_ARROW); ---
	# IDC_ARROW = 32512 = standard arrow cursor resource ID
	mov	edx, 32512              # rdx = IDC_ARROW (cursor resource ID)
	mov	ecx, 0                  # rcx = NULL (load from system, not a specific module)
	mov	rax, QWORD PTR __imp_LoadCursorA[rip]
	call	rax                     # LoadCursorA(NULL, IDC_ARROW) -> cursor handle in RAX
	mov	QWORD PTR 72[rbp], rax  # wc.hCursor = cursor handle (at offset 40)

	# --- C LINE: wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1); ---
	# COLOR_WINDOW = 5, so COLOR_WINDOW+1 = 6
	# When cast to HBRUSH, Windows treats small integers as system color indices
	mov	QWORD PTR 80[rbp], 6    # wc.hbrBackground = 6 (at offset 48)

	# --- C LINE: wc.lpszClassName = "FlappyBirdClass"; ---
	lea	rax, .LC3[rip]          # rax = address of "FlappyBirdClass" string
	mov	QWORD PTR 96[rbp], rax  # wc.lpszClassName = "FlappyBirdClass" (at offset 64)

	# --- C LINE: if (!RegisterClassEx(&wc)) { ...error... } ---
	# RegisterClassEx tells Windows about our window class (including WndProc callback)
	lea	rax, 32[rbp]            # rax = &wc (address of WNDCLASSEX struct)
	mov	rcx, rax                # rcx = &wc (1st argument)
	mov	rax, QWORD PTR __imp_RegisterClassExA[rip]
	call	rax                     # RegisterClassExA(&wc) -> ATOM (0 = failure)

	# Check return value (AX = 0 means failure)
	test	ax, ax                  # Test lower 16 bits of return (ATOM is 16-bit)
	sete	al                      # al = 1 if AX==0 (failure), 0 if success
	test	al, al                  # Test the failure flag
	je	.L20                    # If al==0 (success), jump past error handling

	# Registration failed - show error and return 0
	lea	rdx, .LC4[rip]          # rdx = "Error" (MessageBox title)
	lea	rax, .LC5[rip]          # rax = "Window Registration Failed!" (message)
	mov	r9d, 16                 # r9  = MB_ICONERROR (16) - error icon
	mov	r8, rdx                 # r8  = title = "Error"
	mov	rdx, rax                # rdx = message text
	mov	ecx, 0                  # rcx = NULL (no parent window)
	mov	rax, QWORD PTR __imp_MessageBoxA[rip]
	call	rax                     # MessageBoxA(NULL, "...", "Error", MB_ICONERROR)
	mov	eax, 0                  # Return value = 0
	jmp	.L25                    # Jump to epilogue

.L20:
	# --- C LINE: RECT windowRect = {0, 0, WINDOW_WIDTH, WINDOW_HEIGHT}; ---
	# RECT has 4 LONG (32-bit) fields: left, top, right, bottom
	mov	DWORD PTR 16[rbp], 0    # windowRect.left   = 0
	mov	DWORD PTR 20[rbp], 0    # windowRect.top    = 0
	mov	DWORD PTR 24[rbp], 1280 # windowRect.right  = WINDOW_WIDTH  = 1280
	mov	DWORD PTR 28[rbp], 720  # windowRect.bottom = WINDOW_HEIGHT = 720

	# --- C LINE: AdjustWindowRect(&windowRect, WS_OVERLAPPEDWINDOW, FALSE); ---
	# AdjustWindowRect expands the RECT to include title bar, borders, etc.
	# so that the CLIENT area (game area) is exactly WINDOW_WIDTH x WINDOW_HEIGHT.
	# WS_OVERLAPPEDWINDOW = 0xCF0000 = 13565952 (window style with borders)
	lea	rax, 16[rbp]            # rax = &windowRect
	mov	r8d, 0                  # r8  = FALSE (not a menu)
	mov	edx, 13565952           # rdx = WS_OVERLAPPEDWINDOW style flags
	mov	rcx, rax                # rcx = &windowRect
	mov	rax, QWORD PTR __imp_AdjustWindowRect[rip]
	call	rax                     # AdjustWindowRect(&windowRect, WS_OVERLAPPEDWINDOW, 0)
	# windowRect now has the total window dimensions (including decorations)

	# --- C LINE: HWND hwnd = CreateWindowEx(...); ---
	# Compute window dimensions: width = right - left, height = bottom - top
	mov	edx, DWORD PTR 28[rbp]  # edx = windowRect.bottom
	mov	eax, DWORD PTR 20[rbp]  # eax = windowRect.top
	sub	edx, eax                # edx = height = bottom - top
	mov	r8d, edx                # r8d = height (will be 8th arg, but prepared here)

	mov	edx, DWORD PTR 24[rbp]  # edx = windowRect.right
	mov	eax, DWORD PTR 16[rbp]  # eax = windowRect.left
	mov	ecx, edx                # ecx = right
	sub	ecx, eax                # ecx = width = right - left

	# CreateWindowEx has 12 parameters - first 4 in registers, rest on stack
	# Win32 CreateWindowEx(dwExStyle, lpClassName, lpWindowName, dwStyle,
	#                      x, y, nWidth, nHeight, hWndParent, hMenu,
	#                      hInstance, lpParam)
	lea	r10, .LC6[rip]          # r10 = "Flappy Bird - Press SPACE to Jump"
	lea	rax, .LC3[rip]          # rax = "FlappyBirdClass"

	# Stack arguments (5th argument and beyond, pushed in reverse order on x64)
	mov	QWORD PTR 88[rsp], 0    # lpParam = NULL (no creation data)
	mov	rdx, QWORD PTR 144[rbp] # rdx = hInstance
	mov	QWORD PTR 80[rsp], rdx  # hInstance (9th arg) -> stack slot
	mov	QWORD PTR 72[rsp], 0    # hMenu = NULL (no menu)
	mov	QWORD PTR 64[rsp], 0    # hWndParent = NULL (no parent)
	mov	DWORD PTR 56[rsp], r8d  # nHeight (8th arg) = bottom-top
	mov	DWORD PTR 48[rsp], ecx  # nWidth  (7th arg) = right-left (note: ecx = _8 below)
	mov	DWORD PTR 40[rsp], -2147483648  # y = CW_USEDEFAULT (0x80000000)
	mov	DWORD PTR 32[rsp], -2147483648  # x = CW_USEDEFAULT (0x80000000)

	# Register arguments (1st-4th)
	# dwStyle = WS_OVERLAPPEDWINDOW & ~WS_THICKFRAME & ~WS_MAXIMIZEBOX = 13238272
	mov	r9d, 13238272           # r9  = window style (no resize, no maximize)
	mov	r8, r10                 # r8  = lpWindowName = "Flappy Bird - Press SPACE..."
	mov	rdx, rax                # rdx = lpClassName = "FlappyBirdClass"
	mov	ecx, 0                  # rcx = dwExStyle = 0 (no extended styles)
	mov	rax, QWORD PTR __imp_CreateWindowExA[rip]
	call	rax                     # CreateWindowExA(...) -> HWND in RAX (NULL = failure)
	mov	QWORD PTR 120[rbp], rax # hwnd = RAX (save window handle)

	# --- C LINE: if (hwnd == NULL) { ...error... } ---
	cmp	QWORD PTR 120[rbp], 0   # Is hwnd == NULL?
	jne	.L22                    # No (success) -> continue

	# Window creation failed - show error and return 0
	lea	rdx, .LC4[rip]          # "Error"
	lea	rax, .LC7[rip]          # "Window Creation Failed!"
	mov	r9d, 16                 # MB_ICONERROR
	mov	r8, rdx
	mov	rdx, rax
	mov	ecx, 0
	mov	rax, QWORD PTR __imp_MessageBoxA[rip]
	call	rax                     # MessageBoxA(NULL, "Window Creation Failed!", "Error", 16)
	mov	eax, 0
	jmp	.L25                    # Return 0

.L22:
	# --- C LINE: ShowWindow(hwnd, nCmdShow); ---
	# Make the window visible. nCmdShow controls how (normal, minimized, maximized)
	mov	edx, DWORD PTR 168[rbp] # rdx = nCmdShow
	mov	rax, QWORD PTR 120[rbp] # rax = hwnd
	mov	rcx, rax                # rcx = hwnd
	mov	rax, QWORD PTR __imp_ShowWindow[rip]
	call	rax                     # ShowWindow(hwnd, nCmdShow)

	# --- C LINE: UpdateWindow(hwnd); ---
	# Force an immediate WM_PAINT to draw the initial frame
	mov	rax, QWORD PTR 120[rbp] # rax = hwnd
	mov	rcx, rax                # rcx = hwnd
	mov	rax, QWORD PTR __imp_UpdateWindow[rip]
	call	rax                     # UpdateWindow(hwnd)

	# --- C LINE: MSG msg = {0}; ---
	# Zero-initialize the 48-byte MSG struct at [rbp-32]
	# MSG fields: hwnd(8), message(4), wParam(8), lParam(8), time(4), pt(8), lPrivate(4)
	pxor	xmm0, xmm0
	movaps	XMMWORD PTR -32[rbp], xmm0  # Clear bytes 0-15 of MSG
	movaps	XMMWORD PTR -16[rbp], xmm0  # Clear bytes 16-31 of MSG
	movaps	XMMWORD PTR 0[rbp], xmm0    # Clear bytes 32-47 of MSG

	# --- C LINE: while (GetMessage(&msg, NULL, 0, 0)) { ... } ---
	# The Windows message loop. GetMessage blocks until a message is available.
	# Returns non-zero for normal messages, 0 when WM_QUIT is received.
	jmp	.L23                    # Jump to loop condition first

.L24:                                   # Loop body (top of while body)
	# --- C LINE: TranslateMessage(&msg); ---
	# Converts WM_KEYDOWN + WM_KEYUP pairs into WM_CHAR messages for text input
	lea	rax, -32[rbp]           # rax = &msg
	mov	rcx, rax                # rcx = &msg
	mov	rax, QWORD PTR __imp_TranslateMessage[rip]
	call	rax                     # TranslateMessage(&msg)

	# --- C LINE: DispatchMessage(&msg); ---
	# Routes the message to the appropriate WndProc (our function above)
	lea	rax, -32[rbp]           # rax = &msg
	mov	rcx, rax                # rcx = &msg
	mov	rax, QWORD PTR __imp_DispatchMessageA[rip]
	call	rax                     # DispatchMessageA(&msg) -> calls WndProc

.L23:                                   # Loop condition check
	# --- C LINE: while (GetMessage(&msg, NULL, 0, 0)) ---
	# GetMessage(LPMSG lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax)
	# hWnd=NULL  means get messages for all windows of this thread
	# Filter 0,0 means get all message types
	lea	rax, -32[rbp]           # rax = &msg
	mov	r9d, 0                  # r9  = wMsgFilterMax = 0 (no filter)
	mov	r8d, 0                  # r8  = wMsgFilterMin = 0 (no filter)
	mov	edx, 0                  # rdx = NULL (get messages for any window)
	mov	rcx, rax                # rcx = &msg
	mov	rax, QWORD PTR __imp_GetMessageA[rip]
	call	rax                     # GetMessageA(&msg, NULL, 0, 0)
	                                # Returns: > 0 (normal), 0 (WM_QUIT), -1 (error)

	test	eax, eax                # Is return value 0?
	setne	al                      # al = 1 if eax != 0 (continue loop)
	test	al, al                  # Set flags based on al
	jne	.L24                    # Non-zero -> loop back to TranslateMessage

	# GetMessage returned 0 -> WM_QUIT received -> exit the loop

	# --- C LINE: return msg.wParam; ---
	# msg.wParam is the exit code passed to PostQuitMessage()
	# MSG struct layout: hwnd(8 bytes), then wParam is at offset 12?
	# Actually MSG = {HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam, ...}
	# hwnd=8B, message=4B, padding=4B, wParam=8B -> wParam at offset 16 from msg start
	# msg starts at [rbp-32], so wParam is at [rbp-32+16] = [rbp-16]
	mov	rax, QWORD PTR -16[rbp] # rax = msg.wParam (the exit code)

.L25:
	# --- FUNCTION EPILOGUE ---
	add	rsp, 256                # Deallocate the 256-byte frame
	pop	rbp                     # Restore caller's frame pointer
	ret                             # Return exit code in RAX
	.seh_endproc


# ============================================================================
# READ-ONLY DATA SECTION - Float constants
# ============================================================================
	.section .rdata,"dr"
	.align 4

# JUMP_STRENGTH = -12.0f
# IEEE 754 single-precision representation of -12.0:
#   Sign bit:   1 (negative)
#   Exponent:   127 + 3 = 130 = 0b10000010 (because -12 = -1.5 * 2^3)
#   Mantissa:   0b10000000000000000000000 (the .5 after the leading 1)
#   Full binary: 1 10000010 10000000000000000000000
#   Hex:         0xC1400000
#   Signed int:  -1052770304
# This constant is loaded into XMM0 by: movss xmm0, DWORD PTR .LC1[rip]
.LC1:
	.long	-1052770304             # = -12.0f = JUMP_STRENGTH (upward velocity on jump)

	.ident	"GCC: (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) 15.2.0"

# ============================================================================
# EXTERNAL SYMBOL DECLARATIONS
# ============================================================================
# .def directives tell the linker that these symbols are defined in other
# object files. The linker will resolve these references at link time.
	.def	_Z12InitGraphicsP6HWND__;	.scl	2;	.type	32;	.endef  # render.asm
	.def	_Z9InitAudiov;	.scl	2;	.type	32;	.endef              # audio.asm
	.def	srand;	.scl	2;	.type	32;	.endef                      # C runtime
	.def	_Z8InitGamev;	.scl	2;	.type	32;	.endef              # game.asm
	.def	_Z10UpdateGamev;	.scl	2;	.type	32;	.endef          # game.asm
	.def	_Z8DrawGameP5HDC__;	.scl	2;	.type	32;	.endef          # render.asm
	.def	_Z15PlaySoundEffectPKc;	.scl	2;	.type	32;	.endef      # audio.asm
	.def	_Z12CleanupAudiov;	.scl	2;	.type	32;	.endef          # audio.asm
	.def	_Z15CleanupGraphicsv;	.scl	2;	.type	32;	.endef      # render.asm

# ============================================================================
# REFERENCE POINTER TO GAME GLOBAL
# ============================================================================
# 'game' is a global struct defined in game.asm (in the .bss section).
# Because main.asm accesses 'game' from a different object file, the linker
# needs a special indirection pointer (.refptr.game) to resolve the reference.
# At runtime, .refptr.game contains the actual address of the 'game' struct.
	.section	.rdata$.refptr.game, "dr"
	.p2align	3, 0                # Align to 8-byte boundary
	.globl	.refptr.game
	.linkonce	discard             # Only include one copy if multiple object files have it
.refptr.game:
	.quad	game                    # 8-byte pointer to the 'game' symbol in game.asm
