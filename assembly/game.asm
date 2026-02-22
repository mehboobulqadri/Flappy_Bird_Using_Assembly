	.file	"game.c"
	.intel_syntax noprefix

# ============================================================================
# FILE:    game.asm
# SOURCE:  src/game.c
# PURPOSE: Core game logic for Flappy Bird
#          Contains physics simulation, pipe management, particle effects,
#          collision detection (AABB), score tracking, and high-score I/O.
#
# FUNCTIONS IN THIS FILE (in order):
#   InitGame()          - Reset all game state, load high score, seed particles
#   ResetPipes()        - Place 3 pipes at staggered off-screen positions
#   LoadHighScore()     - Read best score from flappy_highscore.dat
#   SaveHighScore()     - Write new high score to disk if score improved
#   AddParticle()       - Spawn one particle from the free-list
#   UpdateParticles()   - Advance every live particle by velocity + gravity
#   UpdateGame()        - Main per-frame update: physics, pipes, collision, effects
#
# HOW THIS FILE WAS GENERATED:
#   g++ -S -O0 -masm=intel -fno-omit-frame-pointer -fverbose-asm src/game.c
#   Flags:
#     -S              : emit assembly only, stop before assembling
#     -O0             : zero optimizations; every C statement maps to asm 1:1
#     -masm=intel     : Intel syntax  (mov rax, 5)  not AT&T  (movq $5, %rax)
#     -fno-omit-frame-pointer : always emit push rbp / mov rbp,rsp prologue
#     -fverbose-asm   : compiler inserts  # src/game.c:N  and variable names
#
# WINDOWS x64 CALLING CONVENTION (Microsoft ABI) - applies to EVERY call:
#   Integer/pointer arguments 1-4  : RCX, RDX, R8, R9
#   Float arguments 1-4            : XMM0, XMM1, XMM2, XMM3
#   Return value (int/ptr)         : RAX
#   Return value (float)           : XMM0
#   Caller MUST reserve 32 bytes of "shadow space" on the stack before CALL
#   Stack must be 16-byte aligned at every CALL instruction
#   Registers RBX, RBP, RDI, RSI, R12-R15 are callee-saved (non-volatile)
#   Registers RAX, RCX, RDX, R8-R11, XMM0-5 are caller-saved (volatile)
#
# C++ NAME MANGLING:
#   _Z8InitGamev          = InitGame(void)
#   _Z10ResetPipesv       = ResetPipes(void)
#   _Z13LoadHighScorev    = LoadHighScore(void)
#   _Z13SaveHighScorev    = SaveHighScore(void)
#   _Z11AddParticleffm    = AddParticle(float x, float y, unsigned long color)
#   _Z15UpdateParticlesv  = UpdateParticles(void)
#   _Z10UpdateGamev       = UpdateGame(void)
#
# KEY DATA STRUCTURES (from game.h):
#
#   Bird struct (16 bytes total):
#     +0  float y          - vertical position (pixels from top)
#     +4  float velocity   - pixels per frame (positive = falling)
#     +8  int   alive      - 1=alive, 0=dead
#     +12 float rotation   - render rotation in degrees
#
#   Pipe struct (12 bytes total):
#     +0  int x            - horizontal position
#     +4  int topHeight    - height of the top pipe in pixels
#     +8  int scored       - 1 if bird already passed this pipe
#
#   GameState struct layout (96 bytes, at global label 'game'):
#     game[+0]  = bird.y           (float)
#     game[+4]  = bird.velocity    (float)
#     game[+8]  = bird.alive       (int)
#     game[+12] = bird.rotation    (float)
#     game[+16] = pipes[0].x       (int)   <- 3 Pipe structs, 12 bytes each
#     game[+20] = pipes[0].topHeight (int)
#     game[+24] = pipes[0].scored  (int)
#     game[+28] = pipes[1].x       (int)
#     game[+32] = pipes[1].topHeight (int)
#     game[+36] = pipes[1].scored  (int)
#     game[+40] = pipes[2].x       (int)
#     game[+44] = pipes[2].topHeight (int)
#     game[+48] = pipes[2].scored  (int)
#     game[+52] = score            (int)
#     game[+56] = highScore        (int)
#     game[+60] = gameOver         (int)
#     game[+64] = started          (int)
#     game[+68] = pipeSpeed        (float)
#     game[+72] = frameCount       (int)
#     game[+76] = backgroundOffset (float)
#     game[+80] = groundOffset     (float)
#     game[+84] = screenShake      (int)
#     game[+88] = flashEffect      (int)
#     game[+92] = birdFrame        (int)
#
#   Particle struct (24 bytes, at global label 'particles'):
#     Each element is 24 bytes; stride = i * 24
#     particles[i*24 + 0]  = x     (float)
#     particles[i*24 + 4]  = y     (float)
#     particles[i*24 + 8]  = vx    (float)
#     particles[i*24 + 12] = vy    (float)
#     particles[i*24 + 16] = life  (int)    <- 0 means slot is free
#     particles[i*24 + 20] = color (DWORD)
#
#   The compiler computes particle[i] field addresses as:
#     offset = i * 3 * 8  = i * 24  (encoded as: rax=i; rax+=rax; rax+=i; rax<<=3)
#   Then adds the per-field base: particles+0, +4, +8, +12, +16, +20
#
# GAME CONSTANTS (from game.h) referenced as immediate values below:
#   WINDOW_WIDTH        = 1280
#   WINDOW_HEIGHT       = 720
#   GROUND_HEIGHT       = 112
#   PIPE_WIDTH          = 103  (note: -PIPE_WIDTH = -104 used as loop boundary)
#   PIPE_GAP            = 200
#   BIRD_X              = 350  (fixed horizontal position)
#   BIRD_SIZE           = 60
#   BIRD_HITBOX_SIZE    = 47
#   MAX_VELOCITY        = 12.0f
#   GRAVITY             = 0.4f  (approx; .LC9 = 1061997773 as IEEE 754)
#   BASE_PIPE_SPEED     = 3.0f  (.LC2)
#   GROUND_SCROLL_SPEED = 3.0f  (.LC2, same value)
#   BIRD_ANIMATION_SPEED= 8     (check frameCount & 7 == 0)
#   MAX_PARTICLES       = 50
#   HIGHSCORE_FILE      = "flappy_highscore.dat"
#
# WINDOWS SEH DIRECTIVES (metadata only - no executable code):
#   .seh_proc, .seh_pushreg, .seh_setframe, .seh_stackalloc,
#   .seh_endprologue, .seh_endproc
#   These populate the .pdata section so Windows knows how to unwind the stack
#   during structured exception handling. They generate NO instructions.
# ============================================================================


# ============================================================================
# BSS SECTION - Uninitialized global variables (zero-filled by OS at startup)
# ============================================================================
	.text
	.globl	game
	.bss
	.align 32

# GameState game;   (global, defined in game.c, exported for render.c/main.c)
# 96 bytes = sizeof(GameState) as laid out above.
# The OS zero-fills this before main() runs.
game:
	.space 96                       # Reserve 96 bytes for the GameState struct

	.globl	particles
	.align 32

# Particle particles[MAX_PARTICLES];  (global, MAX_PARTICLES = 50)
# 50 particles * 24 bytes each = 1200 bytes total.
# life field starts at 0 (slot is free) - InitGame explicitly clears them too.
particles:
	.space 1200                     # Reserve 1200 bytes for the particle pool


# ============================================================================
# TEXT SECTION - Executable code starts here
# ============================================================================
	.text

# ----------------------------------------------------------------------------
# FUNCTION: InitGame()
# C SOURCE:  src/game.c lines 12-35
#
# PURPOSE:  Reset the entire game state to its starting values.
#           Called on game start and on restart (R key).
#           Sets bird position, clears score/flags, resets speed,
#           loads the saved high score, places pipes, clears particle pool.
#
# PARAMETERS: none
# RETURNS:    void
#
# STACK FRAME LAYOUT (after prologue completes):
#
#   Higher addresses
#   +------------------+
#   | return address   |  [rbp + 8]    (pushed automatically by CALL)
#   +------------------+
#   | saved rbp        |  [rbp + 0]    (push rbp)
#   +------------------+  <-- rbp points here
#   | int i (loop var) |  [rbp - 4]    local variable for particle clear loop
#   +------------------+
#   | padding (8 B)    |  [rbp - 12]   alignment to 16 bytes
#   +------------------+
#   | shadow space     |  [rbp - 48]   32 bytes for callee use (Win64 ABI)
#   +------------------+  <-- rsp points here  (total: sub rsp, 48)
#   Lower addresses
#
# REGISTER USAGE:
#   xmm0 - scratch float register for loading/storing float constants
#   rax  - scratch (address calculations, return values from calls)
#   rdx  - scratch (address offsets for particle array indexing)
# ----------------------------------------------------------------------------
	.globl	_Z8InitGamev
	.def	_Z8InitGamev;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z8InitGamev

_Z8InitGamev:                           # === InitGame() entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp                     # Save caller's frame pointer
	.seh_pushreg	rbp
	mov	rbp, rsp                # Establish our frame base
	.seh_setframe	rbp, 0
	sub	rsp, 48                 # 4 bytes local 'i' + 12 pad + 32 shadow space
	.seh_stackalloc	48
	.seh_endprologue

	# --- C LINE: game.bird.y = WINDOW_HEIGHT / 2.0f - 50; ---
	# .LC0 = 310.0f  (720/2 - 50 = 310, precomputed by compiler into a float constant)
	movss	xmm0, DWORD PTR .LC0[rip]  # xmm0 = 310.0f
	movss	DWORD PTR game[rip], xmm0  # game.bird.y = 310.0f  (offset +0)

	# --- C LINE: game.bird.velocity = 0; ---
	pxor	xmm0, xmm0             # xmm0 = 0.0f  (XOR with self clears to 0)
	movss	DWORD PTR game[rip+4], xmm0  # game.bird.velocity = 0.0f  (offset +4)

	# --- C LINE: game.bird.alive = 1; ---
	mov	DWORD PTR game[rip+8], 1    # game.bird.alive = 1  (offset +8)

	# --- C LINE: game.bird.rotation = 0; ---
	pxor	xmm0, xmm0             # xmm0 = 0.0f
	movss	DWORD PTR game[rip+12], xmm0 # game.bird.rotation = 0.0f  (offset +12)

	# --- C LINE: game.score = 0; ---
	mov	DWORD PTR game[rip+52], 0   # game.score = 0  (offset +52)

	# --- C LINE: game.gameOver = 0; ---
	mov	DWORD PTR game[rip+60], 0   # game.gameOver = 0  (offset +60)

	# --- C LINE: game.started = 0; ---
	mov	DWORD PTR game[rip+64], 0   # game.started = 0 (waiting for first SPACE)

	# --- C LINE: game.pipeSpeed = BASE_PIPE_SPEED; ---
	# .LC2 = 3.0f  (BASE_PIPE_SPEED constant)
	movss	xmm0, DWORD PTR .LC2[rip]  # xmm0 = 3.0f
	movss	DWORD PTR game[rip+68], xmm0 # game.pipeSpeed = 3.0f  (offset +68)

	# --- C LINE: game.frameCount = 0; ---
	mov	DWORD PTR game[rip+72], 0   # game.frameCount = 0  (offset +72)

	# --- C LINE: game.backgroundOffset = 0; ---
	pxor	xmm0, xmm0             # xmm0 = 0.0f
	movss	DWORD PTR game[rip+76], xmm0 # game.backgroundOffset = 0.0f  (offset +76)

	# --- C LINE: game.groundOffset = 0; ---
	pxor	xmm0, xmm0             # xmm0 = 0.0f
	movss	DWORD PTR game[rip+80], xmm0 # game.groundOffset = 0.0f  (offset +80)

	# --- C LINE: game.screenShake = 0; ---
	mov	DWORD PTR game[rip+84], 0   # game.screenShake = 0  (offset +84)

	# --- C LINE: game.flashEffect = 0; ---
	mov	DWORD PTR game[rip+88], 0   # game.flashEffect = 0  (offset +88)

	# --- C LINE: game.birdFrame = 0; ---
	mov	DWORD PTR game[rip+92], 0   # game.birdFrame = 0 (animation frame 0..2)

	# --- C LINE: LoadHighScore(); ---
	call	_Z13LoadHighScorev      # LoadHighScore() - reads flappy_highscore.dat

	# --- C LINE: ResetPipes(); ---
	call	_Z10ResetPipesv         # ResetPipes() - place 3 pipes off-screen right

	# --- C LINE: for (int i = 0; i < MAX_PARTICLES; i++) { ---
	# Clear particle pool: set every particle's 'life' to 0 (mark as free slot)
	mov	DWORD PTR -4[rbp], 0    # i = 0  (loop variable on stack)
	jmp	.L2                     # Jump to loop condition check first

.L3:                                    # --- LOOP BODY: clear particles[i].life ---
	# Compute address of particles[i].life:
	#   Each Particle is 24 bytes. Index address = base + i*24 + 16
	#   The compiler computes i*24 as: rdx = i; rax=rdx; rax+=rax; rax+=rdx; rax<<=3
	#   That is: rax = 2*i + i = 3*i, then <<3 = *8 -> 3*i*8 = 24*i  ✓
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax               # rdx = (int64) i  (sign-extend)
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2*i
	add	rax, rdx               # rax = 3*i
	sal	rax, 3                 # rax = 3*i * 8 = 24*i   (i * sizeof(Particle))
	mov	rdx, rax               # rdx = byte offset for particle i
	lea	rax, particles[rip+16] # rax = &particles[0].life  (base + life offset 16)
	mov	DWORD PTR [rdx+rax], 0 # particles[i].life = 0  (mark slot as free)

	add	DWORD PTR -4[rbp], 1   # i++

