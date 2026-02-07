	.file	"game.c"
	.intel_syntax noprefix
 # GNU C++17 (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=x86-64
	.text
	.globl	game
	.bss
	.align 32
game:
	.space 96
	.globl	particles
	.align 32
particles:
	.space 1200
	.text
	.globl	_Z8InitGamev
	.def	_Z8InitGamev;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z8InitGamev
_Z8InitGamev:
.LFB6491:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
 # src/game.c:13:     game.bird.y = WINDOW_HEIGHT / 2.0f - 50;
	movss	xmm0, DWORD PTR .LC0[rip]	 # tmp98,
	movss	DWORD PTR game[rip], xmm0	 # game.bird.y, tmp98
 # src/game.c:14:     game.bird.velocity = 0;
	pxor	xmm0, xmm0	 # tmp99
	movss	DWORD PTR game[rip+4], xmm0	 # game.bird.velocity, tmp99
 # src/game.c:15:     game.bird.alive = 1;
	mov	DWORD PTR game[rip+8], 1	 # game.bird.alive,
 # src/game.c:16:     game.bird.rotation = 0;
	pxor	xmm0, xmm0	 # tmp100
	movss	DWORD PTR game[rip+12], xmm0	 # game.bird.rotation, tmp100
 # src/game.c:17:     game.score = 0;
	mov	DWORD PTR game[rip+52], 0	 # game.score,
 # src/game.c:18:     game.gameOver = 0;
	mov	DWORD PTR game[rip+60], 0	 # game.gameOver,
 # src/game.c:19:     game.started = 0;
	mov	DWORD PTR game[rip+64], 0	 # game.started,
 # src/game.c:20:     game.pipeSpeed = BASE_PIPE_SPEED;
	movss	xmm0, DWORD PTR .LC2[rip]	 # tmp101,
	movss	DWORD PTR game[rip+68], xmm0	 # game.pipeSpeed, tmp101
 # src/game.c:21:     game.frameCount = 0;
	mov	DWORD PTR game[rip+72], 0	 # game.frameCount,
 # src/game.c:22:     game.backgroundOffset = 0;
	pxor	xmm0, xmm0	 # tmp102
	movss	DWORD PTR game[rip+76], xmm0	 # game.backgroundOffset, tmp102
 # src/game.c:23:     game.groundOffset = 0;
	pxor	xmm0, xmm0	 # tmp103
	movss	DWORD PTR game[rip+80], xmm0	 # game.groundOffset, tmp103
 # src/game.c:24:     game.screenShake = 0;
	mov	DWORD PTR game[rip+84], 0	 # game.screenShake,
 # src/game.c:25:     game.flashEffect = 0;
	mov	DWORD PTR game[rip+88], 0	 # game.flashEffect,
 # src/game.c:26:     game.birdFrame = 0;
	mov	DWORD PTR game[rip+92], 0	 # game.birdFrame,
 # src/game.c:28:     LoadHighScore();
	call	_Z13LoadHighScorev	 #
 # src/game.c:29:     ResetPipes();
	call	_Z10ResetPipesv	 #
 # src/game.c:32:     for (int i = 0; i < MAX_PARTICLES; i++) {
	mov	DWORD PTR -4[rbp], 0	 # i,
 # src/game.c:32:     for (int i = 0; i < MAX_PARTICLES; i++) {
	jmp	.L2	 #
.L3:
 # src/game.c:33:         particles[i].life = 0;
	mov	eax, DWORD PTR -4[rbp]	 # tmp105, i
	movsx	rdx, eax	 # tmp104, tmp105
	mov	rax, rdx	 # tmp107, tmp104
	add	rax, rax	 # tmp107
	add	rax, rdx	 # tmp107, tmp104
	sal	rax, 3	 # tmp108,
	mov	rdx, rax	 # tmp106, tmp107
	lea	rax, particles[rip+16]	 # tmp109,
	mov	DWORD PTR [rdx+rax], 0	 # particles[i_1].life,
 # src/game.c:32:     for (int i = 0; i < MAX_PARTICLES; i++) {
	add	DWORD PTR -4[rbp], 1	 # i,
.L2:
 # src/game.c:32:     for (int i = 0; i < MAX_PARTICLES; i++) {
	cmp	DWORD PTR -4[rbp], 49	 # i,
	jle	.L3	 #,
 # src/game.c:35: }
	nop	
	nop	
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.globl	_Z10ResetPipesv
	.def	_Z10ResetPipesv;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10ResetPipesv
_Z10ResetPipesv:
.LFB6492:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
 # src/game.c:39:     for (int i = 0; i < 3; i++) {
	mov	DWORD PTR -4[rbp], 0	 # i,
 # src/game.c:39:     for (int i = 0; i < 3; i++) {
	jmp	.L5	 #
.L6:
 # src/game.c:40:         game.pipes[i].x = WINDOW_WIDTH + i * 400;  // Spacing for landscape
	mov	eax, DWORD PTR -4[rbp]	 # tmp103, i
	imul	eax, eax, 400	 # _1, tmp103,
 # src/game.c:40:         game.pipes[i].x = WINDOW_WIDTH + i * 400;  // Spacing for landscape
	lea	ecx, 1280[rax]	 # _2,
 # src/game.c:40:         game.pipes[i].x = WINDOW_WIDTH + i * 400;  // Spacing for landscape
	mov	eax, DWORD PTR -4[rbp]	 # tmp105, i
	movsx	rdx, eax	 # tmp104, tmp105
	mov	rax, rdx	 # tmp107, tmp104
	add	rax, rax	 # tmp107
	add	rax, rdx	 # tmp107, tmp104
	sal	rax, 2	 # tmp108,
	mov	rdx, rax	 # tmp106, tmp107
	lea	rax, game[rip+16]	 # tmp109,
	mov	DWORD PTR [rdx+rax], ecx	 # game.pipes[i_6].x, _2
 # src/game.c:45:         game.pipes[i].topHeight = 100 + rand() % 208;
	call	rand	 #
 # src/game.c:45:         game.pipes[i].topHeight = 100 + rand() % 208;
	movsx	rdx, eax	 # tmp110, _3
	imul	rdx, rdx, 1321528399	 # tmp111, tmp110,
	shr	rdx, 32	 # tmp112,
	sar	edx, 6	 # tmp113,
	mov	ecx, eax	 # tmp114, _3
	sar	ecx, 31	 # tmp114,
	sub	edx, ecx	 # _4, tmp114
	imul	ecx, edx, 208	 # tmp115, _4,
	sub	eax, ecx	 # _3, tmp115
	mov	edx, eax	 # _4, _3
 # src/game.c:45:         game.pipes[i].topHeight = 100 + rand() % 208;
	lea	ecx, 100[rdx]	 # _5,
 # src/game.c:45:         game.pipes[i].topHeight = 100 + rand() % 208;
	mov	eax, DWORD PTR -4[rbp]	 # tmp117, i
	movsx	rdx, eax	 # tmp116, tmp117
	mov	rax, rdx	 # tmp119, tmp116
	add	rax, rax	 # tmp119
	add	rax, rdx	 # tmp119, tmp116
	sal	rax, 2	 # tmp120,
	mov	rdx, rax	 # tmp118, tmp119
	lea	rax, game[rip+20]	 # tmp121,
	mov	DWORD PTR [rdx+rax], ecx	 # game.pipes[i_6].topHeight, _5
 # src/game.c:46:         game.pipes[i].scored = 0;
	mov	eax, DWORD PTR -4[rbp]	 # tmp123, i
	movsx	rdx, eax	 # tmp122, tmp123
	mov	rax, rdx	 # tmp125, tmp122
	add	rax, rax	 # tmp125
	add	rax, rdx	 # tmp125, tmp122
	sal	rax, 2	 # tmp126,
	mov	rdx, rax	 # tmp124, tmp125
	lea	rax, game[rip+24]	 # tmp127,
	mov	DWORD PTR [rdx+rax], 0	 # game.pipes[i_6].scored,
 # src/game.c:39:     for (int i = 0; i < 3; i++) {
	add	DWORD PTR -4[rbp], 1	 # i,
.L5:
 # src/game.c:39:     for (int i = 0; i < 3; i++) {
	cmp	DWORD PTR -4[rbp], 2	 # i,
	jle	.L6	 #,
 # src/game.c:48: }
	nop	
	nop	
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
.LC3:
	.ascii "rb\0"
.LC4:
	.ascii "flappy_highscore.dat\0"
	.text
	.globl	_Z13LoadHighScorev
	.def	_Z13LoadHighScorev;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z13LoadHighScorev
