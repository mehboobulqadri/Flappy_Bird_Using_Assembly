	.file	"main.c"
	.intel_syntax noprefix
 # GNU C++17 (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=x86-64
	.text
	.section .rdata,"dr"
	.align 4
_ZN7GdiplusL15FlatnessDefaultE:
	.long	1048576000
	.align 4
_ZN7GdiplusL25GDIP_EMFPLUSFLAGS_DISPLAYE:
	.long	1
.LC0:
	.ascii "swoosh\0"
.LC2:
	.ascii "wing\0"
	.text
	.globl	_Z7WndProcP6HWND__jyx
	.def	_Z7WndProcP6HWND__jyx;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z7WndProcP6HWND__jyx
_Z7WndProcP6HWND__jyx:
.LFB8677:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 112	 #,
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # hwnd, hwnd
	mov	DWORD PTR 24[rbp], edx	 # msg, msg
	mov	QWORD PTR 32[rbp], r8	 # wParam, wParam
	mov	QWORD PTR 40[rbp], r9	 # lParam, lParam
 # src/main.c:10:     switch (msg) {
	cmp	DWORD PTR 24[rbp], 275	 # msg,
	je	.L2	 #,
	cmp	DWORD PTR 24[rbp], 275	 # msg,
	ja	.L3	 #,
	cmp	DWORD PTR 24[rbp], 256	 # msg,
	je	.L4	 #,
	cmp	DWORD PTR 24[rbp], 256	 # msg,
	ja	.L3	 #,
	cmp	DWORD PTR 24[rbp], 15	 # msg,
	je	.L5	 #,
	cmp	DWORD PTR 24[rbp], 15	 # msg,
	ja	.L3	 #,
	cmp	DWORD PTR 24[rbp], 1	 # msg,
	je	.L6	 #,
	cmp	DWORD PTR 24[rbp], 2	 # msg,
	je	.L7	 #,
	jmp	.L3	 #
.L6:
 # src/main.c:13:             InitGraphics(hwnd);
	mov	rax, QWORD PTR 16[rbp]	 # tmp106, hwnd
	mov	rcx, rax	 #, tmp106
	call	_Z12InitGraphicsP6HWND__	 #
 # src/main.c:16:             InitAudio();
	call	_Z9InitAudiov	 #
 # src/main.c:19:             srand(time(NULL));
	mov	ecx, 0	 #,
	call	_time64	 #
 # src/main.c:19:             srand(time(NULL));
	mov	ecx, eax	 #, _2
	call	srand	 #
 # src/main.c:20:             InitGame();
	call	_Z8InitGamev	 #
 # src/main.c:23:             SetTimer(hwnd, 1, 16, NULL);
	mov	rax, QWORD PTR 16[rbp]	 # tmp107, hwnd
	mov	r9d, 0	 #,
	mov	r8d, 16	 #,
	mov	edx, 1	 #,
	mov	rcx, rax	 #, tmp107
	mov	rax, QWORD PTR __imp_SetTimer[rip]	 # tmp108,
	call	rax	 # tmp108
 # src/main.c:24:             break;
	jmp	.L8	 #
.L2:
 # src/main.c:28:             UpdateGame();
	call	_Z10UpdateGamev	 #
 # src/main.c:29:             InvalidateRect(hwnd, NULL, FALSE);
	mov	rax, QWORD PTR 16[rbp]	 # tmp109, hwnd
	mov	r8d, 0	 #,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp109
	mov	rax, QWORD PTR __imp_InvalidateRect[rip]	 # tmp110,
	call	rax	 # tmp110
 # src/main.c:30:             break;
	jmp	.L8	 #
.L5:
 # src/main.c:35:             HDC hdc = BeginPaint(hwnd, &ps);
	lea	rdx, -80[rbp]	 # tmp111,
	mov	rax, QWORD PTR 16[rbp]	 # tmp112, hwnd
	mov	rcx, rax	 #, tmp112
	mov	rax, QWORD PTR __imp_BeginPaint[rip]	 # tmp113,
	call	rax	 # tmp113
 # src/main.c:35:             HDC hdc = BeginPaint(hwnd, &ps);
	mov	QWORD PTR -8[rbp], rax	 # hdc, _27
 # src/main.c:36:             DrawGame(hdc);
	mov	rax, QWORD PTR -8[rbp]	 # tmp114, hdc
	mov	rcx, rax	 #, tmp114
	call	_Z8DrawGameP5HDC__	 #
 # src/main.c:37:             EndPaint(hwnd, &ps);
	lea	rdx, -80[rbp]	 # tmp115,
	mov	rax, QWORD PTR 16[rbp]	 # tmp116, hwnd
	mov	rcx, rax	 #, tmp116
	mov	rax, QWORD PTR __imp_EndPaint[rip]	 # tmp117,
	call	rax	 # tmp117
 # src/main.c:38:             break;
	jmp	.L8	 #