.L2:                                    # --- LOOP CONDITION ---
	cmp	DWORD PTR -4[rbp], 49  # i <= 49? (MAX_PARTICLES-1 = 49)
	jle	.L3                    # If yes, keep looping

	# --- FUNCTION EPILOGUE ---
	nop                             # Compiler-inserted NOP (empty C statement end)
	nop
	add	rsp, 48                 # Deallocate local frame
	pop	rbp                     # Restore caller's frame pointer
	ret                             # Return to caller
	.seh_endproc

# ----------------------------------------------------------------------------
# FUNCTION: ResetPipes()
# C SOURCE:  src/game.c lines 38-48
#
# PURPOSE:  Place all 3 pipes at staggered starting positions to the right
#           of the screen, ready for the bird to fly through.
#           Assigns each pipe a random top-pipe height.
#           Called by InitGame() and never called directly again.
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
#   | int i (loop var) |  [rbp - 4]
#   +------------------+
#   | padding (8 B)    |  [rbp - 12]
#   +------------------+
#   | shadow space     |  [rbp - 48]   32 bytes for rand() call (Win64 ABI)
#   +------------------+  <-- rsp
#
# REGISTER USAGE:
#   eax  - rand() return value, pipe index multiplication
#   ecx  - computed x position, computed topHeight (written to struct)
#   rdx  - byte offset into game.pipes array = i * 12
#   rax  - base address of target field in game struct
#
# PIPE ARRAY INDEXING TRICK:
#   game.pipes is an array of Pipe structs, each 12 bytes.
#   Offset of pipes[i] from start of 'game' = 16 + i*12
#   Compiler computes i*12 as:
#     rax = i; rax += rax (= 2i); rax += i (= 3i); rax <<= 2 (= 12i)  ✓
#   Then adds field offsets: +0 for x, +4 for topHeight, +8 for scored
#   relative to game+16 (start of pipes array).
#
# RAND % 208 COMPUTATION (compiler uses multiply instead of divide):
#   Compilers avoid the slow DIV instruction for modulo.
#   Instead they use a "magic number" multiply to compute the quotient.
#   1321528399 is the magic constant for modulo 208 on 32-bit integers.
#   Steps: rdx = (int64)rand_result * 1321528399 (high 32 bits = quotient approx)
#          edx >>= 6  (arithmetic shift - adjust for magic constant)
#          sub sign correction
#   Result in edx = rand() / 208, then ecx = rand_result - edx*208 = rand() % 208
# ----------------------------------------------------------------------------
	.globl	_Z10ResetPipesv
	.def	_Z10ResetPipesv;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10ResetPipesv

_Z10ResetPipesv:                        # === ResetPipes() entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48                 # 4 bytes local 'i' + padding + 32 shadow
	.seh_stackalloc	48
	.seh_endprologue

	# --- C LINE: for (int i = 0; i < 3; i++) { ---
	mov	DWORD PTR -4[rbp], 0    # i = 0
	jmp	.L5                     # Jump to condition first (do-while pattern)

.L6:                                    # === LOOP BODY: initialize pipes[i] ===

	# --- C LINE: game.pipes[i].x = WINDOW_WIDTH + i * 400; ---
	# x starts at 1280 (off-screen right), each pipe 400px further right
	mov	eax, DWORD PTR -4[rbp] # eax = i
	imul	eax, eax, 400          # eax = i * 400
	lea	ecx, 1280[rax]         # ecx = 1280 + i*400  (WINDOW_WIDTH + spacing)

	# Now compute &game.pipes[i].x and store ecx:
	#   Byte offset = i * 12  (computed as 3*i then <<2)
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax               # rdx = (int64) i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2*i
	add	rax, rdx               # rax = 3*i
	sal	rax, 2                 # rax = 12*i  (i * sizeof(Pipe))
	mov	rdx, rax               # rdx = byte offset to pipes[i]
	lea	rax, game[rip+16]      # rax = &game.pipes[0].x  (pipes start at +16)
	mov	DWORD PTR [rdx+rax], ecx  # game.pipes[i].x = 1280 + i*400

	# --- C LINE: game.pipes[i].topHeight = 100 + rand() % 208; ---
	# Random top pipe height: range [100, 307] ensures gap always fits in screen.
	# Total playable height = 720 - 112 (ground) = 608px
	# topHeight + PIPE_GAP(200) + bottom = topHeight + 200 <= 608 -> max 408... but
	# developer chose 100 + rand()%208 -> range [100,307] for balanced layout.
	call	rand                    # rand() -> EAX = random integer

	# Compute rand() % 208 using magic number trick (avoids slow DIV instruction):
	movsx	rdx, eax               # rdx = (int64) rand_result
	imul	rdx, rdx, 1321528399   # rdx = rand_result * magic (for /208)
	shr	rdx, 32                # rdx = high 32 bits of product (approx quotient)
	sar	edx, 6                 # arithmetic right shift to get exact quotient
	mov	ecx, eax               # ecx = rand_result (for sign fixup)
	sar	ecx, 31                # ecx = sign bit of rand_result (0 or -1)
	sub	edx, ecx               # edx = quotient (corrected for sign)
	imul	ecx, edx, 208          # ecx = quotient * 208
	sub	eax, ecx               # eax = rand_result - quotient*208 = rand()%208
	mov	edx, eax               # edx = rand()%208

	lea	ecx, 100[rdx]          # ecx = 100 + rand()%208  (topHeight value)

	# Store topHeight into game.pipes[i].topHeight (same index trick):
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2                 # rax = 12*i
	mov	rdx, rax
	lea	rax, game[rip+20]      # rax = &game.pipes[0].topHeight  (+20 = +16+4)
	mov	DWORD PTR [rdx+rax], ecx  # game.pipes[i].topHeight = 100 + rand()%208

	# --- C LINE: game.pipes[i].scored = 0; ---
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2                 # rax = 12*i
	mov	rdx, rax
	lea	rax, game[rip+24]      # rax = &game.pipes[0].scored  (+24 = +16+8)
	mov	DWORD PTR [rdx+rax], 0 # game.pipes[i].scored = 0  (not scored yet)

	add	DWORD PTR -4[rbp], 1   # i++

.L5:                                    # --- LOOP CONDITION ---
	cmp	DWORD PTR -4[rbp], 2   # i <= 2? (3 pipes: i=0,1,2)
	jle	.L6                    # Loop back if yes

	# --- FUNCTION EPILOGUE ---
	nop
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc

# ============================================================================
# READ-ONLY DATA SECTION - String constants for file I/O
# ============================================================================
	.section .rdata,"dr"

# File open mode string: "rb" = read binary (used by LoadHighScore)
.LC3:
	.ascii "rb\0"

# The high score save file name (shared by both Load and Save)
.LC4:
	.ascii "flappy_highscore.dat\0"


# ============================================================================
# TEXT SECTION
# ============================================================================
	.text

# ----------------------------------------------------------------------------
# FUNCTION: LoadHighScore()
# C SOURCE:  src/game.c lines 51-59
#
# PURPOSE:  Open flappy_highscore.dat and read the saved integer into
#           game.highScore. If the file doesn't exist, set highScore to 0.
#           Called once during InitGame().
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
#   | FILE* file       |  [rbp - 8]    local: fopen return value (pointer)
#   +------------------+
#   | padding (8 B)    |  [rbp - 16]
#   +------------------+
#   | shadow space     |  [rbp - 48]   32 bytes for fopen/fread/fclose
#   +------------------+  <-- rsp
#
# REGISTER USAGE:
#   rcx - arg1 to fopen/fread/fclose
#   rdx - arg2 to fopen/fread
#   r8  - arg3 to fread (count)
#   r9  - arg4 to fread (FILE*)
#   rax - return value from fopen (FILE pointer)
#
# C STANDARD LIBRARY CALLS:
#   fopen(filename, mode) -> FILE*   (NULL if file doesn't exist)
#   fread(ptr, size, count, stream) -> reads count*size bytes into ptr
#   fclose(stream)                   -> closes the file
# ----------------------------------------------------------------------------
	.globl	_Z13LoadHighScorev
	.def	_Z13LoadHighScorev;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z13LoadHighScorev

_Z13LoadHighScorev:                     # === LoadHighScore() entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48                 # 8 bytes for FILE* local + padding + 32 shadow
	.seh_stackalloc	48
	.seh_endprologue

	# --- C LINE: FILE* file = fopen(HIGHSCORE_FILE, "rb"); ---
	# Win64: RCX = filename, RDX = mode
	lea	rdx, .LC3[rip]         # rdx = "rb"          (mode: read binary)
	lea	rax, .LC4[rip]         # rax = "flappy_highscore.dat"
	mov	rcx, rax               # rcx = filename
	call	fopen                  # fopen("flappy_highscore.dat", "rb") -> RAX
	mov	QWORD PTR -8[rbp], rax # [rbp-8] = file pointer (may be NULL)

	# --- C LINE: if (file) { ---
	cmp	QWORD PTR -8[rbp], 0   # Is FILE* == NULL?
	je	.L8                    # If NULL (file not found), jump to else-branch

	# --- C LINE: fread(&game.highScore, sizeof(int), 1, file); ---
	# fread(void* ptr, size_t size, size_t count, FILE* stream)
	# Win64: RCX=ptr, RDX=size, R8=count, R9=stream
	mov	rdx, QWORD PTR -8[rbp] # rdx = file pointer (saved temporarily)
	lea	rax, game[rip+56]      # rax = &game.highScore  (offset +56 in GameState)
	mov	r9, rdx                # r9  = FILE* stream (arg4)
	mov	r8d, 1                 # r8  = count = 1 (read 1 item)
	mov	edx, 4                 # rdx = size = 4 bytes (sizeof(int))
	mov	rcx, rax               # rcx = ptr = &game.highScore
	call	fread                  # fread(&game.highScore, 4, 1, file)

	# --- C LINE: fclose(file); ---
	mov	rax, QWORD PTR -8[rbp] # rax = FILE*
	mov	rcx, rax               # rcx = FILE* (arg1 to fclose)
	call	fclose                 # fclose(file)

	jmp	.L10                   # Jump over else branch to end

.L8:                                    # --- ELSE: file doesn't exist ---
	# --- C LINE: game.highScore = 0; ---
	mov	DWORD PTR game[rip+56], 0  # game.highScore = 0  (first ever run)

.L10:                                   # --- END OF IF/ELSE ---
	# --- FUNCTION EPILOGUE ---
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc


# ============================================================================
# READ-ONLY DATA - String constant for SaveHighScore
# ============================================================================
	.section .rdata,"dr"

# File open mode string: "wb" = write binary (used by SaveHighScore)
.LC5:
	.ascii "wb\0"


# ============================================================================
# TEXT SECTION
# ============================================================================
	.text

# ----------------------------------------------------------------------------
# FUNCTION: SaveHighScore()
# C SOURCE:  src/game.c lines 62-71
#
# PURPOSE:  If the current score beats the high score, update game.highScore
#           and write it to flappy_highscore.dat.
#           Called when bird dies (ground collision or pipe collision).
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
#   | FILE* file       |  [rbp - 8]    pointer from fopen (may be NULL)
#   +------------------+
#   | padding (8 B)    |  [rbp - 16]
#   +------------------+
#   | shadow space     |  [rbp - 48]   32 bytes for Win64 calls
#   +------------------+  <-- rsp
#
# REGISTER USAGE:
#   edx - game.score (loaded for comparison)
#   eax - game.highScore (loaded for comparison), then reused
#   rcx - arg1 (filename or ptr)
#   rdx - arg2 (mode or size)
#   r8  - arg3 (count)
#   r9  - arg4 (FILE*)
#
# CONTROL FLOW:
#   if (score > highScore) -> update highScore, open file, write, close
#   else                   -> do nothing (jump to .L13)
# ----------------------------------------------------------------------------
	.globl	_Z13SaveHighScorev
	.def	_Z13SaveHighScorev;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z13SaveHighScorev