_Z13LoadHighScorev:
.LFB6493:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
 # src/game.c:52:     FILE* file = fopen(HIGHSCORE_FILE, "rb");
	lea	rdx, .LC3[rip]	 # tmp99,
	lea	rax, .LC4[rip]	 # tmp100,
	mov	rcx, rax	 #, tmp100
	call	fopen	 #
 # src/game.c:52:     FILE* file = fopen(HIGHSCORE_FILE, "rb");
	mov	QWORD PTR -8[rbp], rax	 # file, _4
 # src/game.c:53:     if (file) {
	cmp	QWORD PTR -8[rbp], 0	 # file,
	je	.L8	 #,
 # src/game.c:54:         fread(&game.highScore, sizeof(int), 1, file);
	mov	rdx, QWORD PTR -8[rbp]	 # tmp101, file
	lea	rax, game[rip+56]	 # tmp102,
	mov	r9, rdx	 #, tmp101
	mov	r8d, 1	 #,
	mov	edx, 4	 #,
	mov	rcx, rax	 #, tmp102
	call	fread	 #
 # src/game.c:55:         fclose(file);
	mov	rax, QWORD PTR -8[rbp]	 # tmp103, file
	mov	rcx, rax	 #, tmp103
	call	fclose	 #
 # src/game.c:59: }
	jmp	.L10	 #
.L8:
 # src/game.c:57:         game.highScore = 0;
	mov	DWORD PTR game[rip+56], 0	 # game.highScore,
.L10:
 # src/game.c:59: }
	nop	
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
.LC5:
	.ascii "wb\0"
	.text
	.globl	_Z13SaveHighScorev
	.def	_Z13SaveHighScorev;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z13SaveHighScorev
_Z13SaveHighScorev:
.LFB6494:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
 # src/game.c:63:     if (game.score > game.highScore) {
	mov	edx, DWORD PTR game[rip+52]	 # _1, game.score
 # src/game.c:63:     if (game.score > game.highScore) {
	mov	eax, DWORD PTR game[rip+56]	 # _2, game.highScore
 # src/game.c:63:     if (game.score > game.highScore) {
	cmp	edx, eax	 # _1, _2
	jle	.L13	 #,
 # src/game.c:64:         game.highScore = game.score;
	mov	eax, DWORD PTR game[rip+52]	 # _3, game.score
 # src/game.c:64:         game.highScore = game.score;
	mov	DWORD PTR game[rip+56], eax	 # game.highScore, _3
 # src/game.c:65:         FILE* file = fopen(HIGHSCORE_FILE, "wb");
	lea	rdx, .LC5[rip]	 # tmp102,
	lea	rax, .LC4[rip]	 # tmp103,
	mov	rcx, rax	 #, tmp103
	call	fopen	 #
 # src/game.c:65:         FILE* file = fopen(HIGHSCORE_FILE, "wb");
	mov	QWORD PTR -8[rbp], rax	 # file, _8
 # src/game.c:66:         if (file) {
	cmp	QWORD PTR -8[rbp], 0	 # file,
	je	.L13	 #,
 # src/game.c:67:             fwrite(&game.highScore, sizeof(int), 1, file);
	mov	rdx, QWORD PTR -8[rbp]	 # tmp104, file
	lea	rax, game[rip+56]	 # tmp105,
	mov	r9, rdx	 #, tmp104
	mov	r8d, 1	 #,
	mov	edx, 4	 #,
	mov	rcx, rax	 #, tmp105
	call	fwrite	 #
 # src/game.c:68:             fclose(file);
	mov	rax, QWORD PTR -8[rbp]	 # tmp106, file
	mov	rcx, rax	 #, tmp106
	call	fclose	 #
.L13:
 # src/game.c:71: }
	nop	
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.globl	_Z11AddParticleffm
	.def	_Z11AddParticleffm;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z11AddParticleffm
_Z11AddParticleffm:
.LFB6495:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
	movss	DWORD PTR 16[rbp], xmm0	 # x, x
	movss	DWORD PTR 24[rbp], xmm1	 # y, y
	mov	DWORD PTR 32[rbp], r8d	 # color, color
 # src/game.c:75:     for (int i = 0; i < MAX_PARTICLES; i++) {
	mov	DWORD PTR -4[rbp], 0	 # i,
 # src/game.c:75:     for (int i = 0; i < MAX_PARTICLES; i++) {
	jmp	.L15	 #
.L18:
 # src/game.c:76:         if (particles[i].life <= 0) {
	mov	eax, DWORD PTR -4[rbp]	 # tmp113, i
	movsx	rdx, eax	 # tmp112, tmp113
	mov	rax, rdx	 # tmp115, tmp112
	add	rax, rax	 # tmp115
	add	rax, rdx	 # tmp115, tmp112
	sal	rax, 3	 # tmp116,
	mov	rdx, rax	 # tmp114, tmp115
	lea	rax, particles[rip+16]	 # tmp117,
	mov	eax, DWORD PTR [rdx+rax]	 # _1, particles[i_15].life
 # src/game.c:76:         if (particles[i].life <= 0) {
	test	eax, eax	 # _1
	jg	.L16	 #,
 # src/game.c:77:             particles[i].x = x;
	mov	eax, DWORD PTR -4[rbp]	 # tmp119, i
	movsx	rdx, eax	 # tmp118, tmp119
	mov	rax, rdx	 # tmp121, tmp118
	add	rax, rax	 # tmp121
	add	rax, rdx	 # tmp121, tmp118
	sal	rax, 3	 # tmp122,
	mov	rdx, rax	 # tmp120, tmp121
	lea	rax, particles[rip]	 # tmp123,
	movss	xmm0, DWORD PTR 16[rbp]	 # tmp124, x
	movss	DWORD PTR [rdx+rax], xmm0	 # particles[i_15].x, tmp124
 # src/game.c:78:             particles[i].y = y;
	mov	eax, DWORD PTR -4[rbp]	 # tmp126, i
	movsx	rdx, eax	 # tmp125, tmp126
	mov	rax, rdx	 # tmp128, tmp125
	add	rax, rax	 # tmp128
	add	rax, rdx	 # tmp128, tmp125
	sal	rax, 3	 # tmp129,
	mov	rdx, rax	 # tmp127, tmp128
	lea	rax, particles[rip+4]	 # tmp130,
	movss	xmm0, DWORD PTR 24[rbp]	 # tmp131, y
	movss	DWORD PTR [rdx+rax], xmm0	 # particles[i_15].y, tmp131
 # src/game.c:79:             particles[i].vx = (rand() % 100 - 50) / 10.0f;
	call	rand	 #
 # src/game.c:79:             particles[i].vx = (rand() % 100 - 50) / 10.0f;
	movsx	rdx, eax	 # tmp132, _2
	imul	rdx, rdx, 1374389535	 # tmp133, tmp132,
	shr	rdx, 32	 # tmp134,
	sar	edx, 5	 # tmp135,
	mov	ecx, eax	 # tmp136, _2
	sar	ecx, 31	 # tmp136,
	sub	edx, ecx	 # _3, tmp136
	imul	ecx, edx, 100	 # tmp137, _3,
	sub	eax, ecx	 # _2, tmp137
	mov	edx, eax	 # _3, _2
 # src/game.c:79:             particles[i].vx = (rand() % 100 - 50) / 10.0f;
	lea	eax, -50[rdx]	 # _4,
 # src/game.c:79:             particles[i].vx = (rand() % 100 - 50) / 10.0f;
	pxor	xmm0, xmm0	 # _5
	cvtsi2ss	xmm0, eax	 # _5, _4
	movss	xmm1, DWORD PTR .LC6[rip]	 # tmp138,
	divss	xmm0, xmm1	 # _6, tmp138
 # src/game.c:79:             particles[i].vx = (rand() % 100 - 50) / 10.0f;
	mov	eax, DWORD PTR -4[rbp]	 # tmp140, i
	movsx	rdx, eax	 # tmp139, tmp140
	mov	rax, rdx	 # tmp142, tmp139
	add	rax, rax	 # tmp142
	add	rax, rdx	 # tmp142, tmp139
	sal	rax, 3	 # tmp143,
	mov	rdx, rax	 # tmp141, tmp142
	lea	rax, particles[rip+8]	 # tmp144,
	movss	DWORD PTR [rdx+rax], xmm0	 # particles[i_15].vx, _6
 # src/game.c:80:             particles[i].vy = (rand() % 100 - 50) / 10.0f;
	call	rand	 #
 # src/game.c:80:             particles[i].vy = (rand() % 100 - 50) / 10.0f;
	movsx	rdx, eax	 # tmp145, _7
	imul	rdx, rdx, 1374389535	 # tmp146, tmp145,
	shr	rdx, 32	 # tmp147,
	sar	edx, 5	 # tmp148,
	mov	ecx, eax	 # tmp149, _7
	sar	ecx, 31	 # tmp149,
	sub	edx, ecx	 # _8, tmp149
	imul	ecx, edx, 100	 # tmp150, _8,
	sub	eax, ecx	 # _7, tmp150
	mov	edx, eax	 # _8, _7
 # src/game.c:80:             particles[i].vy = (rand() % 100 - 50) / 10.0f;
	lea	eax, -50[rdx]	 # _9,
 # src/game.c:80:             particles[i].vy = (rand() % 100 - 50) / 10.0f;
	pxor	xmm0, xmm0	 # _10
	cvtsi2ss	xmm0, eax	 # _10, _9
	movss	xmm1, DWORD PTR .LC6[rip]	 # tmp151,
	divss	xmm0, xmm1	 # _11, tmp151
 # src/game.c:80:             particles[i].vy = (rand() % 100 - 50) / 10.0f;
	mov	eax, DWORD PTR -4[rbp]	 # tmp153, i
	movsx	rdx, eax	 # tmp152, tmp153
	mov	rax, rdx	 # tmp155, tmp152
	add	rax, rax	 # tmp155
	add	rax, rdx	 # tmp155, tmp152
	sal	rax, 3	 # tmp156,
	mov	rdx, rax	 # tmp154, tmp155
	lea	rax, particles[rip+12]	 # tmp157,
	movss	DWORD PTR [rdx+rax], xmm0	 # particles[i_15].vy, _11
 # src/game.c:81:             particles[i].life = 20 + rand() % 20;
	call	rand	 #
	mov	ecx, eax	 # _12,
 # src/game.c:81:             particles[i].life = 20 + rand() % 20;
	movsx	rax, ecx	 # tmp158, _12
	imul	rax, rax, 1717986919	 # tmp159, tmp158,
	shr	rax, 32	 # tmp160,
	mov	edx, eax	 # tmp161, tmp160
	sar	edx, 3	 # tmp161,
	mov	eax, ecx	 # tmp162, _12
	sar	eax, 31	 # tmp162,
	sub	edx, eax	 # _13, tmp162
	mov	eax, edx	 # tmp163, _13
	sal	eax, 2	 # tmp163,
	add	eax, edx	 # tmp163, _13
	sal	eax, 2	 # tmp164,
	sub	ecx, eax	 # _12, tmp163
	mov	edx, ecx	 # _13, _12
 # src/game.c:81:             particles[i].life = 20 + rand() % 20;
	lea	ecx, 20[rdx]	 # _14,
 # src/game.c:81:             particles[i].life = 20 + rand() % 20;
	mov	eax, DWORD PTR -4[rbp]	 # tmp166, i
	movsx	rdx, eax	 # tmp165, tmp166
	mov	rax, rdx	 # tmp168, tmp165
	add	rax, rax	 # tmp168
	add	rax, rdx	 # tmp168, tmp165
	sal	rax, 3	 # tmp169,
	mov	rdx, rax	 # tmp167, tmp168
	lea	rax, particles[rip+16]	 # tmp170,
	mov	DWORD PTR [rdx+rax], ecx	 # particles[i_15].life, _14
 # src/game.c:82:             particles[i].color = color;
	mov	eax, DWORD PTR -4[rbp]	 # tmp172, i
	movsx	rdx, eax	 # tmp171, tmp172
	mov	rax, rdx	 # tmp174, tmp171
	add	rax, rax	 # tmp174
	add	rax, rdx	 # tmp174, tmp171
	sal	rax, 3	 # tmp175,
	mov	rcx, rax	 # tmp173, tmp174
	lea	rdx, particles[rip+20]	 # tmp176,
	mov	eax, DWORD PTR 32[rbp]	 # tmp177, color
	mov	DWORD PTR [rcx+rdx], eax	 # particles[i_15].color, tmp177
 # src/game.c:83:             break;
	jmp	.L17	 #