.L4:
 # src/main.c:42:             switch (wParam) {
	cmp	QWORD PTR 32[rbp], 114	 # wParam,
	je	.L9	 #,
	cmp	QWORD PTR 32[rbp], 114	 # wParam,
	ja	.L16	 #,
	cmp	QWORD PTR 32[rbp], 82	 # wParam,
	je	.L9	 #,
	cmp	QWORD PTR 32[rbp], 82	 # wParam,
	ja	.L16	 #,
	cmp	QWORD PTR 32[rbp], 27	 # wParam,
	je	.L11	 #,
	cmp	QWORD PTR 32[rbp], 32	 # wParam,
	jne	.L16	 #,
 # src/main.c:44:                     if (!game.started) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp118,
	mov	eax, DWORD PTR 64[rax]	 # _3, game.started
 # src/main.c:44:                     if (!game.started) {
	test	eax, eax	 # _3
	jne	.L12	 #,
 # src/main.c:45:                         game.started = 1;
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp119,
	mov	DWORD PTR 64[rax], 1	 # game.started,
 # src/main.c:46:                         PlaySoundEffect(SOUND_SWOOSH);
	lea	rax, .LC0[rip]	 # tmp120,
	mov	rcx, rax	 #, tmp120
	call	_Z15PlaySoundEffectPKc	 #
.L12:
 # src/main.c:48:                     if (game.bird.alive) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp121,
	mov	eax, DWORD PTR 8[rax]	 # _4, game.bird.alive
 # src/main.c:48:                     if (game.bird.alive) {
	test	eax, eax	 # _4
	je	.L17	 #,
 # src/main.c:49:                         game.bird.velocity = JUMP_STRENGTH;
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp122,
	movss	xmm0, DWORD PTR .LC1[rip]	 # tmp123,
	movss	DWORD PTR 4[rax], xmm0	 # game.bird.velocity, tmp123
 # src/main.c:50:                         PlaySoundEffect(SOUND_WING);
	lea	rax, .LC2[rip]	 # tmp124,
	mov	rcx, rax	 #, tmp124
	call	_Z15PlaySoundEffectPKc	 #
 # src/main.c:52:                     break;
	jmp	.L17	 #
.L9:
 # src/main.c:56:                     if (game.gameOver) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp125,
	mov	eax, DWORD PTR 60[rax]	 # _5, game.gameOver
 # src/main.c:56:                     if (game.gameOver) {
	test	eax, eax	 # _5
	je	.L18	 #,
 # src/main.c:57:                         InitGame();
	call	_Z8InitGamev	 #
 # src/main.c:59:                     break;
	jmp	.L18	 #
.L11:
 # src/main.c:62:                     PostQuitMessage(0);
	mov	ecx, 0	 #,
	mov	rax, QWORD PTR __imp_PostQuitMessage[rip]	 # tmp126,
	call	rax	 # tmp126
 # src/main.c:63:                     break;
	jmp	.L10	 #
.L17:
 # src/main.c:52:                     break;
	nop	
	jmp	.L16	 #
.L18:
 # src/main.c:59:                     break;
	nop	
.L10:
 # src/main.c:65:             break;
	jmp	.L16	 #
.L7:
 # src/main.c:70:             KillTimer(hwnd, 1);
	mov	rax, QWORD PTR 16[rbp]	 # tmp127, hwnd
	mov	edx, 1	 #,
	mov	rcx, rax	 #, tmp127
	mov	rax, QWORD PTR __imp_KillTimer[rip]	 # tmp128,
	call	rax	 # tmp128
 # src/main.c:71:             CleanupAudio();
	call	_Z12CleanupAudiov	 #
 # src/main.c:72:             CleanupGraphics();
	call	_Z15CleanupGraphicsv	 #
 # src/main.c:73:             PostQuitMessage(0);
	mov	ecx, 0	 #,
	mov	rax, QWORD PTR __imp_PostQuitMessage[rip]	 # tmp129,
	call	rax	 # tmp129
 # src/main.c:74:             break;
	jmp	.L8	 #