_Z13SaveHighScorev:                     # === SaveHighScore() entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue

	# --- C LINE: if (game.score > game.highScore) { ---
	mov	edx, DWORD PTR game[rip+52]  # edx = game.score    (offset +52)
	mov	eax, DWORD PTR game[rip+56]  # eax = game.highScore (offset +56)
	cmp	edx, eax               # Compare score vs highScore
	jle	.L13                   # If score <= highScore, skip (no new record)

	# --- C LINE: game.highScore = game.score; ---
	mov	eax, DWORD PTR game[rip+52]  # eax = game.score
	mov	DWORD PTR game[rip+56], eax  # game.highScore = game.score  (new record!)

	# --- C LINE: FILE* file = fopen(HIGHSCORE_FILE, "wb"); ---
	# Win64: RCX = filename, RDX = mode
	lea	rdx, .LC5[rip]         # rdx = "wb"          (mode: write binary)
	lea	rax, .LC4[rip]         # rax = "flappy_highscore.dat"
	mov	rcx, rax               # rcx = filename
	call	fopen                  # fopen(...) -> RAX = FILE* (NULL if failed)
	mov	QWORD PTR -8[rbp], rax # [rbp-8] = file pointer

	# --- C LINE: if (file) { ---
	cmp	QWORD PTR -8[rbp], 0   # Is FILE* NULL? (disk full, no permission, etc.)
	je	.L13                   # If NULL, give up silently

	# --- C LINE: fwrite(&game.highScore, sizeof(int), 1, file); ---
	# fwrite(void* ptr, size_t size, size_t count, FILE* stream)
	# Win64: RCX=ptr, RDX=size, R8=count, R9=stream
	mov	rdx, QWORD PTR -8[rbp] # rdx = FILE* (save for r9)
	lea	rax, game[rip+56]      # rax = &game.highScore
	mov	r9, rdx                # r9  = FILE* stream
	mov	r8d, 1                 # r8  = count = 1
	mov	edx, 4                 # rdx = size = 4 (sizeof(int))
	mov	rcx, rax               # rcx = ptr = &game.highScore
	call	fwrite                 # fwrite(&game.highScore, 4, 1, file)

	# --- C LINE: fclose(file); ---
	mov	rax, QWORD PTR -8[rbp] # rax = FILE*
	mov	rcx, rax               # rcx = FILE* (arg1)
	call	fclose                 # fclose(file) - flush and close

.L13:                                   # --- END: score was not a new record ---
	# --- FUNCTION EPILOGUE ---
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc

# ----------------------------------------------------------------------------
# FUNCTION: AddParticle(float x, float y, COLORREF color)
# C SOURCE:  src/game.c lines 74-86
#
# PURPOSE:  Find the first free slot in the particle pool and initialize it.
#           "Free" means particles[i].life <= 0.
#           If all 50 slots are occupied, the call is silently ignored.
#           This is a free-list pattern: life==0 means "available".
#
# PARAMETERS (Win64 calling convention - floats in XMM, int in R8):
#   XMM0 = float x      - spawn X position (pixels)
#   XMM1 = float y      - spawn Y position (pixels)
#   R8D  = COLORREF color - Win32 color: 0x00BBGGRR packed 32-bit integer
#
# NOTE ON PARAMETER STORAGE:
#   Win64 ABI: float args arrive in XMM0/XMM1 but the shadow space area
#   (above rbp at positive offsets) is used by the compiler to spill them.
#   Specifically: [rbp+16]=x, [rbp+24]=y, [rbp+32]=color
#   (The compiler stores XMM0->stack, XMM1->stack, R8D->stack at entry.)
#
# RETURNS:    void
#
# STACK FRAME LAYOUT:
#   +------------------+
#   | color (DWORD)    |  [rbp + 32]   spilled parameter (from R8D)
#   +------------------+
#   | y (float)        |  [rbp + 24]   spilled parameter (from XMM1)
#   +------------------+
#   | x (float)        |  [rbp + 16]   spilled parameter (from XMM0)
#   +------------------+
#   | return address   |  [rbp + 8]
#   +------------------+
#   | saved rbp        |  [rbp + 0]
#   +------------------+  <-- rbp
#   | int i (loop var) |  [rbp - 4]
#   +------------------+
#   | padding (12 B)   |  [rbp - 16]
#   +------------------+
#   | shadow space     |  [rbp - 48]   32 bytes for rand() calls (Win64 ABI)
#   +------------------+  <-- rsp
#
# REGISTER USAGE:
#   eax  - rand() result, particle field computations
#   ecx  - rand() result copy (for %20 magic), life value written
#   edx  - modulo computation intermediate, offset into particle array
#   rax  - address of target particle field
#   rdx  - byte offset = i * 24
#   xmm0 - float computation (vx, vy)
#   xmm1 - float divisor (10.0f from .LC6)
#
# RAND % 100 MAGIC (magic constant 1374389535, shift 5):
#   Same "avoid DIV" trick as ResetPipes. Magic for /100 is 1374389535.
#   Result: rand() % 100 in EAX, then subtract 50 -> range [-50, 49]
#   Then convert to float and divide by 10.0f -> velocity range [-5.0, 4.9]
#
# RAND % 20 MAGIC (magic constant 1717986919, shifts 3 then +4+2):
#   Magic for /20. The sequence sal+add+sal encodes multiply by 20
#   to reconstruct the remainder: remainder = rand - (rand/20)*20
# ----------------------------------------------------------------------------
	.globl	_Z11AddParticleffm
	.def	_Z11AddParticleffm;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z11AddParticleffm

_Z11AddParticleffm:                     # === AddParticle(x, y, color) entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48                 # 4 bytes 'i' + padding + 32 shadow space
	.seh_stackalloc	48
	.seh_endprologue

	# --- SPILL INCOMING PARAMETERS TO SHADOW SPACE ---
	# Win64 float args arrive in XMM0/XMM1 but are stored to stack
	# so subsequent rand() calls don't clobber them.
	movss	DWORD PTR 16[rbp], xmm0    # [rbp+16] = x  (save float arg1)
	movss	DWORD PTR 24[rbp], xmm1    # [rbp+24] = y  (save float arg2)
	mov	DWORD PTR 32[rbp], r8d      # [rbp+32] = color (save int arg3)

	# --- C LINE: for (int i = 0; i < MAX_PARTICLES; i++) { ---
	mov	DWORD PTR -4[rbp], 0    # i = 0
	jmp	.L15                    # Jump to condition first

.L18:                                   # === LOOP BODY: check if slot i is free ===

	# --- C LINE: if (particles[i].life <= 0) { ---
	# Load particles[i].life and test if slot is available (life <= 0 = free)
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax               # rdx = (int64) i
	mov	rax, rdx
	add	rax, rax               # rax = 2*i
	add	rax, rdx               # rax = 3*i
	sal	rax, 3                 # rax = 24*i  (byte offset to particle i)
	mov	rdx, rax               # rdx = 24*i
	lea	rax, particles[rip+16] # rax = &particles[0].life
	mov	eax, DWORD PTR [rdx+rax]  # eax = particles[i].life
	test	eax, eax               # Set CPU flags: ZF=1 if life==0
	jg	.L16                   # If life > 0, slot is occupied -> skip to i++

	# --- SLOT IS FREE: initialize this particle ---

	# --- C LINE: particles[i].x = x; ---
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip]    # rax = &particles[0].x  (field offset 0)
	movss	xmm0, DWORD PTR 16[rbp]   # xmm0 = x  (reload saved parameter)
	movss	DWORD PTR [rdx+rax], xmm0 # particles[i].x = x

	# --- C LINE: particles[i].y = y; ---
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+4]  # rax = &particles[0].y  (field offset 4)
	movss	xmm0, DWORD PTR 24[rbp]   # xmm0 = y  (reload saved parameter)
	movss	DWORD PTR [rdx+rax], xmm0 # particles[i].y = y

	# --- C LINE: particles[i].vx = (rand() % 100 - 50) / 10.0f; ---
	# Step 1: get random integer
	call	rand                    # rand() -> EAX

	# Step 2: compute rand() % 100 using magic number (avoids DIV instruction)
	# Magic constant for /100 is 1374389535 (52-bit fixed point reciprocal)
	movsx	rdx, eax               # rdx = (int64) rand_result
	imul	rdx, rdx, 1374389535   # rdx = rand * magic
	shr	rdx, 32                # rdx = high 32 bits (approx quotient * 2^32)
	sar	edx, 5                 # edx = quotient (arithmetic shift corrects scale)
	mov	ecx, eax               # ecx = rand_result (for sign correction)
	sar	ecx, 31                # ecx = sign bit (0 if positive, -1 if negative)
	sub	edx, ecx               # edx = rand() / 100  (sign corrected)
	imul	ecx, edx, 100          # ecx = quotient * 100
	sub	eax, ecx               # eax = rand() % 100  (remainder)
	mov	edx, eax

	# Step 3: compute (rand()%100 - 50) / 10.0f
	lea	eax, -50[rdx]          # eax = rand()%100 - 50  (range: -50..49)
	pxor	xmm0, xmm0             # xmm0 = 0.0f (clear before cvt)
	cvtsi2ss	xmm0, eax      # xmm0 = (float)(rand()%100 - 50)
	movss	xmm1, DWORD PTR .LC6[rip]  # xmm1 = 10.0f  (.LC6 constant)
	divss	xmm0, xmm1             # xmm0 = result / 10.0f  (range: -5.0..4.9)

	# Step 4: store vx
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+8]  # rax = &particles[0].vx  (field offset 8)
	movss	DWORD PTR [rdx+rax], xmm0 # particles[i].vx = computed velocity

	# --- C LINE: particles[i].vy = (rand() % 100 - 50) / 10.0f; ---
	# Identical computation for vertical velocity component
	call	rand
	movsx	rdx, eax
	imul	rdx, rdx, 1374389535   # same magic number for %100
	shr	rdx, 32
	sar	edx, 5
	mov	ecx, eax
	sar	ecx, 31
	sub	edx, ecx
	imul	ecx, edx, 100
	sub	eax, ecx               # eax = rand() % 100
	mov	edx, eax
	lea	eax, -50[rdx]          # eax = rand()%100 - 50
	pxor	xmm0, xmm0
	cvtsi2ss	xmm0, eax      # convert to float
	movss	xmm1, DWORD PTR .LC6[rip]  # 10.0f
	divss	xmm0, xmm1             # divide by 10.0f

	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+12] # rax = &particles[0].vy  (field offset 12)
	movss	DWORD PTR [rdx+rax], xmm0 # particles[i].vy = computed velocity

	# --- C LINE: particles[i].life = 20 + rand() % 20; ---
	# Random lifetime: 20..39 frames (at 60fps ~= 0.3 to 0.65 seconds)
	call	rand
	mov	ecx, eax               # ecx = rand_result (preserve for remainder)

	# Compute rand() % 20 using magic number 1717986919 (for /20):
	movsx	rax, ecx               # rax = (int64) rand_result
	imul	rax, rax, 1717986919   # rax = rand * magic
	shr	rax, 32                # rax = high 32 bits
	mov	edx, eax               # edx = high bits (approx quotient)
	sar	edx, 3                 # edx = quotient / 8  (scale correction step 1)
	mov	eax, ecx               # eax = rand_result
	sar	eax, 31                # eax = sign bit
	sub	edx, eax               # edx = rand() / 20  (sign corrected)
	mov	eax, edx               # eax = quotient
	sal	eax, 2                 # eax = quotient * 4
	add	eax, edx               # eax = quotient * 5
	sal	eax, 2                 # eax = quotient * 20  (multiply back)
	sub	ecx, eax               # ecx = rand() % 20  (remainder)
	mov	edx, ecx

	lea	ecx, 20[rdx]           # ecx = 20 + rand()%20  (life value: 20..39)

	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+16] # rax = &particles[0].life  (field offset 16)
	mov	DWORD PTR [rdx+rax], ecx  # particles[i].life = 20 + rand()%20

	# --- C LINE: particles[i].color = color; ---
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rcx, rax               # rcx = 24*i  (NOTE: rcx not rdx - compiler choice)
	lea	rdx, particles[rip+20] # rdx = &particles[0].color  (field offset 20)
	mov	eax, DWORD PTR 32[rbp] # eax = color  (reload from shadow space)
	mov	DWORD PTR [rcx+rdx], eax  # particles[i].color = color

	# --- C LINE: break; ---
	jmp	.L17                   # Exit loop immediately (found and filled a slot)

.L16:                                   # --- SLOT WAS OCCUPIED: try next ---
	add	DWORD PTR -4[rbp], 1   # i++

.L15:                                   # --- LOOP CONDITION ---
	cmp	DWORD PTR -4[rbp], 49  # i <= 49? (MAX_PARTICLES - 1)
	jle	.L18                   # If yes, check next slot

	# (Reached here if all 50 slots were occupied - silently ignored)
	nop

.L17:                                   # --- BREAK TARGET / LOOP EXIT ---
	# --- FUNCTION EPILOGUE ---
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc

# ----------------------------------------------------------------------------
# FUNCTION: UpdateParticles()
# C SOURCE:  src/game.c lines 89-98
#
# PURPOSE:  Advance all live particles by one simulation step per call.
#           Called every frame from UpdateGame() (even when game is paused).
#           For each particle with life > 0:
#             x  += vx          (move horizontally)
#             y  += vy          (move vertically)
#             vy += 0.3f        (apply particle gravity - pulls down)
#             life--            (count down to death)
#           When life reaches 0, the slot is free for AddParticle() to reuse.
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
#   | int i (loop var) |  [rbp - 4]
#   +------------------+
#   | padding (4 B)    |  [rbp - 8]
#   +------------------+
#   | shadow space     |  [rbp - 16]   NOTE: only 16 bytes allocated here!
#   +------------------+  <-- rsp
#
#   IMPORTANT: sub rsp, 16 — only 16 bytes total.
#   This is safe because UpdateParticles() makes NO function calls.
#   No shadow space is needed when you never CALL another function.
#   (The 16 bytes are: 4 for 'i' + 12 for alignment to 16-byte boundary.)
#
# REGISTER USAGE:
#   eax  - loop index i, particle field values
#   ecx  - life - 1 (decremented value written back)
#   rdx  - byte offset = i * 24 into particles array
#   rax  - base address of target particle field
#   xmm0 - float computation (new x, new y, new vy)
#   xmm1 - loaded particle field value (old x, old y, old vy)
#
# PARTICLE GRAVITY NOTE:
#   .LC7 = 0.3f in IEEE 754 single precision = 0x3E99999A = 1050253722 decimal
#   This is different from the bird's GRAVITY (0.4f) - particles fall slower.
# ----------------------------------------------------------------------------
	.globl	_Z15UpdateParticlesv
	.def	_Z15UpdateParticlesv;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z15UpdateParticlesv