.L16:
 # src/game.c:75:     for (int i = 0; i < MAX_PARTICLES; i++) {
	add	DWORD PTR -4[rbp], 1	 # i,
.L15:
 # src/game.c:75:     for (int i = 0; i < MAX_PARTICLES; i++) {
	cmp	DWORD PTR -4[rbp], 49	 # i,
	jle	.L18	 #,
 # src/game.c:86: }
	nop	
.L17:
	nop	
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.globl	_Z15UpdateParticlesv
	.def	_Z15UpdateParticlesv;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z15UpdateParticlesv
_Z15UpdateParticlesv:
.LFB6496:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 16	 #,
	.seh_stackalloc	16
	.seh_endprologue
 # src/game.c:90:     for (int i = 0; i < MAX_PARTICLES; i++) {
	mov	DWORD PTR -4[rbp], 0	 # i,
 # src/game.c:90:     for (int i = 0; i < MAX_PARTICLES; i++) {
	jmp	.L20	 #
.L22:
 # src/game.c:91:         if (particles[i].life > 0) {
	mov	eax, DWORD PTR -4[rbp]	 # tmp110, i
	movsx	rdx, eax	 # tmp109, tmp110
	mov	rax, rdx	 # tmp112, tmp109
	add	rax, rax	 # tmp112
	add	rax, rdx	 # tmp112, tmp109
	sal	rax, 3	 # tmp113,
	mov	rdx, rax	 # tmp111, tmp112
	lea	rax, particles[rip+16]	 # tmp114,
	mov	eax, DWORD PTR [rdx+rax]	 # _1, particles[i_12].life
 # src/game.c:91:         if (particles[i].life > 0) {
	test	eax, eax	 # _1
	jle	.L21	 #,
 # src/game.c:92:             particles[i].x += particles[i].vx;
	mov	eax, DWORD PTR -4[rbp]	 # tmp116, i
	movsx	rdx, eax	 # tmp115, tmp116
	mov	rax, rdx	 # tmp118, tmp115
	add	rax, rax	 # tmp118
	add	rax, rdx	 # tmp118, tmp115
	sal	rax, 3	 # tmp119,
	mov	rdx, rax	 # tmp117, tmp118
	lea	rax, particles[rip]	 # tmp120,
	movss	xmm1, DWORD PTR [rdx+rax]	 # _2, particles[i_12].x
 # src/game.c:92:             particles[i].x += particles[i].vx;
	mov	eax, DWORD PTR -4[rbp]	 # tmp122, i
	movsx	rdx, eax	 # tmp121, tmp122
	mov	rax, rdx	 # tmp124, tmp121
	add	rax, rax	 # tmp124
	add	rax, rdx	 # tmp124, tmp121
	sal	rax, 3	 # tmp125,
	mov	rdx, rax	 # tmp123, tmp124
	lea	rax, particles[rip+8]	 # tmp126,
	movss	xmm0, DWORD PTR [rdx+rax]	 # _3, particles[i_12].vx
 # src/game.c:92:             particles[i].x += particles[i].vx;
	addss	xmm0, xmm1	 # _4, _2
	mov	eax, DWORD PTR -4[rbp]	 # tmp128, i
	movsx	rdx, eax	 # tmp127, tmp128
	mov	rax, rdx	 # tmp130, tmp127
	add	rax, rax	 # tmp130
	add	rax, rdx	 # tmp130, tmp127
	sal	rax, 3	 # tmp131,
	mov	rdx, rax	 # tmp129, tmp130
	lea	rax, particles[rip]	 # tmp132,
	movss	DWORD PTR [rdx+rax], xmm0	 # particles[i_12].x, _4
 # src/game.c:93:             particles[i].y += particles[i].vy;
	mov	eax, DWORD PTR -4[rbp]	 # tmp134, i
	movsx	rdx, eax	 # tmp133, tmp134
	mov	rax, rdx	 # tmp136, tmp133
	add	rax, rax	 # tmp136
	add	rax, rdx	 # tmp136, tmp133
	sal	rax, 3	 # tmp137,
	mov	rdx, rax	 # tmp135, tmp136
	lea	rax, particles[rip+4]	 # tmp138,
	movss	xmm1, DWORD PTR [rdx+rax]	 # _5, particles[i_12].y
 # src/game.c:93:             particles[i].y += particles[i].vy;
	mov	eax, DWORD PTR -4[rbp]	 # tmp140, i
	movsx	rdx, eax	 # tmp139, tmp140
	mov	rax, rdx	 # tmp142, tmp139
	add	rax, rax	 # tmp142
	add	rax, rdx	 # tmp142, tmp139
	sal	rax, 3	 # tmp143,
	mov	rdx, rax	 # tmp141, tmp142
	lea	rax, particles[rip+12]	 # tmp144,
	movss	xmm0, DWORD PTR [rdx+rax]	 # _6, particles[i_12].vy
 # src/game.c:93:             particles[i].y += particles[i].vy;
	addss	xmm0, xmm1	 # _7, _5
	mov	eax, DWORD PTR -4[rbp]	 # tmp146, i
	movsx	rdx, eax	 # tmp145, tmp146
	mov	rax, rdx	 # tmp148, tmp145
	add	rax, rax	 # tmp148
	add	rax, rdx	 # tmp148, tmp145
	sal	rax, 3	 # tmp149,
	mov	rdx, rax	 # tmp147, tmp148
	lea	rax, particles[rip+4]	 # tmp150,
	movss	DWORD PTR [rdx+rax], xmm0	 # particles[i_12].y, _7
 # src/game.c:94:             particles[i].vy += 0.3f; // gravity
	mov	eax, DWORD PTR -4[rbp]	 # tmp152, i
	movsx	rdx, eax	 # tmp151, tmp152
	mov	rax, rdx	 # tmp154, tmp151
	add	rax, rax	 # tmp154
	add	rax, rdx	 # tmp154, tmp151
	sal	rax, 3	 # tmp155,
	mov	rdx, rax	 # tmp153, tmp154
	lea	rax, particles[rip+12]	 # tmp156,
	movss	xmm1, DWORD PTR [rdx+rax]	 # _8, particles[i_12].vy
 # src/game.c:94:             particles[i].vy += 0.3f; // gravity
	movss	xmm0, DWORD PTR .LC7[rip]	 # tmp157,
	addss	xmm0, xmm1	 # _9, _8
	mov	eax, DWORD PTR -4[rbp]	 # tmp159, i
	movsx	rdx, eax	 # tmp158, tmp159
	mov	rax, rdx	 # tmp161, tmp158
	add	rax, rax	 # tmp161
	add	rax, rdx	 # tmp161, tmp158
	sal	rax, 3	 # tmp162,
	mov	rdx, rax	 # tmp160, tmp161
	lea	rax, particles[rip+12]	 # tmp163,
	movss	DWORD PTR [rdx+rax], xmm0	 # particles[i_12].vy, _9
 # src/game.c:95:             particles[i].life--;
	mov	eax, DWORD PTR -4[rbp]	 # tmp165, i
	movsx	rdx, eax	 # tmp164, tmp165
	mov	rax, rdx	 # tmp167, tmp164
	add	rax, rax	 # tmp167
	add	rax, rdx	 # tmp167, tmp164
	sal	rax, 3	 # tmp168,
	mov	rdx, rax	 # tmp166, tmp167
	lea	rax, particles[rip+16]	 # tmp169,
	mov	eax, DWORD PTR [rdx+rax]	 # _10, particles[i_12].life
 # src/game.c:95:             particles[i].life--;
	lea	ecx, -1[rax]	 # _11,
	mov	eax, DWORD PTR -4[rbp]	 # tmp171, i
	movsx	rdx, eax	 # tmp170, tmp171
	mov	rax, rdx	 # tmp173, tmp170
	add	rax, rax	 # tmp173
	add	rax, rdx	 # tmp173, tmp170
	sal	rax, 3	 # tmp174,
	mov	rdx, rax	 # tmp172, tmp173
	lea	rax, particles[rip+16]	 # tmp175,
	mov	DWORD PTR [rdx+rax], ecx	 # particles[i_12].life, _11
