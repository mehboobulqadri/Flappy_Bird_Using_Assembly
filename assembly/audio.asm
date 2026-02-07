	.file	"audio.c"
	.intel_syntax noprefix
 # GNU C++17 (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=x86-64
	.text
	.data
	.align 4
_ZL12audioEnabled:
	.long	1
	.text
	.globl	_Z9InitAudiov
	.def	_Z9InitAudiov;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9InitAudiov
_Z9InitAudiov:
.LFB6484:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
 # src/audio.c:11:     UINT numDevices = waveOutGetNumDevs();
	mov	rax, QWORD PTR __imp_waveOutGetNumDevs[rip]	 # tmp99,
	call	rax	 # tmp99
 # src/audio.c:11:     UINT numDevices = waveOutGetNumDevs();
	mov	DWORD PTR -4[rbp], eax	 # numDevices, _4
 # src/audio.c:12:     if (numDevices == 0) {
	cmp	DWORD PTR -4[rbp], 0	 # numDevices,
	jne	.L2	 #,
 # src/audio.c:13:         audioEnabled = FALSE;
	mov	DWORD PTR _ZL12audioEnabled[rip], 0	 # audioEnabled,
 # src/audio.c:14:         return;
	jmp	.L1	 #
.L2:
 # src/audio.c:16:     audioEnabled = TRUE;
	mov	DWORD PTR _ZL12audioEnabled[rip], 1	 # audioEnabled,
.L1:
 # src/audio.c:17: }
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.globl	_Z12CleanupAudiov
	.def	_Z12CleanupAudiov;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z12CleanupAudiov
_Z12CleanupAudiov:
.LFB6485:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
 # src/audio.c:22: }
	nop	
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
.LC0:
	.ascii "assets\\audio\\%s.wav\0"
	.text
	.globl	_Z15PlaySoundEffectPKc
	.def	_Z15PlaySoundEffectPKc;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z15PlaySoundEffectPKc
_Z15PlaySoundEffectPKc:
.LFB6486:
	push	rbp	 #
	.seh_pushreg	rbp
	sub	rsp, 288	 #,
	.seh_stackalloc	288
	lea	rbp, 128[rsp]	 #,
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 176[rbp], rcx	 # soundName, soundName
 # src/audio.c:26:     if (!audioEnabled) return;
	mov	eax, DWORD PTR _ZL12audioEnabled[rip]	 # audioEnabled.0_1, audioEnabled
 # src/audio.c:26:     if (!audioEnabled) return;
	test	eax, eax	 # audioEnabled.0_1
	je	.L9	 #,
 # src/audio.c:29:     sprintf(filePath, "assets\\audio\\%s.wav", soundName);
	mov	rcx, QWORD PTR 176[rbp]	 # tmp99, soundName
	lea	rdx, .LC0[rip]	 # tmp100,
	lea	rax, -96[rbp]	 # tmp101,
	mov	r8, rcx	 #, tmp99
	mov	rcx, rax	 #, tmp101
	call	__mingw_sprintf	 #
 # src/audio.c:32:     PlaySound(filePath, NULL, SND_FILENAME | SND_ASYNC | SND_NODEFAULT);
	lea	rax, -96[rbp]	 # tmp102,
	mov	r8d, 131075	 #,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp102
	mov	rax, QWORD PTR __imp_PlaySoundA[rip]	 # tmp103,
	call	rax	 # tmp103
	jmp	.L5	 #
.L9:
 # src/audio.c:26:     if (!audioEnabled) return;
	nop	
.L5:
 # src/audio.c:33: }
	add	rsp, 288	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.ident	"GCC: (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) 15.2.0"