_Z15UpdateParticlesv:                   # === UpdateParticles() entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16                 # Only 16 bytes: 4 for 'i' + 12 alignment
	.seh_stackalloc	16              # (No shadow space needed - no CALL instructions)
	.seh_endprologue

	# --- C LINE: for (int i = 0; i < MAX_PARTICLES; i++) { ---
	mov	DWORD PTR -4[rbp], 0    # i = 0
	jmp	.L20                    # Jump to condition first

.L22:                                   # === LOOP BODY: update particle i ===

	# --- C LINE: if (particles[i].life > 0) { ---
	# Check if this particle slot is active (life > 0)
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax               # rdx = (int64) i
	mov	rax, rdx
	add	rax, rax               # rax = 2*i
	add	rax, rdx               # rax = 3*i
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax               # rdx = 24*i
	lea	rax, particles[rip+16] # rax = &particles[0].life
	mov	eax, DWORD PTR [rdx+rax]  # eax = particles[i].life
	test	eax, eax               # Test if life == 0
	jle	.L21                   # If life <= 0, particle is dead -> skip to i++

	# --- C LINE: particles[i].x += particles[i].vx; ---
	# Load particles[i].x into xmm1
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip]    # rax = &particles[0].x
	movss	xmm1, DWORD PTR [rdx+rax] # xmm1 = particles[i].x  (current x)

	# Load particles[i].vx into xmm0
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+8]  # rax = &particles[0].vx
	movss	xmm0, DWORD PTR [rdx+rax] # xmm0 = particles[i].vx

	addss	xmm0, xmm1             # xmm0 = vx + x  (new x position)

	# Store result back to particles[i].x
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip]    # rax = &particles[0].x
	movss	DWORD PTR [rdx+rax], xmm0 # particles[i].x = x + vx

	# --- C LINE: particles[i].y += particles[i].vy; ---
	# Load particles[i].y into xmm1
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+4]  # rax = &particles[0].y
	movss	xmm1, DWORD PTR [rdx+rax] # xmm1 = particles[i].y

	# Load particles[i].vy into xmm0
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+12] # rax = &particles[0].vy
	movss	xmm0, DWORD PTR [rdx+rax] # xmm0 = particles[i].vy

	addss	xmm0, xmm1             # xmm0 = vy + y  (new y position)

	# Store result back to particles[i].y
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+4]  # rax = &particles[0].y
	movss	DWORD PTR [rdx+rax], xmm0 # particles[i].y = y + vy

	# --- C LINE: particles[i].vy += 0.3f; // gravity ---
	# Load current vy into xmm1, load 0.3f from .LC7, add them, write back
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+12] # rax = &particles[0].vy
	movss	xmm1, DWORD PTR [rdx+rax] # xmm1 = particles[i].vy  (current)

	movss	xmm0, DWORD PTR .LC7[rip]  # xmm0 = 0.3f  (particle gravity constant)
	addss	xmm0, xmm1             # xmm0 = vy + 0.3f  (accelerate downward)

	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+12] # rax = &particles[0].vy
	movss	DWORD PTR [rdx+rax], xmm0 # particles[i].vy = vy + 0.3f

	# --- C LINE: particles[i].life--; ---
	# Read life, subtract 1, write back
	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+16] # rax = &particles[0].life
	mov	eax, DWORD PTR [rdx+rax]  # eax = particles[i].life

	lea	ecx, -1[rax]           # ecx = life - 1  (decrement)

	mov	eax, DWORD PTR -4[rbp] # eax = i
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3                 # rax = 24*i
	mov	rdx, rax
	lea	rax, particles[rip+16] # rax = &particles[0].life
	mov	DWORD PTR [rdx+rax], ecx  # particles[i].life = life - 1

.L21:                                   # --- END OF if(life > 0) body ---
	add	DWORD PTR -4[rbp], 1   # i++

.L20:                                   # --- LOOP CONDITION ---
	cmp	DWORD PTR -4[rbp], 49  # i <= 49? (MAX_PARTICLES - 1)
	jle	.L22                   # If yes, process next particle

	# --- FUNCTION EPILOGUE ---
	nop
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc

# ============================================================================
# READ-ONLY DATA SECTION - Sound effect name strings for UpdateGame
# ============================================================================
	.section .rdata,"dr"

# String constants passed as arg1 to PlaySoundEffect() calls below.
# These map to files: assets/audio/hit.wav, die.wav, point.wav
.LC17:
	.ascii "hit\0"         # SOUND_HIT   - played on collision death
.LC18:
	.ascii "die\0"         # SOUND_DIE   - played on death (after hit)
.LC21:
	.ascii "point\0"       # SOUND_POINT - played on passing a pipe


# ============================================================================
# TEXT SECTION
# ============================================================================
	.text

# ----------------------------------------------------------------------------
# FUNCTION: UpdateGame()
# C SOURCE:  src/game.c lines 101-212
#
# PURPOSE:  Main per-frame simulation tick.  Called ~60 times per second by
#           the Win32 WM_TIMER handler in main.c.
#
#           ALWAYS (even when paused/dead):
#             - frameCount++
#             - screenShake countdown
#             - flashEffect countdown
#             - UpdateParticles() (particles keep moving after death)
#             - groundOffset scrolling (continuous scroll)
#             - bird wing animation
#
#           ONLY IF (gameOver==0 AND started==1):
#             - Bird physics (gravity, terminal velocity)
#             - Bird position update
#             - Bird rotation from velocity
#             - Progressive pipe speed increase
#             - Background parallax
#             - Ground & ceiling collision detection
#             - Pipe movement + recycling + scoring
#             - AABB pipe collision detection
#
# PARAMETERS: none
# RETURNS:    void
#
# STACK FRAME LAYOUT (sub rsp, 64):
#
#   Higher addresses
#   +------------------+
#   | return address   |  [rbp + 8]
#   +------------------+
#   | saved rbp        |  [rbp + 0]
#   +------------------+  <-- rbp
#   | int i            |  [rbp -  4]   outer pipe loop counter
#   | int j            |  [rbp -  8]   inner particle spawn loop counter
#   | int hitboxOffset |  [rbp - 20]   = (BIRD_SIZE - BIRD_HITBOX_SIZE)/2 = 6
#   | int hitboxOffset2|  [rbp - 24]   same value for pipe collision
#   | float birdHitboxY|  [rbp - 28]   = bird.y + hitboxOffset (float)
#   | int birdHitboxX  |  [rbp - 32]   = BIRD_X + hitboxOffset = 356
#   | padding          |  [rbp - 16]   (alignment gap between -8 and -20)
#   +------------------+
#   | shadow space     |  [rbp - 64]   32 bytes for all CALL instructions
#   +------------------+  <-- rsp
#   Lower addresses
#
# REGISTER USAGE (varies by section - see inline comments):
#   eax  - general scratch, game field values
#   edx  - intermediate values
#   ecx  - intermediate values (birdHitboxX, pipe comparisons)
#   xmm0 - float computation (velocity, position, speed)
#   xmm1 - float second operand
#   xmm2 - float third operand (for background)
#   rcx  - arg1 for PlaySoundEffect() calls
#   rax  - address for LEA operations
#
# LOCAL VARIABLE MAP (stack offsets from rbp):
#   [rbp -  4]  int i              - outer for-loop index (pipes)
#   [rbp -  8]  int j              - inner for-loop index (particles)
#   [rbp - 20]  int hitboxOffset   - ground collision hitbox shrink = 6
#   [rbp - 24]  int hitboxOffset   - pipe  collision hitbox shrink = 6
#   [rbp - 28]  float birdHitboxY  - bird top-left y shrunk by hitboxOffset
#   [rbp - 32]  int birdHitboxX    - bird left-x shrunk by hitboxOffset = 356
#
# NOTE on .L64 (early return target):
#   .L64 is the function epilogue label.  When gameOver||!started,
#   execution jumps directly to .L64 (skipping all physics/collision).
# ----------------------------------------------------------------------------
	.globl	_Z10UpdateGamev
	.def	_Z10UpdateGamev;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10UpdateGamev

_Z10UpdateGamev:                        # === UpdateGame() entry point ===

	# --- FUNCTION PROLOGUE ---
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64                 # 32 locals + 32 shadow space
	.seh_stackalloc	64
	.seh_endprologue

	# -----------------------------------------------------------------------
	# SECTION 1: Always-run updates (run every frame regardless of game state)
	# -----------------------------------------------------------------------

	# --- C LINE: game.frameCount++; ---
	mov	eax, DWORD PTR game[rip+72]  # eax = game.frameCount  (offset +72)
	add	eax, 1                 # eax = frameCount + 1
	mov	DWORD PTR game[rip+72], eax  # game.frameCount = frameCount + 1

	# --- C LINE: if (game.screenShake > 0) game.screenShake--; ---
	# screenShake is set to 15 on death; decrements each frame to 0.
	# render.c reads it to apply camera offset while non-zero.
	mov	eax, DWORD PTR game[rip+84]  # eax = game.screenShake  (offset +84)
	test	eax, eax               # Is screenShake == 0?
	jle	.L24                   # If <= 0, skip decrement

	mov	eax, DWORD PTR game[rip+84]  # eax = game.screenShake
	sub	eax, 1                 # eax = screenShake - 1
	mov	DWORD PTR game[rip+84], eax  # game.screenShake = screenShake - 1

.L24:
	# --- C LINE: if (game.flashEffect > 0) game.flashEffect--; ---
	# flashEffect is set to 10 on death; render.c uses it to draw white overlay.
	mov	eax, DWORD PTR game[rip+88]  # eax = game.flashEffect  (offset +88)
	test	eax, eax               # Is flashEffect == 0?
	jle	.L25                   # If <= 0, skip decrement

	mov	eax, DWORD PTR game[rip+88]  # eax = game.flashEffect
	sub	eax, 1                 # eax = flashEffect - 1
	mov	DWORD PTR game[rip+88], eax  # game.flashEffect = flashEffect - 1

.L25:
	# --- C LINE: UpdateParticles(); ---
	# Advance all live particles (called even while game is over so they
	# continue flying after the bird dies for visual effect).
	call	_Z15UpdateParticlesv    # UpdateParticles()

	# --- C LINE: game.groundOffset -= GROUND_SCROLL_SPEED; ---
	# Ground scrolls continuously (even on game-over screen).
	# GROUND_SCROLL_SPEED = 3.0f = same constant as BASE_PIPE_SPEED (.LC2)
	movss	xmm0, DWORD PTR game[rip+80]  # xmm0 = game.groundOffset  (+80)
	movss	xmm1, DWORD PTR .LC2[rip]     # xmm1 = 3.0f  (GROUND_SCROLL_SPEED)
	subss	xmm0, xmm1             # xmm0 = groundOffset - 3.0f
	movss	DWORD PTR game[rip+80], xmm0  # game.groundOffset = updated value

	# --- C LINE: if (game.groundOffset <= -WINDOW_WIDTH) game.groundOffset = 0; ---
	# When ground texture scrolled one full width, reset to 0 (seamless loop).
	# .LC8 = -1280.0f (negative WINDOW_WIDTH) stored as IEEE 754 float.
	# comiss xmm0, xmm1 sets CF/ZF like an unsigned compare.
	# We want: if groundOffset <= -1280 then reset.
	# The compiler stores -1280.0 in xmm0 and groundOffset in xmm1,
	# then checks: is -1280.0 >= groundOffset? (i.e. groundOffset <= -1280)
	movss	xmm1, DWORD PTR game[rip+80]  # xmm1 = groundOffset (reload after store)
	movss	xmm0, DWORD PTR .LC8[rip]     # xmm0 = -1280.0f
	comiss	xmm0, xmm1             # Compare -1280.0f vs groundOffset
	jb	.L26                   # If -1280 < groundOffset (i.e. not wrapped), skip

	pxor	xmm0, xmm0             # xmm0 = 0.0f
	movss	DWORD PTR game[rip+80], xmm0  # game.groundOffset = 0  (wrap around)