.L21:
 # src/game.c:90:     for (int i = 0; i < MAX_PARTICLES; i++) {
	add	DWORD PTR -4[rbp], 1	 # i,
.L20:
 # src/game.c:90:     for (int i = 0; i < MAX_PARTICLES; i++) {
	cmp	DWORD PTR -4[rbp], 49	 # i,
	jle	.L22	 #,
 # src/game.c:98: }
	nop	
	nop	
	add	rsp, 16	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
.LC17:
	.ascii "hit\0"
.LC18:
	.ascii "die\0"
.LC21:
	.ascii "point\0"
	.text
	.globl	_Z10UpdateGamev
	.def	_Z10UpdateGamev;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10UpdateGamev
_Z10UpdateGamev:
.LFB6497:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 64	 #,
	.seh_stackalloc	64
	.seh_endprologue
 # src/game.c:102:     game.frameCount++;
	mov	eax, DWORD PTR game[rip+72]	 # _1, game.frameCount
 # src/game.c:102:     game.frameCount++;
	add	eax, 1	 # _2,
	mov	DWORD PTR game[rip+72], eax	 # game.frameCount, _2
 # src/game.c:105:     if (game.screenShake > 0) game.screenShake--;
	mov	eax, DWORD PTR game[rip+84]	 # _3, game.screenShake
 # src/game.c:105:     if (game.screenShake > 0) game.screenShake--;
	test	eax, eax	 # _3
	jle	.L24	 #,
 # src/game.c:105:     if (game.screenShake > 0) game.screenShake--;
	mov	eax, DWORD PTR game[rip+84]	 # _4, game.screenShake
 # src/game.c:105:     if (game.screenShake > 0) game.screenShake--;
	sub	eax, 1	 # _5,
	mov	DWORD PTR game[rip+84], eax	 # game.screenShake, _5
.L24:
 # src/game.c:106:     if (game.flashEffect > 0) game.flashEffect--;
	mov	eax, DWORD PTR game[rip+88]	 # _6, game.flashEffect
 # src/game.c:106:     if (game.flashEffect > 0) game.flashEffect--;
	test	eax, eax	 # _6
	jle	.L25	 #,
 # src/game.c:106:     if (game.flashEffect > 0) game.flashEffect--;
	mov	eax, DWORD PTR game[rip+88]	 # _7, game.flashEffect
 # src/game.c:106:     if (game.flashEffect > 0) game.flashEffect--;
	sub	eax, 1	 # _8,
	mov	DWORD PTR game[rip+88], eax	 # game.flashEffect, _8
.L25:
 # src/game.c:109:     UpdateParticles();
	call	_Z15UpdateParticlesv	 #
 # src/game.c:112:     game.groundOffset -= GROUND_SCROLL_SPEED;
	movss	xmm0, DWORD PTR game[rip+80]	 # _9, game.groundOffset
 # src/game.c:112:     game.groundOffset -= GROUND_SCROLL_SPEED;
	movss	xmm1, DWORD PTR .LC2[rip]	 # tmp178,
	subss	xmm0, xmm1	 # _10, tmp178
	movss	DWORD PTR game[rip+80], xmm0	 # game.groundOffset, _10
 # src/game.c:113:     if (game.groundOffset <= -WINDOW_WIDTH) game.groundOffset = 0;
	movss	xmm1, DWORD PTR game[rip+80]	 # _11, game.groundOffset
 # src/game.c:113:     if (game.groundOffset <= -WINDOW_WIDTH) game.groundOffset = 0;
	movss	xmm0, DWORD PTR .LC8[rip]	 # tmp179,
	comiss	xmm0, xmm1	 # tmp179, _11
	jb	.L26	 #,
 # src/game.c:113:     if (game.groundOffset <= -WINDOW_WIDTH) game.groundOffset = 0;
	pxor	xmm0, xmm0	 # tmp180
	movss	DWORD PTR game[rip+80], xmm0	 # game.groundOffset, tmp180
.L26:
 # src/game.c:116:     if (game.frameCount % BIRD_ANIMATION_SPEED == 0) {
	mov	eax, DWORD PTR game[rip+72]	 # _12, game.frameCount
 # src/game.c:116:     if (game.frameCount % BIRD_ANIMATION_SPEED == 0) {
	and	eax, 7	 # _14,
 # src/game.c:116:     if (game.frameCount % BIRD_ANIMATION_SPEED == 0) {
	test	eax, eax	 # _14
	jne	.L28	 #,
 # src/game.c:117:         game.birdFrame = (game.birdFrame + 1) % 3;
	mov	eax, DWORD PTR game[rip+92]	 # _15, game.birdFrame
 # src/game.c:117:         game.birdFrame = (game.birdFrame + 1) % 3;
	lea	ecx, 1[rax]	 # _16,
 # src/game.c:117:         game.birdFrame = (game.birdFrame + 1) % 3;
	movsx	rax, ecx	 # tmp181, _16
	imul	rax, rax, 1431655766	 # tmp182, tmp181,
	shr	rax, 32	 # tmp182,
	mov	rdx, rax	 # tmp183, tmp182
	mov	eax, ecx	 # tmp184, _16
	sar	eax, 31	 # tmp184,
	sub	edx, eax	 # _17, tmp184
	mov	eax, edx	 # tmp185, _17
	add	eax, eax	 # tmp185
	add	eax, edx	 # tmp185, _17
	sub	ecx, eax	 # _16, tmp185
	mov	edx, ecx	 # _17, _16
 # src/game.c:117:         game.birdFrame = (game.birdFrame + 1) % 3;
	mov	DWORD PTR game[rip+92], edx	 # game.birdFrame, _17