.L3:
 # src/main.c:78:             return DefWindowProc(hwnd, msg, wParam, lParam);
	mov	r8, QWORD PTR 40[rbp]	 # tmp130, lParam
	mov	rcx, QWORD PTR 32[rbp]	 # tmp131, wParam
	mov	edx, DWORD PTR 24[rbp]	 # tmp132, msg
	mov	rax, QWORD PTR 16[rbp]	 # tmp133, hwnd
	mov	r9, r8	 #, tmp130
	mov	r8, rcx	 #, tmp131
	mov	rcx, rax	 #, tmp133
	mov	rax, QWORD PTR __imp_DefWindowProcA[rip]	 # tmp134,
	call	rax	 # tmp134
 # src/main.c:78:             return DefWindowProc(hwnd, msg, wParam, lParam);
	jmp	.L15	 #
.L16:
 # src/main.c:65:             break;
	nop	
.L8:
 # src/main.c:80:     return 0;
	mov	eax, 0	 # _46,
.L15:
 # src/main.c:81: }
	add	rsp, 112	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
.LC3:
	.ascii "FlappyBirdClass\0"
.LC4:
	.ascii "Error\0"
.LC5:
	.ascii "Window Registration Failed!\0"
	.align 8
.LC6:
	.ascii "Flappy Bird - Press SPACE to Jump\0"
.LC7:
	.ascii "Window Creation Failed!\0"
	.text
	.globl	WinMain
	.def	WinMain;	.scl	2;	.type	32;	.endef
	.seh_proc	WinMain
WinMain:
.LFB8678:
	push	rbp	 #
	.seh_pushreg	rbp
	sub	rsp, 256	 #,
	.seh_stackalloc	256
	lea	rbp, 128[rsp]	 #,
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 144[rbp], rcx	 # hInstance, hInstance
	mov	QWORD PTR 152[rbp], rdx	 # hPrevInstance, hPrevInstance
	mov	QWORD PTR 160[rbp], r8	 # lpCmdLine, lpCmdLine
	mov	DWORD PTR 168[rbp], r9d	 # nCmdShow, nCmdShow
 # src/main.c:87:     WNDCLASSEX wc = {0};
	pxor	xmm0, xmm0	 # tmp113
	movaps	XMMWORD PTR 32[rbp], xmm0	 # wc, tmp113
	movaps	XMMWORD PTR 48[rbp], xmm0	 # wc, tmp113
	movaps	XMMWORD PTR 64[rbp], xmm0	 # wc, tmp113
	movaps	XMMWORD PTR 80[rbp], xmm0	 # wc, tmp113
	movaps	XMMWORD PTR 96[rbp], xmm0	 # wc, tmp113
 # src/main.c:88:     wc.cbSize = sizeof(WNDCLASSEX);
	mov	DWORD PTR 32[rbp], 80	 # wc.cbSize,
 # src/main.c:89:     wc.lpfnWndProc = WndProc;
	lea	rax, _Z7WndProcP6HWND__jyx[rip]	 # tmp114,
	mov	QWORD PTR 40[rbp], rax	 # wc.lpfnWndProc, tmp114
 # src/main.c:90:     wc.hInstance = hInstance;
	mov	rax, QWORD PTR 144[rbp]	 # tmp115, hInstance
	mov	QWORD PTR 56[rbp], rax	 # wc.hInstance, tmp115
 # src/main.c:91:     wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	mov	edx, 32512	 #,
	mov	ecx, 0	 #,
	mov	rax, QWORD PTR __imp_LoadCursorA[rip]	 # tmp116,
	call	rax	 # tmp116
 # src/main.c:91:     wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	mov	QWORD PTR 72[rbp], rax	 # wc.hCursor, _1
 # src/main.c:92:     wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	mov	QWORD PTR 80[rbp], 6	 # wc.hbrBackground,
 # src/main.c:93:     wc.lpszClassName = "FlappyBirdClass";
	lea	rax, .LC3[rip]	 # tmp117,
	mov	QWORD PTR 96[rbp], rax	 # wc.lpszClassName, tmp117
 # src/main.c:95:     if (!RegisterClassEx(&wc)) {
	lea	rax, 32[rbp]	 # tmp118,
	mov	rcx, rax	 #, tmp118
	mov	rax, QWORD PTR __imp_RegisterClassExA[rip]	 # tmp119,
	call	rax	 # tmp119
 # src/main.c:95:     if (!RegisterClassEx(&wc)) {
	test	ax, ax	 # _2
	sete	al	 #, retval.0_28
 # src/main.c:95:     if (!RegisterClassEx(&wc)) {
	test	al, al	 # retval.0_28
	je	.L20	 #,
 # src/main.c:96:         MessageBox(NULL, "Window Registration Failed!", "Error", MB_ICONERROR);
	lea	rdx, .LC4[rip]	 # tmp120,
	lea	rax, .LC5[rip]	 # tmp121,
	mov	r9d, 16	 #,
	mov	r8, rdx	 #, tmp120
	mov	rdx, rax	 #, tmp121
	mov	ecx, 0	 #,
	mov	rax, QWORD PTR __imp_MessageBoxA[rip]	 # tmp122,
	call	rax	 # tmp122
 # src/main.c:97:         return 0;
	mov	eax, 0	 # _11,
	jmp	.L25	 #