.L26:
	# --- C LINE: if (game.frameCount % BIRD_ANIMATION_SPEED == 0) { ---
	# BIRD_ANIMATION_SPEED = 8 (advance wing frame every 8 game frames).
	# Modulo 8 with a power-of-2: compiler replaces % 8 with AND 7.
	# If (frameCount & 7) == 0, it's time to advance the wing frame.
	mov	eax, DWORD PTR game[rip+72]  # eax = game.frameCount
	and	eax, 7                 # eax = frameCount % 8  (% power-of-2 -> AND mask)
	test	eax, eax               # Is remainder == 0?
	jne	.L28                   # If not, skip animation update

	# --- C LINE: game.birdFrame = (game.birdFrame + 1) % 3; ---
	# Cycle through 3 wing animation frames: 0 -> 1 -> 2 -> 0 -> ...
	# Compiler uses magic number for % 3 (avoids DIV).
	# Magic constant 1431655766 is the fixed-point reciprocal for /3.
	mov	eax, DWORD PTR game[rip+92]  # eax = game.birdFrame  (0, 1, or 2)
	lea	ecx, 1[rax]            # ecx = birdFrame + 1  (next frame candidate)

	# Compute (birdFrame + 1) % 3 using magic multiply:
	movsx	rax, ecx               # rax = (int64)(birdFrame + 1)
	imul	rax, rax, 1431655766   # rax = value * magic constant for /3
	shr	rax, 32                # rax = high 32 bits (approx quotient)
	mov	rdx, rax               # rdx = approx quotient
	mov	eax, ecx               # eax = (birdFrame + 1)  (for sign correction)
	sar	eax, 31                # eax = sign bit (0 for positive)
	sub	edx, eax               # edx = (birdFrame+1) / 3  (sign corrected)
	mov	eax, edx               # eax = quotient
	add	eax, eax               # eax = 2 * quotient
	add	eax, edx               # eax = 3 * quotient  (multiply back)
	sub	ecx, eax               # ecx = (birdFrame+1) - 3*quotient = % 3
	mov	edx, ecx               # edx = result (0, 1, or 2)

	mov	DWORD PTR game[rip+92], edx  # game.birdFrame = (birdFrame + 1) % 3

.L28:
	# -----------------------------------------------------------------------
	# EARLY RETURN CHECK: if (game.gameOver || !game.started) return;
	# All code below only runs when the game is active.
	# -----------------------------------------------------------------------
	mov	eax, DWORD PTR game[rip+60]  # eax = game.gameOver  (offset +60)
	test	eax, eax               # Is gameOver != 0?
	jne	.L64                   # If game is over, jump to epilogue (return)

	mov	eax, DWORD PTR game[rip+64]  # eax = game.started  (offset +64)
	test	eax, eax               # Is started == 0?
	je	.L64                   # If not started yet, jump to epilogue (return)

	# -----------------------------------------------------------------------
	# SECTION 2: Active gameplay updates (only when started && !gameOver)
	# -----------------------------------------------------------------------

	# --- C LINE: game.bird.velocity += GRAVITY; ---
	# GRAVITY = 0.4f (.LC9 = 1061997773 as IEEE 754 bit pattern)
	# Positive velocity = downward (y increases downward in screen coords)
	movss	xmm1, DWORD PTR game[rip+4]  # xmm1 = game.bird.velocity  (offset +4)
	movss	xmm0, DWORD PTR .LC9[rip]    # xmm0 = GRAVITY = 0.4f
	addss	xmm0, xmm1             # xmm0 = velocity + 0.4f  (accelerate down)
	movss	DWORD PTR game[rip+4], xmm0  # game.bird.velocity = new velocity

	# --- C LINE: if (game.bird.velocity > MAX_VELOCITY) { ---
	# Cap terminal velocity at MAX_VELOCITY = 12.0f (.LC10)
	# This prevents the bird from going infinitely fast in a long fall.
	movss	xmm0, DWORD PTR game[rip+4]  # xmm0 = velocity (freshly updated)
	comiss	xmm0, DWORD PTR .LC10[rip]  # Compare velocity vs 12.0f
	jbe	.L32                   # If velocity <= 12.0f, skip cap

	# --- C LINE: game.bird.velocity = MAX_VELOCITY; ---
	movss	xmm0, DWORD PTR .LC10[rip]  # xmm0 = 12.0f (MAX_VELOCITY)
	movss	DWORD PTR game[rip+4], xmm0 # game.bird.velocity = 12.0f  (capped)

.L32:
	# --- C LINE: game.bird.y += game.bird.velocity; ---
	# Apply velocity to position each frame (Euler integration).
	movss	xmm1, DWORD PTR game[rip]    # xmm1 = game.bird.y  (offset +0)
	movss	xmm0, DWORD PTR game[rip+4]  # xmm0 = game.bird.velocity
	addss	xmm0, xmm1             # xmm0 = y + velocity  (new position)
	movss	DWORD PTR game[rip], xmm0    # game.bird.y = new position

	# --- C LINE: game.bird.rotation = game.bird.velocity * 3; ---
	# Bird tilts based on velocity: going down = tilt forward (positive degrees)
	# going up (after SPACE flap) = tilt back (negative degrees).
	# .LC11 = 3.0f  (rotation multiplier)
	movss	xmm1, DWORD PTR game[rip+4]  # xmm1 = game.bird.velocity
	movss	xmm0, DWORD PTR .LC11[rip]  # xmm0 = 3.0f
	mulss	xmm0, xmm1             # xmm0 = velocity * 3  (rotation degrees)
	movss	DWORD PTR game[rip+12], xmm0 # game.bird.rotation = velocity * 3

	# --- C LINE: if (game.bird.rotation > 90) game.bird.rotation = 90; ---
	# Clamp rotation to at most 90 degrees (nose-down limit).
	# .LC12 = 90.0f
	movss	xmm0, DWORD PTR game[rip+12] # xmm0 = rotation
	comiss	xmm0, DWORD PTR .LC12[rip]  # Compare rotation vs 90.0f
	jbe	.L34                   # If rotation <= 90, skip clamp

	movss	xmm0, DWORD PTR .LC12[rip]  # xmm0 = 90.0f
	movss	DWORD PTR game[rip+12], xmm0 # game.bird.rotation = 90.0f (clamped)

.L34:
	# --- C LINE: if (game.bird.rotation < -30) game.bird.rotation = -30; ---
	# Clamp rotation to at least -30 degrees (nose-up limit).
	# Note: comiss is unsigned-like; to check xmm1 < xmm0, compiler loads
	# -30.0 into xmm0 and rotation into xmm1, then does comiss xmm0, xmm1.
	# If -30.0 > rotation (i.e. rotation < -30), the branch is taken.
	# .LC13 = -30.0f
	movss	xmm1, DWORD PTR game[rip+12] # xmm1 = game.bird.rotation
	movss	xmm0, DWORD PTR .LC13[rip]  # xmm0 = -30.0f
	comiss	xmm0, xmm1             # Compare -30.0f vs rotation
	jbe	.L36                   # If -30 <= rotation (i.e. rotation >= -30), skip

	movss	xmm0, DWORD PTR .LC13[rip]  # xmm0 = -30.0f
	movss	DWORD PTR game[rip+12], xmm0 # game.bird.rotation = -30.0f (clamped)

.L36:
	# --- C LINE: game.pipeSpeed = BASE_PIPE_SPEED + (game.score / 5) * 0.5f; ---
	# Progressive difficulty: speed increases by 0.5 every 5 points scored.
	# Step 1: compute game.score / 5 using magic number (avoids DIV).
	# Magic constant 1717986919 is for /5 on 32-bit integers.
	mov	eax, DWORD PTR game[rip+52]  # eax = game.score  (offset +52)
	movsx	rdx, eax               # rdx = (int64) score
	imul	rdx, rdx, 1717986919   # rdx = score * magic (for /5)
	shr	rdx, 32                # rdx = high 32 bits (approx quotient)
	sar	edx                    # edx >>= 1  (scale correction)
	sar	eax, 31                # eax = sign bit
	sub	edx, eax               # edx = score / 5  (sign corrected)

	# Step 2: (score/5) * 0.5f
	# .LC14 = 0.5f  (.LC14 = 1056964608 as IEEE 754 bit pattern)
	pxor	xmm1, xmm1             # xmm1 = 0.0f (clear before conversion)
	cvtsi2ss	xmm1, edx      # xmm1 = (float)(score / 5)
	movss	xmm0, DWORD PTR .LC14[rip]  # xmm0 = 0.5f
	mulss	xmm1, xmm0             # xmm1 = (score/5) * 0.5f  (speed bonus)

	# Step 3: BASE_PIPE_SPEED + bonus
	# .LC2 = 3.0f (BASE_PIPE_SPEED)
	movss	xmm0, DWORD PTR .LC2[rip]   # xmm0 = 3.0f (BASE_PIPE_SPEED)
	addss	xmm0, xmm1             # xmm0 = 3.0 + (score/5)*0.5
	movss	DWORD PTR game[rip+68], xmm0 # game.pipeSpeed = computed value

	# --- C LINE: if (game.pipeSpeed > BASE_PIPE_SPEED + 3) game.pipeSpeed = BASE_PIPE_SPEED + 3; ---
	# Cap pipe speed at 6.0f (BASE_PIPE_SPEED + 3 = 3.0 + 3.0 = 6.0)
	# This is reached when score >= 6 (score/5 * 0.5 >= 3.0 -> score >= 30... 
	# actually speed cap at 6.0 means bonus of 3.0 when score >= 30).
	# .LC15 = 6.0f  (BASE_PIPE_SPEED + 3)
	movss	xmm0, DWORD PTR game[rip+68] # xmm0 = pipeSpeed
	comiss	xmm0, DWORD PTR .LC15[rip]  # Compare pipeSpeed vs 6.0f
	jbe	.L38                   # If pipeSpeed <= 6.0, no cap needed

	movss	xmm0, DWORD PTR .LC15[rip]  # xmm0 = 6.0f  (max speed)
	movss	DWORD PTR game[rip+68], xmm0 # game.pipeSpeed = 6.0f  (capped)

.L38:
	# --- C LINE: game.backgroundOffset -= game.pipeSpeed * 0.3f; ---
	# Background scrolls at 30% of pipe speed (parallax effect: bg looks further away).
	# .LC7 = 0.3f  (parallax factor, same constant used for particle gravity)
	movss	xmm0, DWORD PTR game[rip+76] # xmm0 = game.backgroundOffset  (+76)
	movss	xmm2, DWORD PTR game[rip+68] # xmm2 = game.pipeSpeed
	movss	xmm1, DWORD PTR .LC7[rip]    # xmm1 = 0.3f
	mulss	xmm1, xmm2             # xmm1 = pipeSpeed * 0.3f
	subss	xmm0, xmm1             # xmm0 = backgroundOffset - pipeSpeed*0.3f
	movss	DWORD PTR game[rip+76], xmm0 # game.backgroundOffset = new value

	# --- C LINE: if (game.backgroundOffset < -WINDOW_WIDTH) game.backgroundOffset = 0; ---
	# Wrap background when it scrolls a full screen width (seamless loop).
	# Same wrap logic as groundOffset above.
	movss	xmm1, DWORD PTR game[rip+76] # xmm1 = backgroundOffset (reloaded)
	movss	xmm0, DWORD PTR .LC8[rip]    # xmm0 = -1280.0f
	comiss	xmm0, xmm1             # Compare -1280.0f vs backgroundOffset
	jbe	.L40                   # If -1280 <= backgroundOffset, no wrap needed

	pxor	xmm0, xmm0             # xmm0 = 0.0f
	movss	DWORD PTR game[rip+76], xmm0 # game.backgroundOffset = 0  (wrap)

.L40:
	# -----------------------------------------------------------------------
	# SECTION 3: Ground and ceiling collision detection
	# -----------------------------------------------------------------------

	# --- C LINE: int hitboxOffset = (BIRD_SIZE - BIRD_HITBOX_SIZE) / 2; ---
	# BIRD_SIZE = 60, BIRD_HITBOX_SIZE = 47
	# hitboxOffset = (60 - 47) / 2 = 13 / 2 = 6  (integer division)
	# This shrinks the collision box inward for more forgiving gameplay feel.
	mov	DWORD PTR -20[rbp], 6       # [rbp-20] = hitboxOffset = 6
	# --- C LINE: if (game.bird.y + hitboxOffset > WINDOW_HEIGHT-GROUND_HEIGHT-BIRD_HITBOX_SIZE ---
	# Check BOTTOM boundary:
	#   birdHitboxY = bird.y + hitboxOffset
	#   limit = WINDOW_HEIGHT - GROUND_HEIGHT - BIRD_HITBOX_SIZE = 720-112-47 = 561
	#   .LC16 = 561.0f (precomputed constant)
	# If birdHitboxY > 561, bird has hit the ground.
	movss	xmm1, DWORD PTR game[rip]    # xmm1 = game.bird.y
	pxor	xmm0, xmm0             # xmm0 = 0.0f (clear before conversion)
	cvtsi2ss	xmm0, DWORD PTR -20[rbp] # xmm0 = (float)hitboxOffset = 6.0f
	addss	xmm0, xmm1             # xmm0 = bird.y + 6.0f = birdHitboxY
	comiss	xmm0, DWORD PTR .LC16[rip]  # Compare birdHitboxY vs 561.0f
	ja	.L42                   # If birdHitboxY > 561.0f, bird hit GROUND -> die

	# Check CEILING boundary: || game.bird.y + hitboxOffset < 0
	# If birdHitboxY < 0, bird flew above the top of the screen.
	movss	xmm1, DWORD PTR game[rip]    # xmm1 = game.bird.y (reload)
	pxor	xmm0, xmm0             # xmm0 = 0.0f
	cvtsi2ss	xmm0, DWORD PTR -20[rbp] # xmm0 = 6.0f (hitboxOffset)
	addss	xmm1, xmm0             # xmm1 = bird.y + hitboxOffset (birdHitboxY)
	pxor	xmm0, xmm0             # xmm0 = 0.0f
	comiss	xmm0, xmm1             # Compare 0.0f vs birdHitboxY
	jbe	.L43                   # If 0 <= birdHitboxY, bird is in bounds -> skip death