.L28:
 # src/game.c:120:     if (game.gameOver || !game.started) return;
	mov	eax, DWORD PTR game[rip+60]	 # _18, game.gameOver
 # src/game.c:120:     if (game.gameOver || !game.started) return;
	test	eax, eax	 # _18
	jne	.L64	 #,
 # src/game.c:120:     if (game.gameOver || !game.started) return;
	mov	eax, DWORD PTR game[rip+64]	 # _19, game.started
 # src/game.c:120:     if (game.gameOver || !game.started) return;
	test	eax, eax	 # _19
	je	.L64	 #,
 # src/game.c:123:     game.bird.velocity += GRAVITY;
	movss	xmm1, DWORD PTR game[rip+4]	 # _20, game.bird.velocity
 # src/game.c:123:     game.bird.velocity += GRAVITY;
	movss	xmm0, DWORD PTR .LC9[rip]	 # tmp186,
	addss	xmm0, xmm1	 # _21, _20
	movss	DWORD PTR game[rip+4], xmm0	 # game.bird.velocity, _21
 # src/game.c:126:     if (game.bird.velocity > MAX_VELOCITY) {
	movss	xmm0, DWORD PTR game[rip+4]	 # _22, game.bird.velocity
 # src/game.c:126:     if (game.bird.velocity > MAX_VELOCITY) {
	comiss	xmm0, DWORD PTR .LC10[rip]	 # _22,
	jbe	.L32	 #,
 # src/game.c:127:         game.bird.velocity = MAX_VELOCITY;
	movss	xmm0, DWORD PTR .LC10[rip]	 # tmp187,
	movss	DWORD PTR game[rip+4], xmm0	 # game.bird.velocity, tmp187
.L32:
 # src/game.c:130:     game.bird.y += game.bird.velocity;
	movss	xmm1, DWORD PTR game[rip]	 # _23, game.bird.y
 # src/game.c:130:     game.bird.y += game.bird.velocity;
	movss	xmm0, DWORD PTR game[rip+4]	 # _24, game.bird.velocity
 # src/game.c:130:     game.bird.y += game.bird.velocity;
	addss	xmm0, xmm1	 # _25, _23
	movss	DWORD PTR game[rip], xmm0	 # game.bird.y, _25
 # src/game.c:133:     game.bird.rotation = game.bird.velocity * 3;
	movss	xmm1, DWORD PTR game[rip+4]	 # _26, game.bird.velocity
 # src/game.c:133:     game.bird.rotation = game.bird.velocity * 3;
	movss	xmm0, DWORD PTR .LC11[rip]	 # tmp188,
	mulss	xmm0, xmm1	 # _27, _26
 # src/game.c:133:     game.bird.rotation = game.bird.velocity * 3;
	movss	DWORD PTR game[rip+12], xmm0	 # game.bird.rotation, _27
 # src/game.c:134:     if (game.bird.rotation > 90) game.bird.rotation = 90;
	movss	xmm0, DWORD PTR game[rip+12]	 # _28, game.bird.rotation
 # src/game.c:134:     if (game.bird.rotation > 90) game.bird.rotation = 90;
	comiss	xmm0, DWORD PTR .LC12[rip]	 # _28,
	jbe	.L34	 #,
 # src/game.c:134:     if (game.bird.rotation > 90) game.bird.rotation = 90;
	movss	xmm0, DWORD PTR .LC12[rip]	 # tmp189,
	movss	DWORD PTR game[rip+12], xmm0	 # game.bird.rotation, tmp189
.L34:
 # src/game.c:135:     if (game.bird.rotation < -30) game.bird.rotation = -30;
	movss	xmm1, DWORD PTR game[rip+12]	 # _29, game.bird.rotation
 # src/game.c:135:     if (game.bird.rotation < -30) game.bird.rotation = -30;
	movss	xmm0, DWORD PTR .LC13[rip]	 # tmp190,
	comiss	xmm0, xmm1	 # tmp190, _29
	jbe	.L36	 #,
 # src/game.c:135:     if (game.bird.rotation < -30) game.bird.rotation = -30;
	movss	xmm0, DWORD PTR .LC13[rip]	 # tmp191,
	movss	DWORD PTR game[rip+12], xmm0	 # game.bird.rotation, tmp191
.L36:
 # src/game.c:138:     game.pipeSpeed = BASE_PIPE_SPEED + (game.score / 5) * 0.5f;
	mov	eax, DWORD PTR game[rip+52]	 # _30, game.score
 # src/game.c:138:     game.pipeSpeed = BASE_PIPE_SPEED + (game.score / 5) * 0.5f;
	movsx	rdx, eax	 # tmp192, _30
	imul	rdx, rdx, 1717986919	 # tmp193, tmp192,
	shr	rdx, 32	 # tmp194,
	sar	edx	 # tmp195
	sar	eax, 31	 # tmp196,
	sub	edx, eax	 # _31, tmp196
 # src/game.c:138:     game.pipeSpeed = BASE_PIPE_SPEED + (game.score / 5) * 0.5f;
	pxor	xmm1, xmm1	 # _32
	cvtsi2ss	xmm1, edx	 # _32, _31
	movss	xmm0, DWORD PTR .LC14[rip]	 # tmp197,
	mulss	xmm1, xmm0	 # _33, tmp197
 # src/game.c:138:     game.pipeSpeed = BASE_PIPE_SPEED + (game.score / 5) * 0.5f;
	movss	xmm0, DWORD PTR .LC2[rip]	 # tmp198,
	addss	xmm0, xmm1	 # _34, _33
 # src/game.c:138:     game.pipeSpeed = BASE_PIPE_SPEED + (game.score / 5) * 0.5f;
	movss	DWORD PTR game[rip+68], xmm0	 # game.pipeSpeed, _34
 # src/game.c:139:     if (game.pipeSpeed > BASE_PIPE_SPEED + 3) game.pipeSpeed = BASE_PIPE_SPEED + 3;
	movss	xmm0, DWORD PTR game[rip+68]	 # _35, game.pipeSpeed
 # src/game.c:139:     if (game.pipeSpeed > BASE_PIPE_SPEED + 3) game.pipeSpeed = BASE_PIPE_SPEED + 3;
	comiss	xmm0, DWORD PTR .LC15[rip]	 # _35,
	jbe	.L38	 #,
 # src/game.c:139:     if (game.pipeSpeed > BASE_PIPE_SPEED + 3) game.pipeSpeed = BASE_PIPE_SPEED + 3;
	movss	xmm0, DWORD PTR .LC15[rip]	 # tmp199,
	movss	DWORD PTR game[rip+68], xmm0	 # game.pipeSpeed, tmp199
.L38:
 # src/game.c:142:     game.backgroundOffset -= game.pipeSpeed * 0.3f;
	movss	xmm0, DWORD PTR game[rip+76]	 # _36, game.backgroundOffset
 # src/game.c:142:     game.backgroundOffset -= game.pipeSpeed * 0.3f;
	movss	xmm2, DWORD PTR game[rip+68]	 # _37, game.pipeSpeed
 # src/game.c:142:     game.backgroundOffset -= game.pipeSpeed * 0.3f;
	movss	xmm1, DWORD PTR .LC7[rip]	 # tmp200,
	mulss	xmm1, xmm2	 # _38, _37
 # src/game.c:142:     game.backgroundOffset -= game.pipeSpeed * 0.3f;
	subss	xmm0, xmm1	 # _39, _38
	movss	DWORD PTR game[rip+76], xmm0	 # game.backgroundOffset, _39
 # src/game.c:143:     if (game.backgroundOffset < -WINDOW_WIDTH) game.backgroundOffset = 0;
	movss	xmm1, DWORD PTR game[rip+76]	 # _40, game.backgroundOffset
 # src/game.c:143:     if (game.backgroundOffset < -WINDOW_WIDTH) game.backgroundOffset = 0;
	movss	xmm0, DWORD PTR .LC8[rip]	 # tmp201,
	comiss	xmm0, xmm1	 # tmp201, _40
	jbe	.L40	 #,
 # src/game.c:143:     if (game.backgroundOffset < -WINDOW_WIDTH) game.backgroundOffset = 0;
	pxor	xmm0, xmm0	 # tmp202
	movss	DWORD PTR game[rip+76], xmm0	 # game.backgroundOffset, tmp202