.L20:
 # src/main.c:101:     RECT windowRect = {0, 0, WINDOW_WIDTH, WINDOW_HEIGHT};
	mov	DWORD PTR 16[rbp], 0	 # windowRect.left,
	mov	DWORD PTR 20[rbp], 0	 # windowRect.top,
	mov	DWORD PTR 24[rbp], 1280	 # windowRect.right,
	mov	DWORD PTR 28[rbp], 720	 # windowRect.bottom,
 # src/main.c:102:     AdjustWindowRect(&windowRect, WS_OVERLAPPEDWINDOW, FALSE);
	lea	rax, 16[rbp]	 # tmp123,
	mov	r8d, 0	 #,
	mov	edx, 13565952	 #,
	mov	rcx, rax	 #, tmp123
	mov	rax, QWORD PTR __imp_AdjustWindowRect[rip]	 # tmp124,
	call	rax	 # tmp124
 # src/main.c:112:         windowRect.bottom - windowRect.top,
	mov	edx, DWORD PTR 28[rbp]	 # _3, windowRect.bottom
 # src/main.c:112:         windowRect.bottom - windowRect.top,
	mov	eax, DWORD PTR 20[rbp]	 # _4, windowRect.top
 # src/main.c:112:         windowRect.bottom - windowRect.top,
	sub	edx, eax	 # _3, _4
	mov	r8d, edx	 # _5, _3
 # src/main.c:111:         windowRect.right - windowRect.left,
	mov	edx, DWORD PTR 24[rbp]	 # _6, windowRect.right
 # src/main.c:111:         windowRect.right - windowRect.left,
	mov	eax, DWORD PTR 16[rbp]	 # _7, windowRect.left
 # src/main.c:111:         windowRect.right - windowRect.left,
	mov	ecx, edx	 # _6, _6
	sub	ecx, eax	 # _6, _7
 # src/main.c:105:     HWND hwnd = CreateWindowEx(
	lea	r10, .LC6[rip]	 # tmp125,
	lea	rax, .LC3[rip]	 # tmp126,
	mov	QWORD PTR 88[rsp], 0	 #,
	mov	rdx, QWORD PTR 144[rbp]	 # tmp127, hInstance
	mov	QWORD PTR 80[rsp], rdx	 #, tmp127
	mov	QWORD PTR 72[rsp], 0	 #,
	mov	QWORD PTR 64[rsp], 0	 #,
	mov	DWORD PTR 56[rsp], r8d	 #, _5
	mov	DWORD PTR 48[rsp], ecx	 #, _8
	mov	DWORD PTR 40[rsp], -2147483648	 #,
	mov	DWORD PTR 32[rsp], -2147483648	 #,
	mov	r9d, 13238272	 #,
	mov	r8, r10	 #, tmp125
	mov	rdx, rax	 #, tmp126
	mov	ecx, 0	 #,
	mov	rax, QWORD PTR __imp_CreateWindowExA[rip]	 # tmp128,
	call	rax	 # tmp128
 # src/main.c:105:     HWND hwnd = CreateWindowEx(
	mov	QWORD PTR 120[rbp], rax	 # hwnd, _35
 # src/main.c:116:     if (hwnd == NULL) {
	cmp	QWORD PTR 120[rbp], 0	 # hwnd,
	jne	.L22	 #,
 # src/main.c:117:         MessageBox(NULL, "Window Creation Failed!", "Error", MB_ICONERROR);
	lea	rdx, .LC4[rip]	 # tmp129,
	lea	rax, .LC7[rip]	 # tmp130,
	mov	r9d, 16	 #,
	mov	r8, rdx	 #, tmp129
	mov	rdx, rax	 #, tmp130
	mov	ecx, 0	 #,
	mov	rax, QWORD PTR __imp_MessageBoxA[rip]	 # tmp131,
	call	rax	 # tmp131
 # src/main.c:118:         return 0;
	mov	eax, 0	 # _11,
	jmp	.L25	 #