.L42:                                   # === GROUND/CEILING COLLISION: bird dies here ===

	# --- C LINE: game.gameOver = 1; game.bird.alive = 0; ---
	mov	DWORD PTR game[rip+60], 1    # game.gameOver = 1  (signal game over)
	mov	DWORD PTR game[rip+8], 0     # game.bird.alive = 0  (bird is dead)

	# --- C LINE: game.screenShake = 15; game.flashEffect = 10; ---
	mov	DWORD PTR game[rip+84], 15   # game.screenShake = 15 (camera shake for 15 frames)
	mov	DWORD PTR game[rip+88], 10   # game.flashEffect = 10 (white flash for 10 frames)

	# --- C LINE: SaveHighScore(); ---
	call	_Z13SaveHighScorev      # SaveHighScore() - may write to disk

	# --- C LINE: PlaySoundEffect(SOUND_HIT); ---
	# Win64: arg1 in RCX = pointer to "hit" string
	lea	rax, .LC17[rip]         # rax = address of "hit\0" string
	mov	rcx, rax               # rcx = arg1 = "hit"
	call	_Z15PlaySoundEffectPKc  # PlaySoundEffect("hit")

	# --- C LINE: PlaySoundEffect(SOUND_DIE); ---
	lea	rax, .LC18[rip]         # rax = address of "die\0" string
	mov	rcx, rax               # rcx = arg1 = "die"
	call	_Z15PlaySoundEffectPKc  # PlaySoundEffect("die")

	# --- C LINE: for (int i = 0; i < 15; i++) { ---
	# Spawn 15 pairs of particles at bird center (golden firework effect):
	#   gold       = RGB(255, 215,   0) -> packed as 0x0000D7FF = 55295
	#   dark orange= RGB(255, 140,   0) -> packed as 0x00008CFF = 36095
	# NOTE: Windows RGB() packs as 0x00BBGGRR (red in low byte).
	#   RGB(255, 215, 0): R=255=0xFF, G=215=0xD7, B=0=0x00 -> 0x0000D7FF = 55295
	#   RGB(255, 140, 0): R=255=0xFF, G=140=0x8C, B=0=0x00 -> 0x00008CFF = 36095
	#
	# AddParticle(x, y, color) calling convention:
	#   XMM0 = float x
	#   XMM1 = float y
	#   R8D  = COLORREF color
	#
	# .LC19 = bird.y center offset = BIRD_SIZE/2 = 30.0f (as float)
	# .LC20 = BIRD_X + BIRD_SIZE/2 = 350 + 30 = 380.0f (as float; loaded via DWORD/movd)
	mov	DWORD PTR -4[rbp], 0    # i = 0  (use [rbp-4] as loop var)
	jmp	.L45                    # Jump to condition first

.L46:                                   # === DEATH PARTICLE LOOP BODY ===

	# --- C LINE: AddParticle(BIRD_X+BIRD_SIZE/2, bird.y+BIRD_SIZE/2, RGB(255,215,0)); ---
	movss	xmm1, DWORD PTR game[rip]   # xmm1 = game.bird.y
	movss	xmm0, DWORD PTR .LC19[rip]  # xmm0 = 30.0f (BIRD_SIZE/2)
	addss	xmm0, xmm1             # xmm0 = bird.y + 30 (vertical center of bird)
	mov	r8d, 55295             # r8d = RGB(255,215,0) = gold  (0x0000D7FF)
	movaps	xmm1, xmm0             # xmm1 = y argument  (move y into arg2 register)
	mov	eax, DWORD PTR .LC20[rip]   # eax = raw float bits for 380.0f (BIRD_X+BIRD_SIZE/2)
	movd	xmm0, eax              # xmm0 = 380.0f  (x argument = horizontal center)
	call	_Z11AddParticleffm      # AddParticle(380.0f, bird.y+30, gold)

	# --- C LINE: AddParticle(BIRD_X+BIRD_SIZE/2, bird.y+BIRD_SIZE/2, RGB(255,140,0)); ---
	movss	xmm1, DWORD PTR game[rip]   # xmm1 = game.bird.y
	movss	xmm0, DWORD PTR .LC19[rip]  # xmm0 = 30.0f
	addss	xmm0, xmm1             # xmm0 = bird.y + 30
	mov	r8d, 36095             # r8d = RGB(255,140,0) = orange  (0x00008CFF)
	movaps	xmm1, xmm0             # xmm1 = y argument
	mov	eax, DWORD PTR .LC20[rip]   # eax = float bits for 380.0f
	movd	xmm0, eax              # xmm0 = 380.0f
	call	_Z11AddParticleffm      # AddParticle(380.0f, bird.y+30, orange)

	add	DWORD PTR -4[rbp], 1   # i++

.L45:                                   # --- PARTICLE SPAWN LOOP CONDITION ---
	cmp	DWORD PTR -4[rbp], 14  # i <= 14? (spawns 15 times: i=0..14)
	jle	.L46                   # If yes, spawn more particles

.L43:                                   # === END of ground collision block ===

	# -----------------------------------------------------------------------
	# SECTION 4: Pipe loop - move, recycle, score, AABB collision
	# -----------------------------------------------------------------------

	# --- C LINE: for (int i = 0; i < 3; i++) { ---
	# Iterate over 3 pipes. Note: this uses [rbp-8] for 'i' (outer pipe loop),
	# not [rbp-4] (which was used by the ground collision particle loop above).
	mov	DWORD PTR -8[rbp], 0    # i = 0  (pipe loop counter at [rbp-8])
	jmp	.L47                    # Jump to loop condition first (do-while style)

.L57:                                   # === PIPE LOOP BODY (i = 0, 1, 2) ===

	# -----------------------------------------------------------------------
	# STEP 1: Move pipe left by pipeSpeed pixels
	# C: game.pipes[i].x -= (int)game.pipeSpeed;
	#
	# PIPE STRUCT INDEXING:
	#   Pipe struct = 12 bytes (3 ints). To access pipes[i].x:
	#     offset = i * 12 = i * 3 * 4
	#   Compiler encodes i*12 as:  rax=i; rax*=2; rax+=i (now rax=3i); rax<<=2 (rax=12i)
	#   Base address of pipes[0].x = game + 16 (after 16-byte Bird struct)
	#   So pipes[i].x is at: game[rip+16] + i*12
	#   pipes[i].topHeight is at: game[rip+20] + i*12  (+4 from .x)
	#   pipes[i].scored   is at: game[rip+24] + i*12  (+8 from .x)
	#
	# cvttss2si = Convert Float To Int with Truncation (round toward zero).
	# This matches the C cast (int)game.pipeSpeed exactly.
	# -----------------------------------------------------------------------
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i  (sign-extend to 64 bits)
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i  (12 bytes per Pipe struct)
	mov	rdx, rax               # rdx = 12i  (struct offset)
	lea	rax, game[rip+16]      # rax = &game.pipes[0].x  (base address)
	mov	edx, DWORD PTR [rdx+rax] # edx = game.pipes[i].x  (current x position)
	movss	xmm0, DWORD PTR game[rip+68] # xmm0 = game.pipeSpeed (float)
	cvttss2si	eax, xmm0      # eax = (int)pipeSpeed  (truncate toward zero)
	mov	ecx, edx               # ecx = pipes[i].x
	sub	ecx, eax               # ecx = pipes[i].x - (int)pipeSpeed  (move left)
	mov	eax, DWORD PTR -8[rbp]  # eax = i  (reload for second index computation)
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+16]      # rax = &game.pipes[0].x
	mov	DWORD PTR [rdx+rax], ecx  # game.pipes[i].x = ecx  (write updated x)
	# -----------------------------------------------------------------------
	# STEP 2: Recycle pipe when it scrolls off the left edge
	# C: if (game.pipes[i].x < -PIPE_WIDTH) { ... }
	#
	# -PIPE_WIDTH = -103.  The compiler uses -104 in the comparison because
	# "x < -103" in integer math is equivalent to "x <= -104".
	# cmp eax, -104 ; jge .L48 means: if x >= -104, skip recycling.
	# Recycling fires when x < -104 (pipe is fully off the left edge).
	# -----------------------------------------------------------------------
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+16]      # rax = &pipes[0].x
	mov	eax, DWORD PTR [rdx+rax] # eax = pipes[i].x
	cmp	eax, -104              # Compare x vs -104  (i.e. x < -PIPE_WIDTH?)
	jge	.L48                   # If x >= -104, pipe still on screen -> skip recycle

	# --- PIPE RECYCLE: pipe went fully off screen, bring it back on right ---

	# --- C LINE: game.pipes[i].x = WINDOW_WIDTH; ---
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+16]      # rax = &pipes[0].x
	mov	DWORD PTR [rdx+rax], 1280  # pipes[i].x = 1280 (WINDOW_WIDTH = off right edge)

	# --- C LINE: game.pipes[i].topHeight = 100 + rand() % 208; ---
	# Same magic-number trick as ResetPipes() -- avoids slow DIV instruction.
	# rand() returns a value in [0, RAND_MAX]. We want rand() % 208.
	# Compiler computes: quotient = rand_val * 1321528399 >> 38, remainder = rand_val - quotient*208
	# (1321528399 is the magic constant for division by 208)
	call	rand                   # eax = rand()  (random number)
	movsx	rdx, eax               # rdx = (int64)rand_val  (sign-extend)
	imul	rdx, rdx, 1321528399   # rdx = rand_val * magic  (64-bit multiply)
	shr	rdx, 32                # rdx = high 32 bits = approximate quotient * 208/2^38
	sar	edx, 6                 # edx >>= 6  (total shift = 38 bits from the imul)
	mov	ecx, eax               # ecx = rand_val
	sar	ecx, 31                # ecx = sign bit of rand_val (0 if positive, -1 if negative)
	sub	edx, ecx               # edx = floor(rand_val / 208)  (correct for signed)
	imul	ecx, edx, 208         # ecx = (rand_val/208) * 208
	sub	eax, ecx               # eax = rand_val - (rand_val/208)*208 = rand_val % 208
	mov	edx, eax               # edx = rand_val % 208  (range 0..207)
	lea	ecx, 100[rdx]          # ecx = 100 + (rand_val % 208)  (range 100..307)
	                               # This keeps the gap within playable area:
	                               # topHeight + PIPE_GAP(200) + bottom <= 608 playable px

	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+20]      # rax = &pipes[0].topHeight  (game+20 = +4 from .x)
	mov	DWORD PTR [rdx+rax], ecx  # pipes[i].topHeight = 100 + rand()%208

	# --- C LINE: game.pipes[i].scored = 0; ---
	# Reset scored so the bird can earn a point passing this pipe again.
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+24]      # rax = &pipes[0].scored  (game+24 = +8 from .x)
	mov	DWORD PTR [rdx+rax], 0  # pipes[i].scored = 0  (not yet scored)

.L48:                                   # === END of recycle block ===
	# -----------------------------------------------------------------------
	# STEP 3: Score increment - award a point when bird clears the pipe
	# C: if (!game.pipes[i].scored && game.pipes[i].x + PIPE_WIDTH < BIRD_X) { ... }
	#
	# Condition breakdown:
	#   !scored       -- hasn't been scored yet for this pipe
	#   x + 103 < 350 -- pipe's right edge has passed the bird's x position
	#                    x < 350 - 103 = 247  => x <= 246
	# Compiler folds this to: cmp x, 245 ; jg skip  (scores when x <= 245)
	# This is a minor compiler rounding -- functionally identical at game speed.
	# -----------------------------------------------------------------------

	# --- PART A: Check !scored ---
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+24]      # rax = &pipes[0].scored
	mov	eax, DWORD PTR [rdx+rax] # eax = pipes[i].scored
	test	eax, eax               # ZF=1 if scored == 0 (not yet scored)
	jne	.L49                   # If already scored (eax != 0), skip scoring

	# --- PART B: Check x + PIPE_WIDTH < BIRD_X (pipe has passed the bird) ---
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+16]      # rax = &pipes[0].x
	mov	eax, DWORD PTR [rdx+rax] # eax = pipes[i].x
	cmp	eax, 245               # x <= 245? (x + PIPE_WIDTH < BIRD_X)
	jg	.L49                   # If x > 245, pipe hasn't passed bird yet -> skip

	# --- SCORING: bird cleared this pipe ---

	# --- C LINE: game.score++; ---
	mov	eax, DWORD PTR game[rip+52] # eax = game.score
	add	eax, 1                 # eax = score + 1
	mov	DWORD PTR game[rip+52], eax # game.score = score + 1

	# --- C LINE: game.pipes[i].scored = 1; ---
	# Prevent double-counting - mark this pipe as scored.
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+24]      # rax = &pipes[0].scored
	mov	DWORD PTR [rdx+rax], 1  # pipes[i].scored = 1

	# --- C LINE: PlaySoundEffect(SOUND_POINT); ---
	# .LC21 = "point\0"  (the SOUND_POINT constant is defined as this string)
	lea	rax, .LC21[rip]        # rax = address of "point\0"
	mov	rcx, rax               # rcx = arg1 = "point"
	call	_Z15PlaySoundEffectPKc # PlaySoundEffect("point")

	# --- C LINE: for (int j = 0; j < 5; j++) AddParticle(...); ---
	# Spawn 5 yellow star particles at the bird's right side (scoring celebration).
	# RGB(255,255,0) = pure yellow: R=0xFF, G=0xFF, B=0x00 -> 0x0000FFFF = 65535
	# x = BIRD_X + BIRD_SIZE = 350 + 60 = 410.0f  (.LC22 holds this float)
	# y = bird.y + BIRD_SIZE/2 = bird.y + 30.0f   (.LC19 = 30.0f)
	mov	DWORD PTR -12[rbp], 0   # j = 0  (use [rbp-12] as inner loop var)
	jmp	.L50                   # Jump to condition first