.L40:
 # src/game.c:146:     int hitboxOffset = (BIRD_SIZE - BIRD_HITBOX_SIZE) / 2;
	mov	DWORD PTR -20[rbp], 6	 # hitboxOffset,
 # src/game.c:147:     if (game.bird.y + hitboxOffset > WINDOW_HEIGHT - GROUND_HEIGHT - BIRD_HITBOX_SIZE || game.bird.y + hitboxOffset < 0) {
	movss	xmm1, DWORD PTR game[rip]	 # _41, game.bird.y
 # src/game.c:147:     if (game.bird.y + hitboxOffset > WINDOW_HEIGHT - GROUND_HEIGHT - BIRD_HITBOX_SIZE || game.bird.y + hitboxOffset < 0) {
	pxor	xmm0, xmm0	 # _42
	cvtsi2ss	xmm0, DWORD PTR -20[rbp]	 # _42, hitboxOffset
	addss	xmm0, xmm1	 # _43, _41
 # src/game.c:147:     if (game.bird.y + hitboxOffset > WINDOW_HEIGHT - GROUND_HEIGHT - BIRD_HITBOX_SIZE || game.bird.y + hitboxOffset < 0) {
	comiss	xmm0, DWORD PTR .LC16[rip]	 # _43,
	ja	.L42	 #,
 # src/game.c:147:     if (game.bird.y + hitboxOffset > WINDOW_HEIGHT - GROUND_HEIGHT - BIRD_HITBOX_SIZE || game.bird.y + hitboxOffset < 0) {
	movss	xmm1, DWORD PTR game[rip]	 # _44, game.bird.y
 # src/game.c:147:     if (game.bird.y + hitboxOffset > WINDOW_HEIGHT - GROUND_HEIGHT - BIRD_HITBOX_SIZE || game.bird.y + hitboxOffset < 0) {
	pxor	xmm0, xmm0	 # _45
	cvtsi2ss	xmm0, DWORD PTR -20[rbp]	 # _45, hitboxOffset
	addss	xmm1, xmm0	 # _46, _45
 # src/game.c:147:     if (game.bird.y + hitboxOffset > WINDOW_HEIGHT - GROUND_HEIGHT - BIRD_HITBOX_SIZE || game.bird.y + hitboxOffset < 0) {
	pxor	xmm0, xmm0	 # tmp203
	comiss	xmm0, xmm1	 # tmp203, _46
	jbe	.L43	 #,
.L42:
 # src/game.c:148:         game.gameOver = 1;
	mov	DWORD PTR game[rip+60], 1	 # game.gameOver,
 # src/game.c:149:         game.bird.alive = 0;
	mov	DWORD PTR game[rip+8], 0	 # game.bird.alive,
 # src/game.c:150:         game.screenShake = 15;
	mov	DWORD PTR game[rip+84], 15	 # game.screenShake,
 # src/game.c:151:         game.flashEffect = 10;
	mov	DWORD PTR game[rip+88], 10	 # game.flashEffect,
 # src/game.c:152:         SaveHighScore();
	call	_Z13SaveHighScorev	 #
 # src/game.c:153:         PlaySoundEffect(SOUND_HIT);
	lea	rax, .LC17[rip]	 # tmp204,
	mov	rcx, rax	 #, tmp204
	call	_Z15PlaySoundEffectPKc	 #
 # src/game.c:154:         PlaySoundEffect(SOUND_DIE);
	lea	rax, .LC18[rip]	 # tmp205,
	mov	rcx, rax	 #, tmp205
	call	_Z15PlaySoundEffectPKc	 #
 # src/game.c:157:         for (int i = 0; i < 15; i++) {
	mov	DWORD PTR -4[rbp], 0	 # i,
 # src/game.c:157:         for (int i = 0; i < 15; i++) {
	jmp	.L45	 #
.L46:
 # src/game.c:158:             AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 215, 0));
	movss	xmm1, DWORD PTR game[rip]	 # _47, game.bird.y
 # src/game.c:158:             AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 215, 0));
	movss	xmm0, DWORD PTR .LC19[rip]	 # tmp206,
	addss	xmm0, xmm1	 # _48, _47
	mov	r8d, 55295	 #,
	movaps	xmm1, xmm0	 #, _48
	mov	eax, DWORD PTR .LC20[rip]	 # tmp207,
	movd	xmm0, eax	 #, tmp207
	call	_Z11AddParticleffm	 #
 # src/game.c:159:             AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 140, 0));
	movss	xmm1, DWORD PTR game[rip]	 # _49, game.bird.y
 # src/game.c:159:             AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 140, 0));
	movss	xmm0, DWORD PTR .LC19[rip]	 # tmp208,
	addss	xmm0, xmm1	 # _50, _49
	mov	r8d, 36095	 #,
	movaps	xmm1, xmm0	 #, _50
	mov	eax, DWORD PTR .LC20[rip]	 # tmp209,
	movd	xmm0, eax	 #, tmp209
	call	_Z11AddParticleffm	 #
 # src/game.c:157:         for (int i = 0; i < 15; i++) {
	add	DWORD PTR -4[rbp], 1	 # i,
.L45:
 # src/game.c:157:         for (int i = 0; i < 15; i++) {
	cmp	DWORD PTR -4[rbp], 14	 # i,
	jle	.L46	 #,
.L43:
 # src/game.c:164:     for (int i = 0; i < 3; i++) {
	mov	DWORD PTR -8[rbp], 0	 # i,
 # src/game.c:164:     for (int i = 0; i < 3; i++) {
	jmp	.L47	 #
.L57:
 # src/game.c:165:         game.pipes[i].x -= (int)game.pipeSpeed;
	mov	eax, DWORD PTR -8[rbp]	 # tmp211, i
	movsx	rdx, eax	 # tmp210, tmp211
	mov	rax, rdx	 # tmp213, tmp210
	add	rax, rax	 # tmp213
	add	rax, rdx	 # tmp213, tmp210
	sal	rax, 2	 # tmp214,
	mov	rdx, rax	 # tmp212, tmp213
	lea	rax, game[rip+16]	 # tmp215,
	mov	edx, DWORD PTR [rdx+rax]	 # _51, game.pipes[i_82].x
 # src/game.c:165:         game.pipes[i].x -= (int)game.pipeSpeed;
	movss	xmm0, DWORD PTR game[rip+68]	 # _52, game.pipeSpeed
 # src/game.c:165:         game.pipes[i].x -= (int)game.pipeSpeed;
	cvttss2si	eax, xmm0	 # _53, _52
 # src/game.c:165:         game.pipes[i].x -= (int)game.pipeSpeed;
	mov	ecx, edx	 # _51, _51
	sub	ecx, eax	 # _51, _53
	mov	eax, DWORD PTR -8[rbp]	 # tmp217, i
	movsx	rdx, eax	 # tmp216, tmp217
	mov	rax, rdx	 # tmp219, tmp216
	add	rax, rax	 # tmp219
	add	rax, rdx	 # tmp219, tmp216
	sal	rax, 2	 # tmp220,
	mov	rdx, rax	 # tmp218, tmp219
	lea	rax, game[rip+16]	 # tmp221,
	mov	DWORD PTR [rdx+rax], ecx	 # game.pipes[i_82].x, _54
 # src/game.c:168:         if (game.pipes[i].x < -PIPE_WIDTH) {
	mov	eax, DWORD PTR -8[rbp]	 # tmp223, i
	movsx	rdx, eax	 # tmp222, tmp223
	mov	rax, rdx	 # tmp225, tmp222
	add	rax, rax	 # tmp225
	add	rax, rdx	 # tmp225, tmp222
	sal	rax, 2	 # tmp226,
	mov	rdx, rax	 # tmp224, tmp225
	lea	rax, game[rip+16]	 # tmp227,
	mov	eax, DWORD PTR [rdx+rax]	 # _55, game.pipes[i_82].x
 # src/game.c:168:         if (game.pipes[i].x < -PIPE_WIDTH) {
	cmp	eax, -104	 # _55,
	jge	.L48	 #,
 # src/game.c:169:             game.pipes[i].x = WINDOW_WIDTH;
	mov	eax, DWORD PTR -8[rbp]	 # tmp229, i
	movsx	rdx, eax	 # tmp228, tmp229
	mov	rax, rdx	 # tmp231, tmp228
	add	rax, rax	 # tmp231
	add	rax, rdx	 # tmp231, tmp228
	sal	rax, 2	 # tmp232,
	mov	rdx, rax	 # tmp230, tmp231
	lea	rax, game[rip+16]	 # tmp233,
	mov	DWORD PTR [rdx+rax], 1280	 # game.pipes[i_82].x,
 # src/game.c:171:             game.pipes[i].topHeight = 100 + rand() % 208;
	call	rand	 #
 # src/game.c:171:             game.pipes[i].topHeight = 100 + rand() % 208;
	movsx	rdx, eax	 # tmp234, _56
	imul	rdx, rdx, 1321528399	 # tmp235, tmp234,
	shr	rdx, 32	 # tmp236,
	sar	edx, 6	 # tmp237,
	mov	ecx, eax	 # tmp238, _56
	sar	ecx, 31	 # tmp238,
	sub	edx, ecx	 # _57, tmp238
	imul	ecx, edx, 208	 # tmp239, _57,
	sub	eax, ecx	 # _56, tmp239
	mov	edx, eax	 # _57, _56
 # src/game.c:171:             game.pipes[i].topHeight = 100 + rand() % 208;
	lea	ecx, 100[rdx]	 # _58,
 # src/game.c:171:             game.pipes[i].topHeight = 100 + rand() % 208;
	mov	eax, DWORD PTR -8[rbp]	 # tmp241, i
	movsx	rdx, eax	 # tmp240, tmp241
	mov	rax, rdx	 # tmp243, tmp240
	add	rax, rax	 # tmp243
	add	rax, rdx	 # tmp243, tmp240
	sal	rax, 2	 # tmp244,
	mov	rdx, rax	 # tmp242, tmp243
	lea	rax, game[rip+20]	 # tmp245,
	mov	DWORD PTR [rdx+rax], ecx	 # game.pipes[i_82].topHeight, _58
 # src/game.c:172:             game.pipes[i].scored = 0;
	mov	eax, DWORD PTR -8[rbp]	 # tmp247, i
	movsx	rdx, eax	 # tmp246, tmp247
	mov	rax, rdx	 # tmp249, tmp246
	add	rax, rax	 # tmp249
	add	rax, rdx	 # tmp249, tmp246
	sal	rax, 2	 # tmp250,
	mov	rdx, rax	 # tmp248, tmp249
	lea	rax, game[rip+24]	 # tmp251,
	mov	DWORD PTR [rdx+rax], 0	 # game.pipes[i_82].scored,