.L22:
 # src/main.c:121:     ShowWindow(hwnd, nCmdShow);
	mov	edx, DWORD PTR 168[rbp]	 # tmp132, nCmdShow
	mov	rax, QWORD PTR 120[rbp]	 # tmp133, hwnd
	mov	rcx, rax	 #, tmp133
	mov	rax, QWORD PTR __imp_ShowWindow[rip]	 # tmp134,
	call	rax	 # tmp134
 # src/main.c:122:     UpdateWindow(hwnd);
	mov	rax, QWORD PTR 120[rbp]	 # tmp135, hwnd
	mov	rcx, rax	 #, tmp135
	mov	rax, QWORD PTR __imp_UpdateWindow[rip]	 # tmp136,
	call	rax	 # tmp136
 # src/main.c:125:     MSG msg = {0};
	pxor	xmm0, xmm0	 # tmp137
	movaps	XMMWORD PTR -32[rbp], xmm0	 # msg, tmp137
	movaps	XMMWORD PTR -16[rbp], xmm0	 # msg, tmp137
	movaps	XMMWORD PTR 0[rbp], xmm0	 # msg, tmp137
 # src/main.c:126:     while (GetMessage(&msg, NULL, 0, 0)) {
	jmp	.L23	 #
.L24:
 # src/main.c:127:         TranslateMessage(&msg);
	lea	rax, -32[rbp]	 # tmp138,
	mov	rcx, rax	 #, tmp138
	mov	rax, QWORD PTR __imp_TranslateMessage[rip]	 # tmp139,
	call	rax	 # tmp139
 # src/main.c:128:         DispatchMessage(&msg);
	lea	rax, -32[rbp]	 # tmp140,
	mov	rcx, rax	 #, tmp140
	mov	rax, QWORD PTR __imp_DispatchMessageA[rip]	 # tmp141,
	call	rax	 # tmp141
.L23:
 # src/main.c:126:     while (GetMessage(&msg, NULL, 0, 0)) {
	lea	rax, -32[rbp]	 # tmp142,
	mov	r9d, 0	 #,
	mov	r8d, 0	 #,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp142
	mov	rax, QWORD PTR __imp_GetMessageA[rip]	 # tmp143,
	call	rax	 # tmp143
 # src/main.c:126:     while (GetMessage(&msg, NULL, 0, 0)) {
	test	eax, eax	 # _9
	setne	al	 #, retval.1_43
	test	al, al	 # retval.1_43
	jne	.L24	 #,
 # src/main.c:131:     return msg.wParam;
	mov	rax, QWORD PTR -16[rbp]	 # _10, msg.wParam
.L25:
 # src/main.c:132: }
	add	rsp, 256	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
	.align 4
.LC1:
	.long	-1052770304
	.ident	"GCC: (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) 15.2.0"
	.def	_Z12InitGraphicsP6HWND__;	.scl	2;	.type	32;	.endef
	.def	_Z9InitAudiov;	.scl	2;	.type	32;	.endef
	.def	srand;	.scl	2;	.type	32;	.endef
	.def	_Z8InitGamev;	.scl	2;	.type	32;	.endef
	.def	_Z10UpdateGamev;	.scl	2;	.type	32;	.endef
	.def	_Z8DrawGameP5HDC__;	.scl	2;	.type	32;	.endef
	.def	_Z15PlaySoundEffectPKc;	.scl	2;	.type	32;	.endef
	.def	_Z12CleanupAudiov;	.scl	2;	.type	32;	.endef
	.def	_Z15CleanupGraphicsv;	.scl	2;	.type	32;	.endef
	.section	.rdata$.refptr.game, "dr"
	.p2align	3, 0
	.globl	.refptr.game
	.linkonce	discard
.refptr.game:
	.quad	game