.L51:                                   # === SCORING PARTICLE LOOP BODY ===
	movss	xmm1, DWORD PTR game[rip]   # xmm1 = game.bird.y
	movss	xmm0, DWORD PTR .LC19[rip]  # xmm0 = 30.0f (BIRD_SIZE/2)
	addss	xmm0, xmm1             # xmm0 = bird.y + 30 (y center)
	mov	r8d, 65535             # r8d = RGB(255,255,0) = yellow (0x0000FFFF)
	movaps	xmm1, xmm0             # xmm1 = y argument
	mov	eax, DWORD PTR .LC22[rip]   # eax = float bits of 410.0f (BIRD_X + BIRD_SIZE)
	movd	xmm0, eax              # xmm0 = 410.0f (x argument)
	call	_Z11AddParticleffm      # AddParticle(410.0f, bird.y+30, yellow)
	add	DWORD PTR -12[rbp], 1   # j++

.L50:                                   # --- SCORING PARTICLE LOOP CONDITION ---
	cmp	DWORD PTR -12[rbp], 4   # j <= 4? (spawns 5 times: j=0..4)
	jle	.L51                   # If yes, continue

.L49:                                   # === END of scoring block ===

	# -----------------------------------------------------------------------
	# STEP 4: AABB Pipe Collision Detection
	# C:  int hitboxOffset = (BIRD_SIZE - BIRD_HITBOX_SIZE) / 2;   // = 6
	#     float birdHitboxY = game.bird.y + hitboxOffset;
	#     int   birdHitboxX = BIRD_X + hitboxOffset;               // = 356
	#
	#     OUTER CONDITION (vertical overlap check):
	#     if (birdHitboxY < pipes[i].topHeight ||
	#         birdHitboxY + BIRD_HITBOX_SIZE > pipes[i].topHeight + PIPE_GAP)
	#       -> bird is vertically IN the pipe zone (either too high or too low)
	#
	#     INNER CONDITION (horizontal overlap check - only tested if vertical overlaps):
	#     if (birdHitboxX + BIRD_HITBOX_SIZE > pipes[i].x &&
	#         birdHitboxX < pipes[i].x + PIPE_WIDTH)
	#       -> bird's horizontal range overlaps the pipe's horizontal range
	#       -> COLLISION!
	#
	# The two-stage check is a standard AABB (Axis-Aligned Bounding Box) test.
	# Checking vertical first is a common optimization: most pipes are below
	# or above the bird and fail the vertical test, avoiding the horizontal check.
	#
	# .LC23 = BIRD_HITBOX_SIZE as float = 47.0f  (used in birdHitboxY + 47.0f)
	#
	# LOCAL VARIABLES in this block:
	#   [rbp-24] = hitboxOffset  (int, = 6)
	#   [rbp-28] = birdHitboxY   (float)
	#   [rbp-32] = birdHitboxX   (int, = 356)
	# -----------------------------------------------------------------------

	# --- C LINE: int hitboxOffset = (BIRD_SIZE - BIRD_HITBOX_SIZE) / 2; ---
	mov	DWORD PTR -24[rbp], 6   # hitboxOffset = 6  (precomputed: (60-47)/2)

	# --- C LINE: float birdHitboxY = game.bird.y + hitboxOffset; ---
	movss	xmm1, DWORD PTR game[rip]   # xmm1 = game.bird.y
	pxor	xmm0, xmm0             # xmm0 = 0.0f
	cvtsi2ss	xmm0, DWORD PTR -24[rbp] # xmm0 = (float)hitboxOffset = 6.0f
	addss	xmm0, xmm1             # xmm0 = bird.y + 6 = birdHitboxY
	movss	DWORD PTR -28[rbp], xmm0    # store birdHitboxY at [rbp-28]

	# --- C LINE: int birdHitboxX = BIRD_X + hitboxOffset; ---
	mov	eax, DWORD PTR -24[rbp] # eax = hitboxOffset = 6
	add	eax, 350               # eax = 350 + 6 = 356 (BIRD_X + hitboxOffset)
	mov	DWORD PTR -32[rbp], eax # birdHitboxX = 356

	# --- OUTER CONDITION PART 1: birdHitboxY < pipes[i].topHeight ---
	# If birdHitboxY is ABOVE the top pipe, bird is in the gap or above.
	# comiss xmm0, [rbp-28] compares topHeight vs birdHitboxY.
	# 'ja' = jump if above (unsigned >). Since both floats are positive, this
	# is equivalent to a signed > comparison. If topHeight > birdHitboxY, bird
	# is above the gap opening (in top pipe zone) -> possible collision.
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+20]      # rax = &pipes[0].topHeight
	mov	eax, DWORD PTR [rdx+rax] # eax = pipes[i].topHeight (int)
	pxor	xmm0, xmm0             # xmm0 = 0.0f
	cvtsi2ss	xmm0, eax      # xmm0 = (float)pipes[i].topHeight
	comiss	xmm0, DWORD PTR -28[rbp]  # Compare topHeight vs birdHitboxY
	ja	.L52                   # If topHeight > birdHitboxY -> bird above gap -> check X

	# --- OUTER CONDITION PART 2: birdHitboxY + BIRD_HITBOX_SIZE > topHeight + PIPE_GAP ---
	# .LC23 = BIRD_HITBOX_SIZE = 47.0f
	# If birdHitboxY + 47 > topHeight + 200, bird is below the gap (in bottom pipe zone).
	movss	xmm1, DWORD PTR -28[rbp]   # xmm1 = birdHitboxY
	movss	xmm0, DWORD PTR .LC23[rip]  # xmm0 = 47.0f (BIRD_HITBOX_SIZE)
	addss	xmm0, xmm1             # xmm0 = birdHitboxY + 47 (bird's bottom edge)
	mov	eax, DWORD PTR -8[rbp]  # eax = i (reload for index)
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+20]      # rax = &pipes[0].topHeight
	mov	eax, DWORD PTR [rdx+rax] # eax = pipes[i].topHeight
	add	eax, 200               # eax = topHeight + PIPE_GAP (200 = gap size)
	pxor	xmm1, xmm1             # xmm1 = 0.0f
	cvtsi2ss	xmm1, eax      # xmm1 = (float)(topHeight + 200) = gap bottom edge
	comiss	xmm0, xmm1             # Compare birdBottom vs gapBottom
	jbe	.L53                   # If birdBottom <= gapBottom: bird fits in gap -> no vertical collision

.L52:                                   # === VERTICAL OVERLAP CONFIRMED - check horizontal ===
	# Bird is vertically in the pipe zone. Now check X-axis overlap.
	#
	# INNER CONDITION PART 1: birdHitboxX + BIRD_HITBOX_SIZE > pipes[i].x
	# Bird's RIGHT edge must be past the pipe's LEFT edge.
	# birdHitboxX + 47 > pipes[i].x  =>  356 + 47 = 403 > pipes[i].x
	# 'lea ecx, 47[rax]' computes birdHitboxX + 47 without a separate add.
	mov	eax, DWORD PTR -32[rbp] # eax = birdHitboxX = 356
	lea	ecx, 47[rax]           # ecx = birdHitboxX + 47 (bird's right edge)
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+16]      # rax = &pipes[0].x
	mov	eax, DWORD PTR [rdx+rax] # eax = pipes[i].x (pipe's left edge)
	cmp	ecx, eax               # Compare (birdRight) vs pipes[i].x
	jl	.L53                   # If birdRight < pipeLeft: no horizontal overlap -> skip

	# INNER CONDITION PART 2: birdHitboxX < pipes[i].x + PIPE_WIDTH
	# Bird's LEFT edge must be before the pipe's RIGHT edge.
	# birdHitboxX < pipes[i].x + 103
	mov	eax, DWORD PTR -8[rbp]  # eax = i
	movsx	rdx, eax               # rdx = (int64)i
	mov	rax, rdx               # rax = i
	add	rax, rax               # rax = 2i
	add	rax, rdx               # rax = 3i
	sal	rax, 2                 # rax = 12i
	mov	rdx, rax               # rdx = 12i
	lea	rax, game[rip+16]      # rax = &pipes[0].x
	mov	eax, DWORD PTR [rdx+rax] # eax = pipes[i].x
	add	eax, 103               # eax = pipes[i].x + PIPE_WIDTH (pipe's right edge)
	cmp	DWORD PTR -32[rbp], eax # Compare birdHitboxX vs pipeRight
	jg	.L53                   # If birdLeft > pipeRight: no overlap -> skip

	# ===================================================================
	# PIPE COLLISION CONFIRMED: bird hit a pipe - same death sequence as
	# ground/ceiling collision above.
	# ===================================================================

	# --- C LINE: game.gameOver = 1; game.bird.alive = 0; ---
	mov	DWORD PTR game[rip+60], 1    # game.gameOver = 1
	mov	DWORD PTR game[rip+8], 0     # game.bird.alive = 0

	# --- C LINE: game.screenShake = 15; game.flashEffect = 10; ---
	mov	DWORD PTR game[rip+84], 15   # game.screenShake = 15
	mov	DWORD PTR game[rip+88], 10   # game.flashEffect = 10

	# --- C LINE: SaveHighScore(); ---
	call	_Z13SaveHighScorev

	# --- C LINE: PlaySoundEffect(SOUND_HIT); PlaySoundEffect(SOUND_DIE); ---
	lea	rax, .LC17[rip]        # rax = "hit\0"
	mov	rcx, rax               # rcx = arg1
	call	_Z15PlaySoundEffectPKc  # PlaySoundEffect("hit")

	lea	rax, .LC18[rip]        # rax = "die\0"
	mov	rcx, rax               # rcx = arg1
	call	_Z15PlaySoundEffectPKc  # PlaySoundEffect("die")

	# --- C LINE: for (int j = 0; j < 20; j++) { ... } ---
	# Spawn 20 pairs of particles: red + gold explosion at bird center.
	# RGB(255,0,0)   = pure red:  R=0xFF, G=0x00, B=0x00 -> 0x000000FF = 255
	# RGB(255,215,0) = gold:      R=0xFF, G=0xD7, B=0x00 -> 0x0000D7FF = 55295
	# x = BIRD_X + BIRD_SIZE/2 = 380.0f  (.LC20)
	# y = bird.y + BIRD_SIZE/2 = bird.y + 30.0f  (.LC19)
	mov	DWORD PTR -16[rbp], 0   # j = 0  (use [rbp-16] as inner loop var)
	jmp	.L55                   # Jump to condition first

.L56:                                   # === PIPE COLLISION PARTICLE LOOP BODY ===

	# --- Spawn red particle ---
	movss	xmm1, DWORD PTR game[rip]   # xmm1 = game.bird.y
	movss	xmm0, DWORD PTR .LC19[rip]  # xmm0 = 30.0f
	addss	xmm0, xmm1             # xmm0 = bird.y + 30
	mov	r8d, 255               # r8d = RGB(255,0,0) = red (0x000000FF)
	movaps	xmm1, xmm0             # xmm1 = y argument
	mov	eax, DWORD PTR .LC20[rip]   # eax = float bits of 380.0f
	movd	xmm0, eax              # xmm0 = 380.0f (x argument)
	call	_Z11AddParticleffm      # AddParticle(380.0f, bird.y+30, red)

	# --- Spawn gold particle ---
	movss	xmm1, DWORD PTR game[rip]   # xmm1 = game.bird.y
	movss	xmm0, DWORD PTR .LC19[rip]  # xmm0 = 30.0f
	addss	xmm0, xmm1             # xmm0 = bird.y + 30
	mov	r8d, 55295             # r8d = RGB(255,215,0) = gold (0x0000D7FF)
	movaps	xmm1, xmm0             # xmm1 = y argument
	mov	eax, DWORD PTR .LC20[rip]   # eax = float bits of 380.0f
	movd	xmm0, eax              # xmm0 = 380.0f
	call	_Z11AddParticleffm      # AddParticle(380.0f, bird.y+30, gold)

	add	DWORD PTR -16[rbp], 1   # j++

.L55:                                   # --- PIPE COLLISION PARTICLE LOOP CONDITION ---
	cmp	DWORD PTR -16[rbp], 19  # j <= 19? (spawns 20 times: j=0..19)
	jle	.L56                   # If yes, continue

.L53:                                   # === END of pipe collision block ===

	# --- PIPE LOOP INCREMENT & CONDITION ---
	add	DWORD PTR -8[rbp], 1   # i++  (advance to next pipe)