.L48:
 # src/game.c:176:         if (!game.pipes[i].scored && game.pipes[i].x + PIPE_WIDTH < BIRD_X) {
	mov	eax, DWORD PTR -8[rbp]	 # tmp253, i
	movsx	rdx, eax	 # tmp252, tmp253
	mov	rax, rdx	 # tmp255, tmp252
	add	rax, rax	 # tmp255
	add	rax, rdx	 # tmp255, tmp252
	sal	rax, 2	 # tmp256,
	mov	rdx, rax	 # tmp254, tmp255
	lea	rax, game[rip+24]	 # tmp257,
	mov	eax, DWORD PTR [rdx+rax]	 # _59, game.pipes[i_82].scored
 # src/game.c:176:         if (!game.pipes[i].scored && game.pipes[i].x + PIPE_WIDTH < BIRD_X) {
	test	eax, eax	 # _59
	jne	.L49	 #,
 # src/game.c:176:         if (!game.pipes[i].scored && game.pipes[i].x + PIPE_WIDTH < BIRD_X) {
	mov	eax, DWORD PTR -8[rbp]	 # tmp259, i
	movsx	rdx, eax	 # tmp258, tmp259
	mov	rax, rdx	 # tmp261, tmp258
	add	rax, rax	 # tmp261
	add	rax, rdx	 # tmp261, tmp258
	sal	rax, 2	 # tmp262,
	mov	rdx, rax	 # tmp260, tmp261
	lea	rax, game[rip+16]	 # tmp263,
	mov	eax, DWORD PTR [rdx+rax]	 # _60, game.pipes[i_82].x
 # src/game.c:176:         if (!game.pipes[i].scored && game.pipes[i].x + PIPE_WIDTH < BIRD_X) {
	cmp	eax, 245	 # _60,
	jg	.L49	 #,
 # src/game.c:177:             game.score++;
	mov	eax, DWORD PTR game[rip+52]	 # _61, game.score
 # src/game.c:177:             game.score++;
	add	eax, 1	 # _62,
	mov	DWORD PTR game[rip+52], eax	 # game.score, _62
 # src/game.c:178:             game.pipes[i].scored = 1;
	mov	eax, DWORD PTR -8[rbp]	 # tmp265, i
	movsx	rdx, eax	 # tmp264, tmp265
	mov	rax, rdx	 # tmp267, tmp264
	add	rax, rax	 # tmp267
	add	rax, rdx	 # tmp267, tmp264
	sal	rax, 2	 # tmp268,
	mov	rdx, rax	 # tmp266, tmp267
	lea	rax, game[rip+24]	 # tmp269,
	mov	DWORD PTR [rdx+rax], 1	 # game.pipes[i_82].scored,
 # src/game.c:179:             PlaySoundEffect(SOUND_POINT);
	lea	rax, .LC21[rip]	 # tmp270,
	mov	rcx, rax	 #, tmp270
	call	_Z15PlaySoundEffectPKc	 #
 # src/game.c:182:             for (int j = 0; j < 5; j++) {
	mov	DWORD PTR -12[rbp], 0	 # j,
 # src/game.c:182:             for (int j = 0; j < 5; j++) {
	jmp	.L50	 #
.L51:
 # src/game.c:183:                 AddParticle(BIRD_X + BIRD_SIZE, game.bird.y + BIRD_SIZE/2, RGB(255, 255, 0));
	movss	xmm1, DWORD PTR game[rip]	 # _63, game.bird.y
 # src/game.c:183:                 AddParticle(BIRD_X + BIRD_SIZE, game.bird.y + BIRD_SIZE/2, RGB(255, 255, 0));
	movss	xmm0, DWORD PTR .LC19[rip]	 # tmp271,
	addss	xmm0, xmm1	 # _64, _63
	mov	r8d, 65535	 #,
	movaps	xmm1, xmm0	 #, _64
	mov	eax, DWORD PTR .LC22[rip]	 # tmp272,
	movd	xmm0, eax	 #, tmp272
	call	_Z11AddParticleffm	 #
 # src/game.c:182:             for (int j = 0; j < 5; j++) {
	add	DWORD PTR -12[rbp], 1	 # j,
.L50:
 # src/game.c:182:             for (int j = 0; j < 5; j++) {
	cmp	DWORD PTR -12[rbp], 4	 # j,
	jle	.L51	 #,
.L49:
 # src/game.c:188:         int hitboxOffset = (BIRD_SIZE - BIRD_HITBOX_SIZE) / 2;
	mov	DWORD PTR -24[rbp], 6	 # hitboxOffset,
 # src/game.c:189:         float birdHitboxY = game.bird.y + hitboxOffset;
	movss	xmm1, DWORD PTR game[rip]	 # _65, game.bird.y
 # src/game.c:189:         float birdHitboxY = game.bird.y + hitboxOffset;
	pxor	xmm0, xmm0	 # _66
	cvtsi2ss	xmm0, DWORD PTR -24[rbp]	 # _66, hitboxOffset
 # src/game.c:189:         float birdHitboxY = game.bird.y + hitboxOffset;
	addss	xmm0, xmm1	 # birdHitboxY_146, _65
	movss	DWORD PTR -28[rbp], xmm0	 # birdHitboxY, birdHitboxY_146
 # src/game.c:190:         int birdHitboxX = BIRD_X + hitboxOffset;
	mov	eax, DWORD PTR -24[rbp]	 # tmp277, hitboxOffset
	add	eax, 350	 # birdHitboxX_147,
	mov	DWORD PTR -32[rbp], eax	 # birdHitboxX, birdHitboxX_147
 # src/game.c:192:         if (birdHitboxY < game.pipes[i].topHeight || 
	mov	eax, DWORD PTR -8[rbp]	 # tmp279, i
	movsx	rdx, eax	 # tmp278, tmp279
	mov	rax, rdx	 # tmp281, tmp278
	add	rax, rax	 # tmp281
	add	rax, rdx	 # tmp281, tmp278
	sal	rax, 2	 # tmp282,
	mov	rdx, rax	 # tmp280, tmp281
	lea	rax, game[rip+20]	 # tmp283,
	mov	eax, DWORD PTR [rdx+rax]	 # _67, game.pipes[i_82].topHeight
 # src/game.c:192:         if (birdHitboxY < game.pipes[i].topHeight || 
	pxor	xmm0, xmm0	 # _68
	cvtsi2ss	xmm0, eax	 # _68, _67
 # src/game.c:192:         if (birdHitboxY < game.pipes[i].topHeight || 
	comiss	xmm0, DWORD PTR -28[rbp]	 # _68, birdHitboxY
	ja	.L52	 #,
 # src/game.c:193:             birdHitboxY + BIRD_HITBOX_SIZE > game.pipes[i].topHeight + PIPE_GAP) {
	movss	xmm1, DWORD PTR -28[rbp]	 # tmp284, birdHitboxY
	movss	xmm0, DWORD PTR .LC23[rip]	 # tmp285,
	addss	xmm0, xmm1	 # _69, tmp284
 # src/game.c:193:             birdHitboxY + BIRD_HITBOX_SIZE > game.pipes[i].topHeight + PIPE_GAP) {
	mov	eax, DWORD PTR -8[rbp]	 # tmp287, i
	movsx	rdx, eax	 # tmp286, tmp287
	mov	rax, rdx	 # tmp289, tmp286
	add	rax, rax	 # tmp289
	add	rax, rdx	 # tmp289, tmp286
	sal	rax, 2	 # tmp290,
	mov	rdx, rax	 # tmp288, tmp289
	lea	rax, game[rip+20]	 # tmp291,
	mov	eax, DWORD PTR [rdx+rax]	 # _70, game.pipes[i_82].topHeight
 # src/game.c:193:             birdHitboxY + BIRD_HITBOX_SIZE > game.pipes[i].topHeight + PIPE_GAP) {
	add	eax, 200	 # _71,
 # src/game.c:193:             birdHitboxY + BIRD_HITBOX_SIZE > game.pipes[i].topHeight + PIPE_GAP) {
	pxor	xmm1, xmm1	 # _72
	cvtsi2ss	xmm1, eax	 # _72, _71
 # src/game.c:192:         if (birdHitboxY < game.pipes[i].topHeight || 
	comiss	xmm0, xmm1	 # _69, _72
	jbe	.L53	 #,