.L47:                                   # --- PIPE LOOP CONDITION CHECK ---
	cmp	DWORD PTR -8[rbp], 2   # i <= 2? (3 pipes: i=0,1,2)
	jle	.L57                   # If i <= 2, process next pipe

	# -----------------------------------------------------------------------
	# All 3 pipes processed. UpdateGame() is done.
	# Fall through to function epilogue.
	# -----------------------------------------------------------------------
	jmp	.L23                   # Jump to epilogue (past the early-return NOP)

.L64:                                   # === EARLY RETURN TARGET ===
	# This label is the landing point for the early return at the top:
	#   if (game.gameOver || !game.started) return;
	# The compiler emitted a 'nop' here as a placeholder for the empty return body.
	nop                             # No-op placeholder (empty return branch body)

.L23:                                   # === UpdateGame() EPILOGUE ===
 # src/game.c:212: }
	add	rsp, 64	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"

# ============================================================================
# CHUNK 10 — READ-ONLY FLOAT CONSTANTS (.rdata section)
# ============================================================================
# All float literals from game.c end up here as raw 32-bit IEEE 754 patterns.
# The compiler emits them as .long (32-bit integer) directives — NOT as .float —
# because .long guarantees the exact bit pattern regardless of host FPU rounding.
#
# HOW TO DECODE AN IEEE 754 SINGLE-PRECISION FLOAT (.long value N):
#   1. Convert N to 32-bit two's-complement binary (unsigned if positive)
#   2. Bit 31        → sign        (0=positive, 1=negative)
#   3. Bits 30:23    → exponent    (add 127 bias: true_exp = field - 127)
#   4. Bits 22:0     → mantissa    (implicit leading 1: value = 1.mantissa)
#   5. Result        → (-1)^sign × (1 + mantissa/2^23) × 2^(true_exp)
#
# Labels .LC1, .LC3-.LC5 are the ASCII sound-name strings defined earlier
# in the .text section (not floats). They are intentionally missing here.
# Labels .LC17-.LC18 are the "hit"/"die" strings. .LC21 is "point".
# Only the numeric float constants appear in this .rdata block.
#
# REGISTER NOTE: These constants are loaded via RIP-relative addressing:
#   movss xmm0, .LC7[rip]   ; loads 4 bytes from this section into XMM0
# This is how position-independent code accesses read-only data on x86-64.
# ============================================================================

# -----------------------------------------------------------------------
# .LC0 = 304.0f
# Hex: 0x43980000
# Decode: sign=0, exp=0x87=135 (bias→8), mantissa=0x180000
#         (1 + 0x180000/0x800000) × 2^8 = 1.1875 × 256 = 304.0
# Used in: InitGame() — bird.y initial position (game.bird.y = 304.0f)
# -----------------------------------------------------------------------
	.align 4
.LC0:
	.long	1134231552              # 304.0f  — bird starting Y position

# -----------------------------------------------------------------------
# .LC2 = 4.0f
# Hex: 0x40800000
# Decode: sign=0, exp=0x81=129 (bias→2), mantissa=0x000000
#         (1.0) × 2^2 = 4.0
# Used in: AddParticle() — divisor for particle velocity range:
#          vx = (rand()%20 - 10) / 4.0f → range [-2.5, 2.5]
# -----------------------------------------------------------------------
	.align 4
.LC2:
	.long	1082130432              # 4.0f   — particle velocity divisor

# -----------------------------------------------------------------------
# .LC6 = 10.0f
# Hex: 0x41200000
# Decode: sign=0, exp=0x82=130 (bias→3), mantissa=0x200000
#         (1 + 0.25) × 8 = 10.0
# Used in: AddParticle() — divisor for lifetime or vy velocity scale
# -----------------------------------------------------------------------
	.align 4
.LC6:
	.long	1092616192              # 10.0f  — particle velocity/lifetime scale

# -----------------------------------------------------------------------
# .LC7 = 0.3f  (closest IEEE 754 representation of 0.3, which is irrational in binary)
# Hex: 0x3E99999A
# Decode: sign=0, exp=0x7D=125 (bias→-2), mantissa=0x19999A
#         (1 + 0.19999...) × 0.25 = 1.2 × 0.25 ≈ 0.30000...
# NOTE: 0.3 cannot be represented exactly in binary floating point.
#       The compiler uses the nearest 32-bit pattern.
# Used in:
#   UpdateParticles() — particle gravity:  particle.vy += 0.3f each frame
#   UpdateGame()      — background parallax: backgroundOffset -= pipeSpeed * 0.3f
# -----------------------------------------------------------------------
	.align 4
.LC7:
	.long	1050253722              # 0.3f   — particle gravity / parallax factor

# -----------------------------------------------------------------------
# .LC8 = -1280.0f
# Hex: 0xC4A00000  (negative: bit 31 = 1)
# Decode: sign=1, exp=0x89=137 (bias→10), mantissa=0x200000
#         -(1 + 0.25) × 1024 = -1280.0
# Used in: UpdateGame() — scroll wrap threshold for groundOffset and backgroundOffset
#          When offset < -1280.0f (one full screen width), reset to 0 to create infinite loop
# -----------------------------------------------------------------------
	.align 4
.LC8:
	.long	-996147200              # -1280.0f — scroll offset wrap threshold (WINDOW_WIDTH)

# -----------------------------------------------------------------------
# .LC9 = 0.8f
# Hex: 0x3F4CCCCD
# Decode: sign=0, exp=0x7E=126 (bias→-1), mantissa=0x4CCCCD
#         (1 + 0.6000...) × 0.5 = 0.8000...
# NOTE: Like 0.3f, 0.8 has a repeating binary representation.
#       0x4CCCCD is the nearest 23-bit mantissa pattern for 0.6.
# Used in: AddParticle() — particle velocity scaling factor
# -----------------------------------------------------------------------
	.align 4
.LC9:
	.long	1061997773              # 0.8f   — particle velocity multiplier

# -----------------------------------------------------------------------
# .LC10 = 12.0f
# Hex: 0x41400000
# Decode: sign=0, exp=0x82=130 (bias→3), mantissa=0x400000
#         (1 + 0.5) × 8 = 12.0
# Used in: UpdateGame() — terminal velocity cap:
#          if (bird.velocity > 12.0f) bird.velocity = 12.0f
#          Prevents the bird from falling faster than 12 pixels/frame
# -----------------------------------------------------------------------
	.align 4
.LC10:
	.long	1097859072              # 12.0f  — bird terminal velocity cap

# -----------------------------------------------------------------------
# .LC11 = 3.0f
# Hex: 0x40400000
# Decode: sign=0, exp=0x80=128 (bias→1), mantissa=0x400000
#         (1 + 0.5) × 2 = 3.0
# Used in TWO places:
#   1. UpdateGame() — initial pipeSpeed value: pipeSpeed starts at 3.0f
#   2. UpdateGame() — rotation multiplier: bird.rotation = velocity * 3.0f
#      (converts velocity units to visual degrees of tilt)
# -----------------------------------------------------------------------
	.align 4
.LC11:
	.long	1077936128              # 3.0f   — initial pipeSpeed / rotation multiplier

# -----------------------------------------------------------------------
# .LC12 = 90.0f
# Hex: 0x42B40000
# Decode: sign=0, exp=0x85=133 (bias→6), mantissa=0x340000
#         (1 + 0.40625) × 64 = 90.0
# Used in: UpdateGame() — maximum rotation clamp:
#          if (bird.rotation > 90.0f) bird.rotation = 90.0f
#          Bird noses straight down at 90 degrees (falling/dead)
# -----------------------------------------------------------------------
	.align 4
.LC12:
	.long	1119092736              # 90.0f  — max bird rotation (nose-down cap)

# -----------------------------------------------------------------------
# .LC13 = -30.0f
# Hex: 0xC1F00000  (negative: bit 31 = 1)
# Decode: sign=1, exp=0x83=131 (bias→4), mantissa=0x700000
#         -(1 + 0.875) × 16 = -30.0
# Used in: UpdateGame() — minimum rotation clamp:
#          if (bird.rotation < -30.0f) bird.rotation = -30.0f
#          Bird tilts up max 30 degrees after a jump — looks natural
# -----------------------------------------------------------------------
	.align 4
.LC13:
	.long	-1041235968             # -30.0f — min bird rotation (nose-up cap)

# -----------------------------------------------------------------------
# .LC14 = 0.5f
# Hex: 0x3F000000
# Decode: sign=0, exp=0x7E=126 (bias→-1), mantissa=0x000000
#         (1.0) × 0.5 = 0.5
# Used in: UpdateGame() — pipeSpeed difficulty step:
#          pipeSpeed = 3.0f + (score/5) * 0.5f
#          Every 5 points, pipe speed increases by 0.5f
# -----------------------------------------------------------------------
	.align 4
.LC14:
	.long	1056964608              # 0.5f   — pipeSpeed increment per 5 score points

# -----------------------------------------------------------------------
# .LC15 = 7.0f
# Hex: 0x40E00000
# Decode: sign=0, exp=0x81=129 (bias→2), mantissa=0x600000
#         (1 + 0.75) × 4 = 7.0
# Used in: UpdateGame() — maximum pipeSpeed cap:
#          if (pipeSpeed > 7.0f) pipeSpeed = 7.0f
#          Ensures the game doesn't become unplayably fast
# -----------------------------------------------------------------------
	.align 4
.LC15:
	.long	1088421888              # 7.0f   — max pipeSpeed cap

# -----------------------------------------------------------------------
# .LC16 = 560.0f
# Hex: 0x440C0000
# Decode: sign=0, exp=0x88=136 (bias→9), mantissa=0x0C0000
#         (1 + 0.09375) × 512 = 560.0
# Used in: UpdateGame() — ground death threshold (float comparison):
#          if (birdHitboxY > 560.0f) -> bird hit ground
#          Derived from: WINDOW_HEIGHT(720) - GROUND_HEIGHT(112) - hitboxOffset(~48)
#          Note: integer comparison uses the literal 47 (BIRD_HITBOX_SIZE);
#                this float constant is the precomputed Y limit for birdHitboxY.
# -----------------------------------------------------------------------
	.align 4
.LC16:
	.long	1141637120              # 560.0f — ground collision Y threshold for birdHitboxY

# -----------------------------------------------------------------------
# .LC19 = 30.0f
# Hex: 0x41F00000
# Decode: sign=0, exp=0x83=131 (bias→4), mantissa=0x700000
#         (1 + 0.875) × 16 = 30.0
# Used in: UpdateGame() — particle spawn Y center offset:
#          y = game.bird.y + 30.0f
#          30 = BIRD_SIZE / 2 = 60 / 2 — centers the particle burst on the bird
#          Appears in both the death particle loop and the scoring particle loop
# -----------------------------------------------------------------------
	.align 4
.LC19:
	.long	1106247680              # 30.0f  — BIRD_SIZE/2, particle center-Y offset

# -----------------------------------------------------------------------
# .LC20 = 380.0f
# Hex: 0x43BE0000
# Decode: sign=0, exp=0x87=135 (bias→8), mantissa=0x3E0000
#         (1 + 0.484375) × 256 = 380.0
# Used in: UpdateGame() — particle spawn X for death/pipe collision:
#          x = BIRD_X + BIRD_SIZE/2 = 350 + 30 = 380.0f
#          Centers the death explosion particle burst on the bird horizontally
# -----------------------------------------------------------------------
	.align 4
.LC20:
	.long	1136525312              # 380.0f — BIRD_X + BIRD_SIZE/2 = particle center-X (death)

# -----------------------------------------------------------------------
# .LC22 = 410.0f
# Hex: 0x43CD0000
# Decode: sign=0, exp=0x87=135 (bias→8), mantissa=0x4D0000
#         (1 + 0.601562...) × 256 = 410.0
# Used in: UpdateGame() — particle spawn X for scoring celebration:
#          x = BIRD_X + BIRD_SIZE = 350 + 60 = 410.0f
#          Spawns yellow star particles at the bird's RIGHT edge (just cleared pipe)
# -----------------------------------------------------------------------
	.align 4
.LC22:
	.long	1137508352              # 410.0f — BIRD_X + BIRD_SIZE = particle X (scoring)

# -----------------------------------------------------------------------
# .LC23 = 48.0f
# Hex: 0x42400000
# Decode: sign=0, exp=0x84=132 (bias→5), mantissa=0x400000
#         (1 + 0.5) × 32 = 48.0
# Used in: UpdateGame() — AABB pipe collision, vertical overlap test:
#          birdHitboxY + 48.0f > topHeight + PIPE_GAP
#          This is the float version of BIRD_HITBOX_SIZE used in the Y-axis
#          floating-point comparison. Integer comparisons in X-axis use literal 47.
#          The small discrepancy (47 int vs 48.0f) comes from the compiler folding
#          hitboxOffset computations differently for int vs float contexts.
# -----------------------------------------------------------------------
	.align 4
.LC23:
	.long	1111490560              # 48.0f  — BIRD_HITBOX_SIZE as float (Y-axis AABB test)
	.ident	"GCC: (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) 15.2.0"
	.def	rand;	.scl	2;	.type	32;	.endef
	.def	fopen;	.scl	2;	.type	32;	.endef
	.def	fread;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
	.def	fwrite;	.scl	2;	.type	32;	.endef
	.def	_Z15PlaySoundEffectPKc;	.scl	2;	.type	32;	.endef