.L52:
 # src/game.c:194:             if (birdHitboxX + BIRD_HITBOX_SIZE > game.pipes[i].x && 
	mov	eax, DWORD PTR -32[rbp]	 # tmp292, birdHitboxX
	lea	ecx, 47[rax]	 # _73,
 # src/game.c:194:             if (birdHitboxX + BIRD_HITBOX_SIZE > game.pipes[i].x && 
	mov	eax, DWORD PTR -8[rbp]	 # tmp294, i
	movsx	rdx, eax	 # tmp293, tmp294
	mov	rax, rdx	 # tmp296, tmp293
	add	rax, rax	 # tmp296
	add	rax, rdx	 # tmp296, tmp293
	sal	rax, 2	 # tmp297,
	mov	rdx, rax	 # tmp295, tmp296
	lea	rax, game[rip+16]	 # tmp298,
	mov	eax, DWORD PTR [rdx+rax]	 # _74, game.pipes[i_82].x
 # src/game.c:194:             if (birdHitboxX + BIRD_HITBOX_SIZE > game.pipes[i].x && 
	cmp	ecx, eax	 # _73, _74
	jl	.L53	 #,
 # src/game.c:195:                 birdHitboxX < game.pipes[i].x + PIPE_WIDTH) {
	mov	eax, DWORD PTR -8[rbp]	 # tmp300, i
	movsx	rdx, eax	 # tmp299, tmp300
	mov	rax, rdx	 # tmp302, tmp299
	add	rax, rax	 # tmp302
	add	rax, rdx	 # tmp302, tmp299
	sal	rax, 2	 # tmp303,
	mov	rdx, rax	 # tmp301, tmp302
	lea	rax, game[rip+16]	 # tmp304,
	mov	eax, DWORD PTR [rdx+rax]	 # _75, game.pipes[i_82].x
 # src/game.c:195:                 birdHitboxX < game.pipes[i].x + PIPE_WIDTH) {
	add	eax, 103	 # _76,
 # src/game.c:194:             if (birdHitboxX + BIRD_HITBOX_SIZE > game.pipes[i].x && 
	cmp	DWORD PTR -32[rbp], eax	 # birdHitboxX, _76
	jg	.L53	 #,
 # src/game.c:196:                 game.gameOver = 1;
	mov	DWORD PTR game[rip+60], 1	 # game.gameOver,
 # src/game.c:197:                 game.bird.alive = 0;
	mov	DWORD PTR game[rip+8], 0	 # game.bird.alive,
 # src/game.c:198:                 game.screenShake = 15;
	mov	DWORD PTR game[rip+84], 15	 # game.screenShake,
 # src/game.c:199:                 game.flashEffect = 10;
	mov	DWORD PTR game[rip+88], 10	 # game.flashEffect,
 # src/game.c:200:                 SaveHighScore();
	call	_Z13SaveHighScorev	 #
 # src/game.c:201:                 PlaySoundEffect(SOUND_HIT);
	lea	rax, .LC17[rip]	 # tmp305,
	mov	rcx, rax	 #, tmp305
	call	_Z15PlaySoundEffectPKc	 #
 # src/game.c:202:                 PlaySoundEffect(SOUND_DIE);
	lea	rax, .LC18[rip]	 # tmp306,
	mov	rcx, rax	 #, tmp306
	call	_Z15PlaySoundEffectPKc	 #
 # src/game.c:205:                 for (int j = 0; j < 20; j++) {
	mov	DWORD PTR -16[rbp], 0	 # j,
 # src/game.c:205:                 for (int j = 0; j < 20; j++) {
	jmp	.L55	 #
.L56:
 # src/game.c:206:                     AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 0, 0));
	movss	xmm1, DWORD PTR game[rip]	 # _77, game.bird.y
 # src/game.c:206:                     AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 0, 0));
	movss	xmm0, DWORD PTR .LC19[rip]	 # tmp307,
	addss	xmm0, xmm1	 # _78, _77
	mov	r8d, 255	 #,
	movaps	xmm1, xmm0	 #, _78
	mov	eax, DWORD PTR .LC20[rip]	 # tmp308,
	movd	xmm0, eax	 #, tmp308
	call	_Z11AddParticleffm	 #
 # src/game.c:207:                     AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 215, 0));
	movss	xmm1, DWORD PTR game[rip]	 # _79, game.bird.y
 # src/game.c:207:                     AddParticle(BIRD_X + BIRD_SIZE/2, game.bird.y + BIRD_SIZE/2, RGB(255, 215, 0));
	movss	xmm0, DWORD PTR .LC19[rip]	 # tmp309,
	addss	xmm0, xmm1	 # _80, _79
	mov	r8d, 55295	 #,
	movaps	xmm1, xmm0	 #, _80
	mov	eax, DWORD PTR .LC20[rip]	 # tmp310,
	movd	xmm0, eax	 #, tmp310
	call	_Z11AddParticleffm	 #
 # src/game.c:205:                 for (int j = 0; j < 20; j++) {
	add	DWORD PTR -16[rbp], 1	 # j,
.L55:
 # src/game.c:205:                 for (int j = 0; j < 20; j++) {
	cmp	DWORD PTR -16[rbp], 19	 # j,
	jle	.L56	 #,
.L53:
 # src/game.c:164:     for (int i = 0; i < 3; i++) {
	add	DWORD PTR -8[rbp], 1	 # i,
.L47:
 # src/game.c:164:     for (int i = 0; i < 3; i++) {
	cmp	DWORD PTR -8[rbp], 2	 # i,
	jle	.L57	 #,
	jmp	.L23	 #
.L64:
 # src/game.c:120:     if (game.gameOver || !game.started) return;
	nop	
.L23:
 # src/game.c:212: }
	add	rsp, 64	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
	.align 4
.LC0:
	.long	1134231552
	.align 4
.LC2:
	.long	1082130432
	.align 4
.LC6:
	.long	1092616192
	.align 4
.LC7:
	.long	1050253722
	.align 4
.LC8:
	.long	-996147200
	.align 4
.LC9:
	.long	1061997773
	.align 4
.LC10:
	.long	1097859072
	.align 4
.LC11:
	.long	1077936128
	.align 4
.LC12:
	.long	1119092736
	.align 4
.LC13:
	.long	-1041235968
	.align 4
.LC14:
	.long	1056964608
	.align 4
.LC15:
	.long	1088421888
	.align 4
.LC16:
	.long	1141637120
	.align 4
.LC19:
	.long	1106247680
	.align 4
.LC20:
	.long	1136525312
	.align 4
.LC22:
	.long	1137508352
	.align 4
.LC23:
	.long	1111490560
	.ident	"GCC: (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) 15.2.0"
	.def	rand;	.scl	2;	.type	32;	.endef
	.def	fopen;	.scl	2;	.type	32;	.endef
	.def	fread;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
	.def	fwrite;	.scl	2;	.type	32;	.endef
	.def	_Z15PlaySoundEffectPKc;	.scl	2;	.type	32;	.endef
