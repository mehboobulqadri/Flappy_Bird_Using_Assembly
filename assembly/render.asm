	.file	"render.c"
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
	.section	.text$_ZN7Gdiplus19GdiplusStartupInputC1EPvii,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus19GdiplusStartupInputC1EPvii
	.def	_ZN7Gdiplus19GdiplusStartupInputC1EPvii;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus19GdiplusStartupInputC1EPvii
_ZN7Gdiplus19GdiplusStartupInputC1EPvii:
.LFB7582:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	QWORD PTR 24[rbp], rdx	 # debugEventCallback, debugEventCallback
	mov	DWORD PTR 32[rbp], r8d	 # suppressBackgroundThread, suppressBackgroundThread
	mov	DWORD PTR 40[rbp], r9d	 # suppressExternalCodecs, suppressExternalCodecs
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusinit.h:39: 		GdiplusVersion(1),
	mov	rax, QWORD PTR 16[rbp]	 # tmp98, this
	mov	DWORD PTR [rax], 1	 # this_2(D)->GdiplusVersion,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusinit.h:40: 		DebugEventCallback(debugEventCallback),
	mov	rax, QWORD PTR 16[rbp]	 # tmp99, this
	mov	rdx, QWORD PTR 24[rbp]	 # tmp100, debugEventCallback
	mov	QWORD PTR 8[rax], rdx	 # this_2(D)->DebugEventCallback, tmp100
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusinit.h:41: 		SuppressBackgroundThread(suppressBackgroundThread),
	mov	rax, QWORD PTR 16[rbp]	 # tmp101, this
	mov	edx, DWORD PTR 32[rbp]	 # tmp102, suppressBackgroundThread
	mov	DWORD PTR 16[rax], edx	 # this_2(D)->SuppressBackgroundThread, tmp102
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusinit.h:42: 		SuppressExternalCodecs(suppressExternalCodecs) {}
	mov	rax, QWORD PTR 16[rbp]	 # tmp103, this
	mov	edx, DWORD PTR 40[rbp]	 # tmp104, suppressExternalCodecs
	mov	DWORD PTR 20[rax], edx	 # this_2(D)->SuppressExternalCodecs, tmp104
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusinit.h:42: 		SuppressExternalCodecs(suppressExternalCodecs) {}
	nop	
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
	.align 4
_ZN7GdiplusL25GDIP_EMFPLUSFLAGS_DISPLAYE:
	.long	1
	.section	.text$_ZN7Gdiplus5Color8MakeARGBEhhhh,"x"
	.linkonce discard
	.globl	_ZN7Gdiplus5Color8MakeARGBEhhhh
	.def	_ZN7Gdiplus5Color8MakeARGBEhhhh;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5Color8MakeARGBEhhhh
_ZN7Gdiplus5Color8MakeARGBEhhhh:
.LFB7608:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	eax, edx	 # tmp111, r
	mov	r10d, r8d	 # tmp113, g
	mov	r8d, r9d	 # tmp115, b
	mov	edx, ecx	 # tmp110, tmp109
	mov	BYTE PTR 16[rbp], dl	 # a, tmp110
	mov	BYTE PTR 24[rbp], al	 # r, tmp112
	mov	eax, r10d	 # tmp114, tmp113
	mov	BYTE PTR 32[rbp], al	 # g, tmp114
	mov	eax, r8d	 # tmp116, tmp115
	mov	BYTE PTR 40[rbp], al	 # b, tmp116
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:55: 		return (ARGB) ((((DWORD) a) << 24) | (((DWORD) r) << 16)
	movzx	eax, BYTE PTR 16[rbp]	 # _1, a
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:55: 		return (ARGB) ((((DWORD) a) << 24) | (((DWORD) r) << 16)
	sal	eax, 24	 # _1,
	mov	edx, eax	 # _2, _1
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:55: 		return (ARGB) ((((DWORD) a) << 24) | (((DWORD) r) << 16)
	movzx	eax, BYTE PTR 24[rbp]	 # _3, r
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:55: 		return (ARGB) ((((DWORD) a) << 24) | (((DWORD) r) << 16)
	sal	eax, 16	 # _4,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:55: 		return (ARGB) ((((DWORD) a) << 24) | (((DWORD) r) << 16)
	or	edx, eax	 # _5, _4
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:56: 		             | (((DWORD) g) << 8) | ((DWORD) b));
	movzx	eax, BYTE PTR 32[rbp]	 # _6, g
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:56: 		             | (((DWORD) g) << 8) | ((DWORD) b));
	sal	eax, 8	 # _7,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:56: 		             | (((DWORD) g) << 8) | ((DWORD) b));
	or	edx, eax	 # _8, _7
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:56: 		             | (((DWORD) g) << 8) | ((DWORD) b));
	movzx	eax, BYTE PTR 40[rbp]	 # _9, b
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:56: 		             | (((DWORD) g) << 8) | ((DWORD) b));
	or	eax, edx	 # _14, _8
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:57: 	}
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus5ColorC1Ehhhh,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5ColorC1Ehhhh
	.def	_ZN7Gdiplus5ColorC1Ehhhh;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5ColorC1Ehhhh
_ZN7Gdiplus5ColorC1Ehhhh:
.LFB7620:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	eax, edx	 # tmp103, a
	mov	ecx, r9d	 # tmp107, g
	mov	edx, DWORD PTR 48[rbp]	 # tmp109, b
	mov	BYTE PTR 24[rbp], al	 # a, tmp104
	mov	eax, r8d	 # tmp106, tmp105
	mov	BYTE PTR 32[rbp], al	 # r, tmp106
	mov	eax, ecx	 # tmp108, tmp107
	mov	BYTE PTR 40[rbp], al	 # g, tmp108
	mov	eax, edx	 # tmp110, tmp109
	mov	BYTE PTR -4[rbp], al	 # b, tmp110
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:206: 	Color(BYTE a, BYTE r, BYTE g, BYTE b): Value(MakeARGB(a, r, g, b)) {}
	movzx	r8d, BYTE PTR -4[rbp]	 # _1, b
	movzx	ecx, BYTE PTR 40[rbp]	 # _2, g
	movzx	edx, BYTE PTR 32[rbp]	 # _3, r
	movzx	eax, BYTE PTR 24[rbp]	 # _4, a
	mov	r9d, r8d	 #, _1
	mov	r8d, ecx	 #, _2
	mov	ecx, eax	 #, _4
	call	_ZN7Gdiplus5Color8MakeARGBEhhhh	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:206: 	Color(BYTE a, BYTE r, BYTE g, BYTE b): Value(MakeARGB(a, r, g, b)) {}
	mov	rdx, QWORD PTR 16[rbp]	 # tmp111, this
	mov	DWORD PTR [rdx], eax	 # this_7(D)->Value, _5
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:206: 	Color(BYTE a, BYTE r, BYTE g, BYTE b): Value(MakeARGB(a, r, g, b)) {}
	nop	
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZNK7Gdiplus5Color8GetValueEv,"x"
	.linkonce discard
	.align 2
	.globl	_ZNK7Gdiplus5Color8GetValueEv
	.def	_ZNK7Gdiplus5Color8GetValueEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZNK7Gdiplus5Color8GetValueEv
_ZNK7Gdiplus5Color8GetValueEv:
.LFB7629:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:242: 		return Value;
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	eax, DWORD PTR [rax]	 # _3, this_2(D)->Value
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdipluscolor.h:243: 	}
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus11GdiplusBasenwEy,"x"
	.linkonce discard
	.globl	_ZN7Gdiplus11GdiplusBasenwEy
	.def	_ZN7Gdiplus11GdiplusBasenwEy;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus11GdiplusBasenwEy
_ZN7Gdiplus11GdiplusBasenwEy:
.LFB7637:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # in_size, in_size
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbase.h:38: 		return DllExports::GdipAlloc(in_size);
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, in_size
	mov	rcx, rax	 #, tmp100
	call	GdipAlloc	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbase.h:39: 	}
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus11GdiplusBasedlEPv,"x"
	.linkonce discard
	.globl	_ZN7Gdiplus11GdiplusBasedlEPv
	.def	_ZN7Gdiplus11GdiplusBasedlEPv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus11GdiplusBasedlEPv
_ZN7Gdiplus11GdiplusBasedlEPv:
.LFB7639:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # in_pVoid, in_pVoid
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbase.h:46: 		DllExports::GdipFree(in_pVoid);
	mov	rax, QWORD PTR 16[rbp]	 # tmp98, in_pVoid
	mov	rcx, rax	 #, tmp98
	call	GdipFree	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbase.h:47: 	}
	nop	
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus5ImageD1Ev,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5ImageD1Ev
	.def	_ZN7Gdiplus5ImageD1Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5ImageD1Ev
_ZN7Gdiplus5ImageD1Ev:
.LFB7643:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:69: 	{
	lea	rdx, _ZTVN7Gdiplus5ImageE[rip+16]	 # _1,
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	QWORD PTR [rax], rdx	 # this_4(D)->_vptr.Image, _1
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:70: 		DllExports::GdipDisposeImage(nativeImage);
	mov	rax, QWORD PTR 16[rbp]	 # tmp101, this
	mov	rax, QWORD PTR 8[rax]	 # _2, this_4(D)->nativeImage
	mov	rcx, rax	 #, _2
	call	GdipDisposeImage	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:71: 	}
	nop	
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_handler	__gxx_personality_seh0, @unwind, @except
	.seh_handlerdata
.LLSDA7643:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7643-.LLSDACSB7643
.LLSDACSB7643:
.LLSDACSE7643:
	.section	.text$_ZN7Gdiplus5ImageD1Ev,"x"
	.linkonce discard
	.seh_endproc
	.section	.text$_ZN7Gdiplus5ImageD0Ev,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5ImageD0Ev
	.def	_ZN7Gdiplus5ImageD0Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5ImageD0Ev
_ZN7Gdiplus5ImageD0Ev:
.LFB7644:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:71: 	}
	mov	rax, QWORD PTR 16[rbp]	 # tmp98, this
	mov	rcx, rax	 #, tmp98
	call	_ZN7Gdiplus5ImageD1Ev	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:71: 	}
	mov	rax, QWORD PTR 16[rbp]	 # tmp99, this
	mov	rcx, rax	 #, tmp99
	call	_ZN7Gdiplus11GdiplusBasedlEPv	 #
	nop	
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:71: 	}
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZNK7Gdiplus5Image5CloneEv,"x"
	.linkonce discard
	.align 2
	.globl	_ZNK7Gdiplus5Image5CloneEv
	.def	_ZNK7Gdiplus5Image5CloneEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZNK7Gdiplus5Image5CloneEv
_ZNK7Gdiplus5Image5CloneEv:
.LFB7645:
	push	rbp	 #
	.seh_pushreg	rbp
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 72	 #,
	.seh_stackalloc	72
	lea	rbp, 64[rsp]	 #,
	.seh_setframe	rbp, 64
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:74: 		GpImage *cloneImage = NULL;
	mov	QWORD PTR -24[rbp], 0	 # cloneImage,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:76: 				nativeImage, &cloneImage));
	mov	rax, QWORD PTR 32[rbp]	 # tmp108, this
	mov	rax, QWORD PTR 8[rax]	 # _1, this_13(D)->nativeImage
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:75: 		Status status = updateStatus(DllExports::GdipCloneImage(
	lea	rdx, -24[rbp]	 # tmp109,
	mov	rcx, rax	 #, _1
	call	GdipCloneImage	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:75: 		Status status = updateStatus(DllExports::GdipCloneImage(
	mov	rax, QWORD PTR 32[rbp]	 # tmp110, this
	mov	rcx, rax	 #, tmp110
	call	_ZNK7Gdiplus5Image12updateStatusENS_8GpStatusE	 #
	mov	DWORD PTR -4[rbp], eax	 # status, tmp111
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:77: 		if (status == Ok) {
	cmp	DWORD PTR -4[rbp], 0	 # status,
	jne	.L13	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:78: 			Image *result = new Image(cloneImage, lastStatus);
	mov	ecx, 24	 #,
	call	_ZN7Gdiplus11GdiplusBasenwEy	 #
	mov	rbx, rax	 # _20,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:78: 			Image *result = new Image(cloneImage, lastStatus);
	mov	rax, QWORD PTR 32[rbp]	 # tmp112, this
	mov	edx, DWORD PTR 16[rax]	 # _3, this_13(D)->lastStatus
	mov	rax, QWORD PTR -24[rbp]	 # cloneImage.24_4, cloneImage
	mov	r8d, edx	 #, _3
	mov	rdx, rax	 #, cloneImage.24_4
	mov	rcx, rbx	 #, _20
	call	_ZN7Gdiplus5ImageC1EPNS_7GpImageENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:78: 			Image *result = new Image(cloneImage, lastStatus);
	mov	eax, 0	 # _24,
	mov	QWORD PTR -16[rbp], rbx	 # result, _20
	test	al, al	 # _24
	je	.L14	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:78: 			Image *result = new Image(cloneImage, lastStatus);
	mov	rcx, rbx	 #, _20
	call	_ZN7Gdiplus11GdiplusBasedlEPv	 #
.L14:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:79: 			if (!result) {
	cmp	QWORD PTR -16[rbp], 0	 # result,
	jne	.L15	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:80: 				DllExports::GdipDisposeImage(cloneImage);
	mov	rax, QWORD PTR -24[rbp]	 # cloneImage.25_5, cloneImage
	mov	rcx, rax	 #, cloneImage.25_5
	call	GdipDisposeImage	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:81: 				lastStatus = OutOfMemory;
	mov	rax, QWORD PTR 32[rbp]	 # tmp113, this
	mov	DWORD PTR 16[rax], 3	 # this_13(D)->lastStatus,
.L15:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:83: 			return result;
	mov	rax, QWORD PTR -16[rbp]	 # _6, result
	jmp	.L17	 #
.L13:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:85: 			return NULL;
	mov	eax, 0	 # _6,
.L17:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:87: 	}
	add	rsp, 72	 #,
	pop	rbx	 #
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZNK7Gdiplus5Image13GetLastStatusEv,"x"
	.linkonce discard
	.align 2
	.globl	_ZNK7Gdiplus5Image13GetLastStatusEv
	.def	_ZNK7Gdiplus5Image13GetLastStatusEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZNK7Gdiplus5Image13GetLastStatusEv
_ZNK7Gdiplus5Image13GetLastStatusEv:
.LFB7646:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 16	 #,
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:135: 		Status result = lastStatus;
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	eax, DWORD PTR 16[rax]	 # tmp101, this_2(D)->lastStatus
	mov	DWORD PTR -4[rbp], eax	 # result, tmp101
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:136: 		lastStatus = Ok;
	mov	rax, QWORD PTR 16[rbp]	 # tmp102, this
	mov	DWORD PTR 16[rax], 0	 # this_2(D)->lastStatus,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:137: 		return result;
	mov	eax, DWORD PTR -4[rbp]	 # _5, result
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:138: 	}
	add	rsp, 16	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus5ImageC1EPNS_7GpImageENS_8GpStatusE,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5ImageC1EPNS_7GpImageENS_8GpStatusE
	.def	_ZN7Gdiplus5ImageC1EPNS_7GpImageENS_8GpStatusE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5ImageC1EPNS_7GpImageENS_8GpStatusE
_ZN7Gdiplus5ImageC1EPNS_7GpImageENS_8GpStatusE:
.LFB7649:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	QWORD PTR 24[rbp], rdx	 # image, image
	mov	DWORD PTR 32[rbp], r8d	 # status, status
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:142: 		nativeImage(image), lastStatus(status) {}
	lea	rdx, _ZTVN7Gdiplus5ImageE[rip+16]	 # _1,
	mov	rax, QWORD PTR 16[rbp]	 # tmp99, this
	mov	QWORD PTR [rax], rdx	 # this_3(D)->_vptr.Image, _1
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:142: 		nativeImage(image), lastStatus(status) {}
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	rdx, QWORD PTR 24[rbp]	 # tmp101, image
	mov	QWORD PTR 8[rax], rdx	 # this_3(D)->nativeImage, tmp101
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:142: 		nativeImage(image), lastStatus(status) {}
	mov	rax, QWORD PTR 16[rbp]	 # tmp102, this
	mov	edx, DWORD PTR 32[rbp]	 # tmp103, status
	mov	DWORD PTR 16[rax], edx	 # this_3(D)->lastStatus, tmp103
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:142: 		nativeImage(image), lastStatus(status) {}
	nop	
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZNK7Gdiplus5Image12updateStatusENS_8GpStatusE,"x"
	.linkonce discard
	.align 2
	.globl	_ZNK7Gdiplus5Image12updateStatusENS_8GpStatusE
	.def	_ZNK7Gdiplus5Image12updateStatusENS_8GpStatusE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZNK7Gdiplus5Image12updateStatusENS_8GpStatusE
_ZNK7Gdiplus5Image12updateStatusENS_8GpStatusE:
.LFB7650:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	DWORD PTR 24[rbp], edx	 # newStatus, newStatus
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:148: 		if (newStatus != Ok) lastStatus = newStatus;
	cmp	DWORD PTR 24[rbp], 0	 # newStatus,
	je	.L22	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:148: 		if (newStatus != Ok) lastStatus = newStatus;
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	edx, DWORD PTR 24[rbp]	 # tmp101, newStatus
	mov	DWORD PTR 16[rax], edx	 # this_4(D)->lastStatus, tmp101
.L22:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:149: 		return newStatus;
	mov	eax, DWORD PTR 24[rbp]	 # _6, newStatus
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusheaders.h:150: 	}
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus5BrushD2Ev,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5BrushD2Ev
	.def	_ZN7Gdiplus5BrushD2Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5BrushD2Ev
_ZN7Gdiplus5BrushD2Ev:
.LFB7778:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:45: 	{
	lea	rdx, _ZTVN7Gdiplus5BrushE[rip+16]	 # _1,
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	QWORD PTR [rax], rdx	 # this_4(D)->_vptr.Brush, _1
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:46: 		DllExports::GdipDeleteBrush(nativeBrush);
	mov	rax, QWORD PTR 16[rbp]	 # tmp101, this
	mov	rax, QWORD PTR 8[rax]	 # _2, this_4(D)->nativeBrush
	mov	rcx, rax	 #, _2
	call	GdipDeleteBrush	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:47: 	}
	nop	
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_handler	__gxx_personality_seh0, @unwind, @except
	.seh_handlerdata
.LLSDA7778:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7778-.LLSDACSB7778
.LLSDACSB7778:
.LLSDACSE7778:
	.section	.text$_ZN7Gdiplus5BrushD2Ev,"x"
	.linkonce discard
	.seh_endproc
	.section	.text$_ZN7Gdiplus5BrushD1Ev,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5BrushD1Ev
	.def	_ZN7Gdiplus5BrushD1Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5BrushD1Ev
_ZN7Gdiplus5BrushD1Ev:
.LFB7779:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:45: 	{
	lea	rdx, _ZTVN7Gdiplus5BrushE[rip+16]	 # _1,
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	QWORD PTR [rax], rdx	 # this_4(D)->_vptr.Brush, _1
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:46: 		DllExports::GdipDeleteBrush(nativeBrush);
	mov	rax, QWORD PTR 16[rbp]	 # tmp101, this
	mov	rax, QWORD PTR 8[rax]	 # _2, this_4(D)->nativeBrush
	mov	rcx, rax	 #, _2
	call	GdipDeleteBrush	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:47: 	}
	nop	
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_handler	__gxx_personality_seh0, @unwind, @except
	.seh_handlerdata
.LLSDA7779:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7779-.LLSDACSB7779
.LLSDACSB7779:
.LLSDACSE7779:
	.section	.text$_ZN7Gdiplus5BrushD1Ev,"x"
	.linkonce discard
	.seh_endproc
	.section	.text$_ZN7Gdiplus5BrushD0Ev,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5BrushD0Ev
	.def	_ZN7Gdiplus5BrushD0Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5BrushD0Ev
_ZN7Gdiplus5BrushD0Ev:
.LFB7780:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:47: 	}
	mov	rax, QWORD PTR 16[rbp]	 # tmp98, this
	mov	rcx, rax	 #, tmp98
	call	_ZN7Gdiplus5BrushD1Ev	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:47: 	}
	mov	rax, QWORD PTR 16[rbp]	 # tmp99, this
	mov	rcx, rax	 #, tmp99
	call	_ZN7Gdiplus11GdiplusBasedlEPv	 #
	nop	
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:47: 	}
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZNK7Gdiplus5Brush5CloneEv,"x"
	.linkonce discard
	.align 2
	.globl	_ZNK7Gdiplus5Brush5CloneEv
	.def	_ZNK7Gdiplus5Brush5CloneEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZNK7Gdiplus5Brush5CloneEv
_ZNK7Gdiplus5Brush5CloneEv:
.LFB7781:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:50: 		lastStatus = NotImplemented;
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	DWORD PTR 16[rax], 6	 # this_2(D)->lastStatus,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:51: 		return NULL;
	mov	eax, 0	 # _4,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:52: 	}
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus5BrushC2Ev,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5BrushC2Ev
	.def	_ZN7Gdiplus5BrushC2Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5BrushC2Ev
_ZN7Gdiplus5BrushC2Ev:
.LFB7785:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:68: 	Brush(): nativeBrush(NULL), lastStatus(Ok) {}
	lea	rdx, _ZTVN7Gdiplus5BrushE[rip+16]	 # _1,
	mov	rax, QWORD PTR 16[rbp]	 # tmp99, this
	mov	QWORD PTR [rax], rdx	 # this_3(D)->_vptr.Brush, _1
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:68: 	Brush(): nativeBrush(NULL), lastStatus(Ok) {}
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	QWORD PTR 8[rax], 0	 # this_3(D)->nativeBrush,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:68: 	Brush(): nativeBrush(NULL), lastStatus(Ok) {}
	mov	rax, QWORD PTR 16[rbp]	 # tmp101, this
	mov	DWORD PTR 16[rax], 0	 # this_3(D)->lastStatus,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:68: 	Brush(): nativeBrush(NULL), lastStatus(Ok) {}
	nop	
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus5BrushC2EPNS_7GpBrushENS_8GpStatusE,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5BrushC2EPNS_7GpBrushENS_8GpStatusE
	.def	_ZN7Gdiplus5BrushC2EPNS_7GpBrushENS_8GpStatusE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5BrushC2EPNS_7GpBrushENS_8GpStatusE
_ZN7Gdiplus5BrushC2EPNS_7GpBrushENS_8GpStatusE:
.LFB7788:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	QWORD PTR 24[rbp], rdx	 # brush, brush
	mov	DWORD PTR 32[rbp], r8d	 # status, status
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:70: 		nativeBrush(brush), lastStatus(status) {}
	lea	rdx, _ZTVN7Gdiplus5BrushE[rip+16]	 # _1,
	mov	rax, QWORD PTR 16[rbp]	 # tmp99, this
	mov	QWORD PTR [rax], rdx	 # this_3(D)->_vptr.Brush, _1
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:70: 		nativeBrush(brush), lastStatus(status) {}
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	rdx, QWORD PTR 24[rbp]	 # tmp101, brush
	mov	QWORD PTR 8[rax], rdx	 # this_3(D)->nativeBrush, tmp101
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:70: 		nativeBrush(brush), lastStatus(status) {}
	mov	rax, QWORD PTR 16[rbp]	 # tmp102, this
	mov	edx, DWORD PTR 32[rbp]	 # tmp103, status
	mov	DWORD PTR 16[rax], edx	 # this_3(D)->lastStatus, tmp103
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:70: 		nativeBrush(brush), lastStatus(status) {}
	nop	
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZNK7Gdiplus5Brush12updateStatusENS_8GpStatusE,"x"
	.linkonce discard
	.align 2
	.globl	_ZNK7Gdiplus5Brush12updateStatusENS_8GpStatusE
	.def	_ZNK7Gdiplus5Brush12updateStatusENS_8GpStatusE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZNK7Gdiplus5Brush12updateStatusENS_8GpStatusE
_ZNK7Gdiplus5Brush12updateStatusENS_8GpStatusE:
.LFB7790:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	DWORD PTR 24[rbp], edx	 # newStatus, newStatus
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:76: 		if (newStatus != Ok) lastStatus = newStatus;
	cmp	DWORD PTR 24[rbp], 0	 # newStatus,
	je	.L32	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:76: 		if (newStatus != Ok) lastStatus = newStatus;
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	edx, DWORD PTR 24[rbp]	 # tmp101, newStatus
	mov	DWORD PTR 16[rax], edx	 # this_4(D)->lastStatus, tmp101
.L32:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:77: 		return newStatus;
	mov	eax, DWORD PTR 24[rbp]	 # _6, newStatus
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:78: 	}
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus10SolidBrushC1ERKNS_5ColorE,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus10SolidBrushC1ERKNS_5ColorE
	.def	_ZN7Gdiplus10SolidBrushC1ERKNS_5ColorE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus10SolidBrushC1ERKNS_5ColorE
_ZN7Gdiplus10SolidBrushC1ERKNS_5ColorE:
.LFB7848:
	push	rbp	 #
	.seh_pushreg	rbp
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 56	 #,
	.seh_stackalloc	56
	lea	rbp, 48[rsp]	 #,
	.seh_setframe	rbp, 48
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx	 # this, this
	mov	QWORD PTR 40[rbp], rdx	 # color, color
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:406: 	{
	mov	rax, QWORD PTR 32[rbp]	 # _1, this
	mov	rcx, rax	 #, _1
	call	_ZN7Gdiplus5BrushC2Ev	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:406: 	{
	lea	rdx, _ZTVN7Gdiplus10SolidBrushE[rip+16]	 # _2,
	mov	rax, QWORD PTR 32[rbp]	 # tmp105, this
	mov	QWORD PTR [rax], rdx	 # this_8(D)->D.125025._vptr.Brush, _2
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:407: 		GpSolidFill *nativeSolidFill = NULL;
	mov	QWORD PTR -8[rbp], 0	 # nativeSolidFill,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:408: 		lastStatus = DllExports::GdipCreateSolidFill(
	mov	rax, QWORD PTR 40[rbp]	 # tmp106, color
	mov	rcx, rax	 #, tmp106
	call	_ZNK7Gdiplus5Color8GetValueEv	 #
	mov	ecx, eax	 # _3,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:408: 		lastStatus = DllExports::GdipCreateSolidFill(
	lea	rax, -8[rbp]	 # tmp107,
	mov	rdx, rax	 #, tmp107
.LEHB0:
	call	GdipCreateSolidFill	 #
.LEHE0:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:408: 		lastStatus = DllExports::GdipCreateSolidFill(
	mov	rdx, QWORD PTR 32[rbp]	 # tmp108, this
	mov	DWORD PTR 16[rdx], eax	 # this_8(D)->D.125025.lastStatus, _4
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:410: 		nativeBrush = nativeSolidFill; 
	mov	rdx, QWORD PTR -8[rbp]	 # nativeSolidFill.37_5, nativeSolidFill
	mov	rax, QWORD PTR 32[rbp]	 # tmp109, this
	mov	QWORD PTR 8[rax], rdx	 # this_8(D)->D.125025.nativeBrush, nativeSolidFill.37_5
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:411: 	}
	jmp	.L37	 #
.L36:
	mov	rbx, rax	 # tmp110,
	mov	rax, QWORD PTR 32[rbp]	 # _6, this
	mov	rcx, rax	 #, _6
	call	_ZN7Gdiplus5BrushD2Ev	 #
	mov	rax, rbx	 # D.135073, tmp110
	mov	rcx, rax	 #, D.135073
.LEHB1:
	call	_Unwind_Resume	 #
	nop	
.LEHE1:
.L37:
	add	rsp, 56	 #,
	pop	rbx	 #
	pop	rbp	 #
	ret	
	.seh_handler	__gxx_personality_seh0, @unwind, @except
	.seh_handlerdata
.LLSDA7848:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7848-.LLSDACSB7848
.LLSDACSB7848:
	.uleb128 .LEHB0-.LFB7848
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L36-.LFB7848
	.uleb128 0
	.uleb128 .LEHB1-.LFB7848
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
.LLSDACSE7848:
	.section	.text$_ZN7Gdiplus10SolidBrushC1ERKNS_5ColorE,"x"
	.linkonce discard
	.seh_endproc
	.section	.text$_ZNK7Gdiplus10SolidBrush5CloneEv,"x"
	.linkonce discard
	.align 2
	.globl	_ZNK7Gdiplus10SolidBrush5CloneEv
	.def	_ZNK7Gdiplus10SolidBrush5CloneEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZNK7Gdiplus10SolidBrush5CloneEv
_ZNK7Gdiplus10SolidBrush5CloneEv:
.LFB7849:
	push	rbp	 #
	.seh_pushreg	rbp
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 72	 #,
	.seh_stackalloc	72
	lea	rbp, 64[rsp]	 #,
	.seh_setframe	rbp, 64
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:414: 		GpBrush *cloneBrush = NULL;
	mov	QWORD PTR -24[rbp], 0	 # cloneBrush,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:415: 		Status status = updateStatus(DllExports::GdipCloneBrush(
	mov	rbx, QWORD PTR 32[rbp]	 # _1, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:416: 				nativeBrush, &cloneBrush));
	mov	rax, QWORD PTR 32[rbp]	 # tmp110, this
	mov	rax, QWORD PTR 8[rax]	 # _2, this_15(D)->D.125025.nativeBrush
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:415: 		Status status = updateStatus(DllExports::GdipCloneBrush(
	lea	rdx, -24[rbp]	 # tmp111,
	mov	rcx, rax	 #, _2
	call	GdipCloneBrush	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:415: 		Status status = updateStatus(DllExports::GdipCloneBrush(
	mov	edx, eax	 #, _3
	mov	rcx, rbx	 #, _1
	call	_ZNK7Gdiplus5Brush12updateStatusENS_8GpStatusE	 #
	mov	DWORD PTR -4[rbp], eax	 # status, tmp112
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:417: 		if (status == Ok) {
	cmp	DWORD PTR -4[rbp], 0	 # status,
	jne	.L39	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:419: 				new SolidBrush(cloneBrush, lastStatus);
	mov	ecx, 24	 #,
	call	_ZN7Gdiplus11GdiplusBasenwEy	 #
	mov	rbx, rax	 # _22,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:419: 				new SolidBrush(cloneBrush, lastStatus);
	mov	rax, QWORD PTR 32[rbp]	 # tmp113, this
	mov	edx, DWORD PTR 16[rax]	 # _4, this_15(D)->D.125025.lastStatus
	mov	rax, QWORD PTR -24[rbp]	 # cloneBrush.38_5, cloneBrush
	mov	r8d, edx	 #, _4
	mov	rdx, rax	 #, cloneBrush.38_5
	mov	rcx, rbx	 #, _22
	call	_ZN7Gdiplus10SolidBrushC1EPNS_7GpBrushENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:419: 				new SolidBrush(cloneBrush, lastStatus);
	mov	eax, 0	 # _26,
	mov	QWORD PTR -16[rbp], rbx	 # result, _22
	test	al, al	 # _26
	je	.L40	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:419: 				new SolidBrush(cloneBrush, lastStatus);
	mov	rcx, rbx	 #, _22
	call	_ZN7Gdiplus11GdiplusBasedlEPv	 #
.L40:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:420: 			if (!result) {
	cmp	QWORD PTR -16[rbp], 0	 # result,
	jne	.L41	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:421: 				DllExports::GdipDeleteBrush(cloneBrush);
	mov	rax, QWORD PTR -24[rbp]	 # cloneBrush.39_6, cloneBrush
	mov	rcx, rax	 #, cloneBrush.39_6
	call	GdipDeleteBrush	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:422: 				updateStatus(OutOfMemory);
	mov	rax, QWORD PTR 32[rbp]	 # _7, this
	mov	edx, 3	 #,
	mov	rcx, rax	 #, _7
	call	_ZNK7Gdiplus5Brush12updateStatusENS_8GpStatusE	 #
.L41:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:424: 			return result;
	mov	rax, QWORD PTR -16[rbp]	 # _8, result
	jmp	.L43	 #
.L39:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:426: 			return NULL;
	mov	eax, 0	 # _8,
.L43:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:428: 	}
	add	rsp, 72	 #,
	pop	rbx	 #
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus10SolidBrushC1EPNS_7GpBrushENS_8GpStatusE,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus10SolidBrushC1EPNS_7GpBrushENS_8GpStatusE
	.def	_ZN7Gdiplus10SolidBrushC1EPNS_7GpBrushENS_8GpStatusE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus10SolidBrushC1EPNS_7GpBrushENS_8GpStatusE
_ZN7Gdiplus10SolidBrushC1EPNS_7GpBrushENS_8GpStatusE:
.LFB7854:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	QWORD PTR 24[rbp], rdx	 # brush, brush
	mov	DWORD PTR 32[rbp], r8d	 # status, status
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:443: 	SolidBrush(GpBrush *brush, Status status): Brush(brush, status) {}
	mov	rax, QWORD PTR 16[rbp]	 # _1, this
	mov	ecx, DWORD PTR 32[rbp]	 # tmp101, status
	mov	rdx, QWORD PTR 24[rbp]	 # tmp102, brush
	mov	r8d, ecx	 #, tmp101
	mov	rcx, rax	 #, _1
	call	_ZN7Gdiplus5BrushC2EPNS_7GpBrushENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:443: 	SolidBrush(GpBrush *brush, Status status): Brush(brush, status) {}
	lea	rdx, _ZTVN7Gdiplus10SolidBrushE[rip+16]	 # _2,
	mov	rax, QWORD PTR 16[rbp]	 # tmp103, this
	mov	QWORD PTR [rax], rdx	 # this_5(D)->D.125025._vptr.Brush, _2
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:443: 	SolidBrush(GpBrush *brush, Status status): Brush(brush, status) {}
	nop	
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus8GraphicsC1EP5HDC__,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus8GraphicsC1EP5HDC__
	.def	_ZN7Gdiplus8GraphicsC1EP5HDC__;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus8GraphicsC1EP5HDC__
_ZN7Gdiplus8GraphicsC1EP5HDC__:
.LFB8201:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	QWORD PTR 24[rbp], rdx	 # hdc, hdc
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:70: 	Graphics(HDC hdc): nativeGraphics(NULL), lastStatus(Ok)
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	QWORD PTR [rax], 0	 # this_4(D)->nativeGraphics,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:70: 	Graphics(HDC hdc): nativeGraphics(NULL), lastStatus(Ok)
	mov	rax, QWORD PTR 16[rbp]	 # tmp101, this
	mov	DWORD PTR 8[rax], 0	 # this_4(D)->lastStatus,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:72: 		lastStatus = DllExports::GdipCreateFromHDC(
	mov	rdx, QWORD PTR 16[rbp]	 # _1, this
	mov	rax, QWORD PTR 24[rbp]	 # tmp102, hdc
	mov	rcx, rax	 #, tmp102
	call	GdipCreateFromHDC	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:72: 		lastStatus = DllExports::GdipCreateFromHDC(
	mov	rdx, QWORD PTR 16[rbp]	 # tmp103, this
	mov	DWORD PTR 8[rdx], eax	 # this_4(D)->lastStatus, _2
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:74: 	}
	nop	
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus8GraphicsD1Ev,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus8GraphicsD1Ev
	.def	_ZN7Gdiplus8GraphicsD1Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus8GraphicsD1Ev
_ZN7Gdiplus8GraphicsD1Ev:
.LFB8210:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:93: 		DllExports::GdipDeleteGraphics(nativeGraphics);
	mov	rax, QWORD PTR 16[rbp]	 # tmp99, this
	mov	rax, QWORD PTR [rax]	 # _1, this_3(D)->nativeGraphics
	mov	rcx, rax	 #, _1
	call	GdipDeleteGraphics	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:94: 	}
	nop	
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_handler	__gxx_personality_seh0, @unwind, @except
	.seh_handlerdata
.LLSDA8210:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8210-.LLSDACSB8210
.LLSDACSB8210:
.LLSDACSE8210:
	.section	.text$_ZN7Gdiplus8GraphicsD1Ev,"x"
	.linkonce discard
	.seh_endproc
	.section	.text$_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii
	.def	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii
_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii:
.LFB8243:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	QWORD PTR 24[rbp], rdx	 # image, image
	mov	DWORD PTR 32[rbp], r8d	 # x, x
	mov	DWORD PTR 40[rbp], r9d	 # y, y
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:328: 		return updateStatus(DllExports::GdipDrawImageI(
	cmp	QWORD PTR 24[rbp], 0	 # image,
	je	.L48	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:328: 		return updateStatus(DllExports::GdipDrawImageI(
	mov	rax, QWORD PTR 24[rbp]	 # tmp103, image
	mov	rax, QWORD PTR 8[rax]	 # iftmp.43_3, image_4(D)->nativeImage
	jmp	.L49	 #
.L48:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:328: 		return updateStatus(DllExports::GdipDrawImageI(
	mov	eax, 0	 # iftmp.43_3,
.L49:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:328: 		return updateStatus(DllExports::GdipDrawImageI(
	mov	rdx, QWORD PTR 16[rbp]	 # tmp104, this
	mov	rcx, QWORD PTR [rdx]	 # _1, this_8(D)->nativeGraphics
	mov	r8d, DWORD PTR 40[rbp]	 # tmp105, y
	mov	edx, DWORD PTR 32[rbp]	 # tmp106, x
	mov	r9d, r8d	 #, tmp105
	mov	r8d, edx	 #, tmp106
	mov	rdx, rax	 #, iftmp.43_3
	call	GdipDrawImageI	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:328: 		return updateStatus(DllExports::GdipDrawImageI(
	mov	rax, QWORD PTR 16[rbp]	 # tmp107, this
	mov	rcx, rax	 #, tmp107
	call	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:332: 	}
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii
	.def	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii
_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii:
.LFB8247:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	QWORD PTR 24[rbp], rdx	 # image, image
	mov	DWORD PTR 32[rbp], r8d	 # x, x
	mov	DWORD PTR 40[rbp], r9d	 # y, y
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:356: 		return updateStatus(DllExports::GdipDrawImageRectI(
	cmp	QWORD PTR 24[rbp], 0	 # image,
	je	.L52	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:356: 		return updateStatus(DllExports::GdipDrawImageRectI(
	mov	rax, QWORD PTR 24[rbp]	 # tmp103, image
	mov	rax, QWORD PTR 8[rax]	 # iftmp.64_3, image_4(D)->nativeImage
	jmp	.L53	 #
.L52:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:356: 		return updateStatus(DllExports::GdipDrawImageRectI(
	mov	eax, 0	 # iftmp.64_3,
.L53:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:356: 		return updateStatus(DllExports::GdipDrawImageRectI(
	mov	rdx, QWORD PTR 16[rbp]	 # tmp104, this
	mov	rcx, QWORD PTR [rdx]	 # _1, this_8(D)->nativeGraphics
	mov	r9d, DWORD PTR 40[rbp]	 # tmp105, y
	mov	r8d, DWORD PTR 32[rbp]	 # tmp106, x
	mov	edx, DWORD PTR 56[rbp]	 # tmp107, height
	mov	DWORD PTR 40[rsp], edx	 #, tmp107
	mov	edx, DWORD PTR 48[rbp]	 # tmp108, width
	mov	DWORD PTR 32[rsp], edx	 #, tmp108
	mov	rdx, rax	 #, iftmp.64_3
	call	GdipDrawImageRectI	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:356: 		return updateStatus(DllExports::GdipDrawImageRectI(
	mov	rax, QWORD PTR 16[rbp]	 # tmp109, this
	mov	rcx, rax	 #, tmp109
	call	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:360: 	}
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus8Graphics11FillEllipseEPKNS_5BrushEiiii,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus8Graphics11FillEllipseEPKNS_5BrushEiiii
	.def	_ZN7Gdiplus8Graphics11FillEllipseEPKNS_5BrushEiiii;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus8Graphics11FillEllipseEPKNS_5BrushEiiii
_ZN7Gdiplus8Graphics11FillEllipseEPKNS_5BrushEiiii:
.LFB8302:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	QWORD PTR 24[rbp], rdx	 # brush, brush
	mov	DWORD PTR 32[rbp], r8d	 # x, x
	mov	DWORD PTR 40[rbp], r9d	 # y, y
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:879: 		return updateStatus(DllExports::GdipFillEllipseI(
	cmp	QWORD PTR 24[rbp], 0	 # brush,
	je	.L56	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:879: 		return updateStatus(DllExports::GdipFillEllipseI(
	mov	rax, QWORD PTR 24[rbp]	 # tmp103, brush
	mov	rax, QWORD PTR 8[rax]	 # iftmp.40_3, brush_4(D)->nativeBrush
	jmp	.L57	 #
.L56:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:879: 		return updateStatus(DllExports::GdipFillEllipseI(
	mov	eax, 0	 # iftmp.40_3,
.L57:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:879: 		return updateStatus(DllExports::GdipFillEllipseI(
	mov	rdx, QWORD PTR 16[rbp]	 # tmp104, this
	mov	rcx, QWORD PTR [rdx]	 # _1, this_8(D)->nativeGraphics
	mov	r9d, DWORD PTR 40[rbp]	 # tmp105, y
	mov	r8d, DWORD PTR 32[rbp]	 # tmp106, x
	mov	edx, DWORD PTR 56[rbp]	 # tmp107, height
	mov	DWORD PTR 40[rsp], edx	 #, tmp107
	mov	edx, DWORD PTR 48[rbp]	 # tmp108, width
	mov	DWORD PTR 32[rsp], edx	 #, tmp108
	mov	rdx, rax	 #, iftmp.40_3
	call	GdipFillEllipseI	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:879: 		return updateStatus(DllExports::GdipFillEllipseI(
	mov	rax, QWORD PTR 16[rbp]	 # tmp109, this
	mov	rcx, rax	 #, tmp109
	call	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:883: 	}
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus8Graphics14ResetTransformEv,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus8Graphics14ResetTransformEv
	.def	_ZN7Gdiplus8Graphics14ResetTransformEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus8Graphics14ResetTransformEv
_ZN7Gdiplus8Graphics14ResetTransformEv:
.LFB8366:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1362: 		return updateStatus(DllExports::GdipResetWorldTransform(
	mov	rax, QWORD PTR 16[rbp]	 # tmp102, this
	mov	rax, QWORD PTR [rax]	 # _1, this_4(D)->nativeGraphics
	mov	rcx, rax	 #, _1
	call	GdipResetWorldTransform	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1362: 		return updateStatus(DllExports::GdipResetWorldTransform(
	mov	rax, QWORD PTR 16[rbp]	 # tmp103, this
	mov	rcx, rax	 #, tmp103
	call	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1364: 	}
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus8Graphics15RotateTransformEfNS_11MatrixOrderE,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus8Graphics15RotateTransformEfNS_11MatrixOrderE
	.def	_ZN7Gdiplus8Graphics15RotateTransformEfNS_11MatrixOrderE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus8Graphics15RotateTransformEfNS_11MatrixOrderE
_ZN7Gdiplus8Graphics15RotateTransformEfNS_11MatrixOrderE:
.LFB8368:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	movss	DWORD PTR 24[rbp], xmm1	 # angle, angle
	mov	DWORD PTR 32[rbp], r8d	 # order, order
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1373: 		return updateStatus(DllExports::GdipRotateWorldTransform(
	mov	rax, QWORD PTR 16[rbp]	 # tmp102, this
	mov	rax, QWORD PTR [rax]	 # _1, this_4(D)->nativeGraphics
	mov	edx, DWORD PTR 32[rbp]	 # tmp103, order
	movss	xmm0, DWORD PTR 24[rbp]	 # tmp104, angle
	mov	r8d, edx	 #, tmp103
	movaps	xmm1, xmm0	 #, tmp104
	mov	rcx, rax	 #, _1
	call	GdipRotateWorldTransform	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1373: 		return updateStatus(DllExports::GdipRotateWorldTransform(
	mov	rax, QWORD PTR 16[rbp]	 # tmp105, this
	mov	rcx, rax	 #, tmp105
	call	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1375: 	}
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus8Graphics20SetInterpolationModeENS_17InterpolationModeE,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus8Graphics20SetInterpolationModeENS_17InterpolationModeE
	.def	_ZN7Gdiplus8Graphics20SetInterpolationModeENS_17InterpolationModeE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus8Graphics20SetInterpolationModeENS_17InterpolationModeE
_ZN7Gdiplus8Graphics20SetInterpolationModeENS_17InterpolationModeE:
.LFB8380:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	DWORD PTR 24[rbp], edx	 # interpolationMode, interpolationMode
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1449: 		return updateStatus(DllExports::GdipSetInterpolationMode(
	mov	rax, QWORD PTR 16[rbp]	 # tmp102, this
	mov	rax, QWORD PTR [rax]	 # _1, this_4(D)->nativeGraphics
	mov	edx, DWORD PTR 24[rbp]	 # tmp103, interpolationMode
	mov	rcx, rax	 #, _1
	call	GdipSetInterpolationMode	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1449: 		return updateStatus(DllExports::GdipSetInterpolationMode(
	mov	rax, QWORD PTR 16[rbp]	 # tmp104, this
	mov	rcx, rax	 #, tmp104
	call	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1451: 	}
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus8Graphics18TranslateTransformEffNS_11MatrixOrderE,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus8Graphics18TranslateTransformEffNS_11MatrixOrderE
	.def	_ZN7Gdiplus8Graphics18TranslateTransformEffNS_11MatrixOrderE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus8Graphics18TranslateTransformEffNS_11MatrixOrderE
_ZN7Gdiplus8Graphics18TranslateTransformEffNS_11MatrixOrderE:
.LFB8393:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	movss	DWORD PTR 24[rbp], xmm1	 # dx, dx
	movss	DWORD PTR 32[rbp], xmm2	 # dy, dy
	mov	DWORD PTR 40[rbp], r9d	 # order, order
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1522: 		return updateStatus(DllExports::GdipTranslateWorldTransform(
	mov	rax, QWORD PTR 16[rbp]	 # tmp102, this
	mov	rax, QWORD PTR [rax]	 # _1, this_4(D)->nativeGraphics
	mov	edx, DWORD PTR 40[rbp]	 # tmp103, order
	movss	xmm1, DWORD PTR 32[rbp]	 # tmp104, dy
	movss	xmm0, DWORD PTR 24[rbp]	 # tmp105, dx
	mov	r9d, edx	 #, tmp103
	movaps	xmm2, xmm1	 #, tmp104
	movaps	xmm1, xmm0	 #, tmp105
	mov	rcx, rax	 #, _1
	call	GdipTranslateWorldTransform	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1522: 		return updateStatus(DllExports::GdipTranslateWorldTransform(
	mov	rax, QWORD PTR 16[rbp]	 # tmp106, this
	mov	rcx, rax	 #, tmp106
	call	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1524: 	}
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE,"x"
	.linkonce discard
	.align 2
	.globl	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE
	.def	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE
_ZNK7Gdiplus8Graphics12updateStatusENS_8GpStatusE:
.LFB8394:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	DWORD PTR 24[rbp], edx	 # newStatus, newStatus
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1532: 		if (newStatus != Ok) lastStatus = newStatus;
	cmp	DWORD PTR 24[rbp], 0	 # newStatus,
	je	.L68	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1532: 		if (newStatus != Ok) lastStatus = newStatus;
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	edx, DWORD PTR 24[rbp]	 # tmp101, newStatus
	mov	DWORD PTR 8[rax], edx	 # this_4(D)->lastStatus, tmp101
.L68:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1533: 		return newStatus;
	mov	eax, DWORD PTR 24[rbp]	 # _6, newStatus
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusgraphics.h:1534: 	}
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus5Image8FromFileEPKwi,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5Image8FromFileEPKwi
	.def	_ZN7Gdiplus5Image8FromFileEPKwi;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5Image8FromFileEPKwi
_ZN7Gdiplus5Image8FromFileEPKwi:
.LFB8414:
	push	rbp	 #
	.seh_pushreg	rbp
	push	rdi	 #
	.seh_pushreg	rdi
	push	rsi	 #
	.seh_pushreg	rsi
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 40	 #,
	.seh_stackalloc	40
	lea	rbp, 32[rsp]	 #,
	.seh_setframe	rbp, 32
	.seh_endprologue
	mov	QWORD PTR 48[rbp], rcx	 # filename, filename
	mov	DWORD PTR 56[rbp], edx	 # useEmbeddedColorManagement, useEmbeddedColorManagement
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:46: 	return new Image(filename, useEmbeddedColorManagement);
	mov	ecx, 24	 #,
.LEHB2:
	call	_ZN7Gdiplus11GdiplusBasenwEy	 #
.LEHE2:
	mov	rbx, rax	 # _4,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:46: 	return new Image(filename, useEmbeddedColorManagement);
	mov	edi, 1	 # _6,
	mov	edx, DWORD PTR 56[rbp]	 # tmp103, useEmbeddedColorManagement
	mov	rax, QWORD PTR 48[rbp]	 # tmp104, filename
	mov	r8d, edx	 #, tmp103
	mov	rdx, rax	 #, tmp104
	mov	rcx, rbx	 #, _4
.LEHB3:
	call	_ZN7Gdiplus5ImageC1EPKwi	 #
.LEHE3:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:46: 	return new Image(filename, useEmbeddedColorManagement);
	mov	eax, 0	 # _10,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:46: 	return new Image(filename, useEmbeddedColorManagement);
	test	al, al	 # _10
	je	.L72	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:46: 	return new Image(filename, useEmbeddedColorManagement);
	mov	rcx, rbx	 #, _4
.LEHB4:
	call	_ZN7Gdiplus11GdiplusBasedlEPv	 #
.LEHE4:
.L72:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:46: 	return new Image(filename, useEmbeddedColorManagement);
	mov	rax, rbx	 # <retval>, _4
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:46: 	return new Image(filename, useEmbeddedColorManagement);
	jmp	.L76	 #
.L75:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:46: 	return new Image(filename, useEmbeddedColorManagement);
	mov	rsi, rax	 # tmp106,
	test	dil, dil	 # _6
	je	.L74	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:46: 	return new Image(filename, useEmbeddedColorManagement);
	mov	rcx, rbx	 #, _4
	call	_ZN7Gdiplus11GdiplusBasedlEPv	 #
.L74:
	mov	rax, rsi	 # D.135074, tmp106
	mov	rcx, rax	 #, D.135074
.LEHB5:
	call	_Unwind_Resume	 #
.LEHE5:
.L76:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:47: }
	add	rsp, 40	 #,
	pop	rbx	 #
	pop	rsi	 #
	pop	rdi	 #
	pop	rbp	 #
	ret	
	.seh_handler	__gxx_personality_seh0, @unwind, @except
	.seh_handlerdata
.LLSDA8414:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8414-.LLSDACSB8414
.LLSDACSB8414:
	.uleb128 .LEHB2-.LFB8414
	.uleb128 .LEHE2-.LEHB2
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB3-.LFB8414
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L75-.LFB8414
	.uleb128 0
	.uleb128 .LEHB4-.LFB8414
	.uleb128 .LEHE4-.LEHB4
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB5-.LFB8414
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
.LLSDACSE8414:
	.section	.text$_ZN7Gdiplus5Image8FromFileEPKwi,"x"
	.linkonce discard
	.seh_endproc
	.section	.text$_ZN7Gdiplus5ImageC1EPKwi,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5ImageC1EPKwi
	.def	_ZN7Gdiplus5ImageC1EPKwi;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5ImageC1EPKwi
_ZN7Gdiplus5ImageC1EPKwi:
.LFB8418:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
	mov	QWORD PTR 24[rbp], rdx	 # filename, filename
	mov	DWORD PTR 32[rbp], r8d	 # useEmbeddedColorManagement, useEmbeddedColorManagement
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:56: 	nativeImage(NULL), lastStatus(Ok)
	lea	rdx, _ZTVN7Gdiplus5ImageE[rip+16]	 # _1,
	mov	rax, QWORD PTR 16[rbp]	 # tmp103, this
	mov	QWORD PTR [rax], rdx	 # this_8(D)->_vptr.Image, _1
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:56: 	nativeImage(NULL), lastStatus(Ok)
	mov	rax, QWORD PTR 16[rbp]	 # tmp104, this
	mov	QWORD PTR 8[rax], 0	 # this_8(D)->nativeImage,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:56: 	nativeImage(NULL), lastStatus(Ok)
	mov	rax, QWORD PTR 16[rbp]	 # tmp105, this
	mov	DWORD PTR 16[rax], 0	 # this_8(D)->lastStatus,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:58: 	if (useEmbeddedColorManagement) {
	cmp	DWORD PTR 32[rbp], 0	 # useEmbeddedColorManagement,
	je	.L78	 #,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:59: 		lastStatus = DllExports::GdipLoadImageFromFileICM(
	mov	rax, QWORD PTR 16[rbp]	 # tmp106, this
	lea	rdx, 8[rax]	 # _2,
	mov	rax, QWORD PTR 24[rbp]	 # tmp107, filename
	mov	rcx, rax	 #, tmp107
	call	GdipLoadImageFromFileICM	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:59: 		lastStatus = DllExports::GdipLoadImageFromFileICM(
	mov	rdx, QWORD PTR 16[rbp]	 # tmp108, this
	mov	DWORD PTR 16[rdx], eax	 # this_8(D)->lastStatus, _3
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:65: }
	jmp	.L80	 #
.L78:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:62: 		lastStatus = DllExports::GdipLoadImageFromFile(
	mov	rax, QWORD PTR 16[rbp]	 # tmp109, this
	lea	rdx, 8[rax]	 # _4,
	mov	rax, QWORD PTR 24[rbp]	 # tmp110, filename
	mov	rcx, rax	 #, tmp110
	call	GdipLoadImageFromFile	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:62: 		lastStatus = DllExports::GdipLoadImageFromFile(
	mov	rdx, QWORD PTR 16[rbp]	 # tmp111, this
	mov	DWORD PTR 16[rdx], eax	 # this_8(D)->lastStatus, _5
.L80:
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:65: }
	nop	
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus5Image9GetHeightEv,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5Image9GetHeightEv
	.def	_ZN7Gdiplus5Image9GetHeightEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5Image9GetHeightEv
_ZN7Gdiplus5Image9GetHeightEv:
.LFB8432:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:152: 	UINT result = 0;
	mov	DWORD PTR -4[rbp], 0	 # result,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:153: 	updateStatus(DllExports::GdipGetImageHeight(nativeImage, &result));
	mov	rax, QWORD PTR 16[rbp]	 # tmp102, this
	mov	rax, QWORD PTR 8[rax]	 # _1, this_5(D)->nativeImage
	lea	rdx, -4[rbp]	 # tmp103,
	mov	rcx, rax	 #, _1
	call	GdipGetImageHeight	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:153: 	updateStatus(DllExports::GdipGetImageHeight(nativeImage, &result));
	mov	rax, QWORD PTR 16[rbp]	 # tmp104, this
	mov	rcx, rax	 #, tmp104
	call	_ZNK7Gdiplus5Image12updateStatusENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:154: 	return result;
	mov	eax, DWORD PTR -4[rbp]	 # _9, result
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:155: }
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus5Image8GetWidthEv,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus5Image8GetWidthEv
	.def	_ZN7Gdiplus5Image8GetWidthEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus5Image8GetWidthEv
_ZN7Gdiplus5Image8GetWidthEv:
.LFB8448:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:277: 	UINT result = 0;
	mov	DWORD PTR -4[rbp], 0	 # result,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:278: 	updateStatus(DllExports::GdipGetImageWidth(nativeImage, &result));
	mov	rax, QWORD PTR 16[rbp]	 # tmp102, this
	mov	rax, QWORD PTR 8[rax]	 # _1, this_5(D)->nativeImage
	lea	rdx, -4[rbp]	 # tmp103,
	mov	rcx, rax	 #, _1
	call	GdipGetImageWidth	 #
	mov	edx, eax	 # _2,
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:278: 	updateStatus(DllExports::GdipGetImageWidth(nativeImage, &result));
	mov	rax, QWORD PTR 16[rbp]	 # tmp104, this
	mov	rcx, rax	 #, tmp104
	call	_ZNK7Gdiplus5Image12updateStatusENS_8GpStatusE	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:279: 	return result;
	mov	eax, DWORD PTR -4[rbp]	 # _9, result
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusimpl.h:280: }
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.globl	hdcBackBuffer
	.bss
	.align 8
hdcBackBuffer:
	.space 8
	.globl	hbmBackBuffer
	.align 8
hbmBackBuffer:
	.space 8
	.globl	gdiplusToken
	.align 8
gdiplusToken:
	.space 8
	.globl	imgBackground
	.align 8
imgBackground:
	.space 8
	.globl	imgGround
	.align 8
imgGround:
	.space 8
	.globl	imgPipeGreen
	.align 8
imgPipeGreen:
	.space 8
	.globl	imgBirdFrames
	.align 16
imgBirdFrames:
	.space 24
	.globl	imgNumbers
	.align 32
imgNumbers:
	.space 80
	.globl	imgGameOver
	.align 8
imgGameOver:
	.space 8
	.globl	imgMessage
	.align 8
imgMessage:
	.space 8
	.section .rdata,"dr"
.LC0:
	.ascii "PLATINUM\0"
.LC1:
	.ascii "GOLD\0"
.LC2:
	.ascii "SILVER\0"
.LC3:
	.ascii "BRONZE\0"
	.text
	.globl	_Z12GetMedalTexti
	.def	_Z12GetMedalTexti;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z12GetMedalTexti
_Z12GetMedalTexti:
.LFB8687:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	DWORD PTR 16[rbp], ecx	 # score, score
 # src/render.c:21:     if (score >= 40) return "PLATINUM";
	cmp	DWORD PTR 16[rbp], 39	 # score,
	jle	.L86	 #,
 # src/render.c:21:     if (score >= 40) return "PLATINUM";
	lea	rax, .LC0[rip]	 # _1,
 # src/render.c:21:     if (score >= 40) return "PLATINUM";
	jmp	.L87	 #
.L86:
 # src/render.c:22:     if (score >= 30) return "GOLD";
	cmp	DWORD PTR 16[rbp], 29	 # score,
	jle	.L88	 #,
 # src/render.c:22:     if (score >= 30) return "GOLD";
	lea	rax, .LC1[rip]	 # _1,
 # src/render.c:22:     if (score >= 30) return "GOLD";
	jmp	.L87	 #
.L88:
 # src/render.c:23:     if (score >= 20) return "SILVER";
	cmp	DWORD PTR 16[rbp], 19	 # score,
	jle	.L89	 #,
 # src/render.c:23:     if (score >= 20) return "SILVER";
	lea	rax, .LC2[rip]	 # _1,
 # src/render.c:23:     if (score >= 20) return "SILVER";
	jmp	.L87	 #
.L89:
 # src/render.c:24:     if (score >= 10) return "BRONZE";
	cmp	DWORD PTR 16[rbp], 9	 # score,
	jle	.L90	 #,
 # src/render.c:24:     if (score >= 10) return "BRONZE";
	lea	rax, .LC3[rip]	 # _1,
 # src/render.c:24:     if (score >= 10) return "BRONZE";
	jmp	.L87	 #
.L90:
 # src/render.c:25:     return NULL;
	mov	eax, 0	 # _1,
.L87:
 # src/render.c:26: }
	pop	rbp	 #
	ret	
	.seh_endproc
	.globl	_Z13GetMedalColori
	.def	_Z13GetMedalColori;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z13GetMedalColori
_Z13GetMedalColori:
.LFB8688:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	DWORD PTR 16[rbp], ecx	 # score, score
 # src/render.c:30:     if (score >= 40) return RGB(229, 228, 226);
	cmp	DWORD PTR 16[rbp], 39	 # score,
	jle	.L92	 #,
 # src/render.c:30:     if (score >= 40) return RGB(229, 228, 226);
	mov	eax, 14869733	 # _1,
 # src/render.c:30:     if (score >= 40) return RGB(229, 228, 226);
	jmp	.L93	 #
.L92:
 # src/render.c:31:     if (score >= 30) return RGB(255, 215, 0);
	cmp	DWORD PTR 16[rbp], 29	 # score,
	jle	.L94	 #,
 # src/render.c:31:     if (score >= 30) return RGB(255, 215, 0);
	mov	eax, 55295	 # _1,
 # src/render.c:31:     if (score >= 30) return RGB(255, 215, 0);
	jmp	.L93	 #
.L94:
 # src/render.c:32:     if (score >= 20) return RGB(192, 192, 192);
	cmp	DWORD PTR 16[rbp], 19	 # score,
	jle	.L95	 #,
 # src/render.c:32:     if (score >= 20) return RGB(192, 192, 192);
	mov	eax, 12632256	 # _1,
 # src/render.c:32:     if (score >= 20) return RGB(192, 192, 192);
	jmp	.L93	 #
.L95:
 # src/render.c:33:     if (score >= 10) return RGB(205, 127, 50);
	cmp	DWORD PTR 16[rbp], 9	 # score,
	jle	.L96	 #,
 # src/render.c:33:     if (score >= 10) return RGB(205, 127, 50);
	mov	eax, 3309517	 # _1,
 # src/render.c:33:     if (score >= 10) return RGB(205, 127, 50);
	jmp	.L93	 #
.L96:
 # src/render.c:34:     return RGB(255, 255, 255);
	mov	eax, 16777215	 # _1,
.L93:
 # src/render.c:35: }
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC4:
	.ascii "a\0s\0s\0e\0t\0s\0/\0s\0p\0r\0i\0t\0e\0s\0_\0d\0e\0s\0k\0t\0o\0p\0/\0b\0a\0c\0k\0g\0r\0o\0u\0n\0d\0-\0d\0a\0y\0.\0p\0n\0g\0\0\0"
	.align 8
.LC5:
	.ascii "a\0s\0s\0e\0t\0s\0/\0s\0p\0r\0i\0t\0e\0s\0_\0d\0e\0s\0k\0t\0o\0p\0/\0b\0a\0s\0e\0.\0p\0n\0g\0\0\0"
	.align 8
.LC6:
	.ascii "a\0s\0s\0e\0t\0s\0/\0s\0p\0r\0i\0t\0e\0s\0_\0d\0e\0s\0k\0t\0o\0p\0/\0p\0i\0p\0e\0-\0g\0r\0e\0e\0n\0.\0p\0n\0g\0\0\0"
	.align 8
.LC7:
	.ascii "a\0s\0s\0e\0t\0s\0/\0s\0p\0r\0i\0t\0e\0s\0_\0d\0e\0s\0k\0t\0o\0p\0/\0y\0e\0l\0l\0o\0w\0b\0i\0r\0d\0-\0d\0o\0w\0n\0f\0l\0a\0p\0.\0p\0n\0g\0\0\0"
	.align 8
.LC8:
	.ascii "a\0s\0s\0e\0t\0s\0/\0s\0p\0r\0i\0t\0e\0s\0_\0d\0e\0s\0k\0t\0o\0p\0/\0y\0e\0l\0l\0o\0w\0b\0i\0r\0d\0-\0m\0i\0d\0f\0l\0a\0p\0.\0p\0n\0g\0\0\0"
	.align 8
.LC9:
	.ascii "a\0s\0s\0e\0t\0s\0/\0s\0p\0r\0i\0t\0e\0s\0_\0d\0e\0s\0k\0t\0o\0p\0/\0y\0e\0l\0l\0o\0w\0b\0i\0r\0d\0-\0u\0p\0f\0l\0a\0p\0.\0p\0n\0g\0\0\0"
	.align 8
.LC10:
	.ascii "a\0s\0s\0e\0t\0s\0/\0s\0p\0r\0i\0t\0e\0s\0_\0d\0e\0s\0k\0t\0o\0p\0/\0%\0d\0.\0p\0n\0g\0\0\0"
	.align 8
.LC11:
	.ascii "a\0s\0s\0e\0t\0s\0/\0s\0p\0r\0i\0t\0e\0s\0_\0d\0e\0s\0k\0t\0o\0p\0/\0g\0a\0m\0e\0o\0v\0e\0r\0.\0p\0n\0g\0\0\0"
	.align 8
.LC12:
	.ascii "a\0s\0s\0e\0t\0s\0/\0s\0p\0r\0i\0t\0e\0s\0_\0d\0e\0s\0k\0t\0o\0p\0/\0m\0e\0s\0s\0a\0g\0e\0.\0p\0n\0g\0\0\0"
	.text
	.globl	_Z10LoadImagesv
	.def	_Z10LoadImagesv;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10LoadImagesv
_Z10LoadImagesv:
.LFB8689:
	push	rbp	 #
	.seh_pushreg	rbp
	sub	rsp, 560	 #,
	.seh_stackalloc	560
	lea	rbp, 128[rsp]	 #,
	.seh_setframe	rbp, 128
	.seh_endprologue
 # src/render.c:39:     imgBackground = Image::FromFile(L"assets/sprites_desktop/background-day.png");
	lea	rax, .LC4[rip]	 # tmp137,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp137
	call	_ZN7Gdiplus5Image8FromFileEPKwi	 #
 # src/render.c:39:     imgBackground = Image::FromFile(L"assets/sprites_desktop/background-day.png");
	mov	QWORD PTR imgBackground[rip], rax	 # imgBackground, _1
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgBackground[rip]	 # imgBackground.2_2, imgBackground
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	test	rax, rax	 # imgBackground.2_2
	je	.L98	 #,
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgBackground[rip]	 # imgBackground.3_3, imgBackground
	mov	rcx, rax	 #, imgBackground.3_3
	call	_ZNK7Gdiplus5Image13GetLastStatusEv	 #
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	test	eax, eax	 # _4
	je	.L99	 #,
.L98:
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	mov	eax, 1	 # iftmp.1_33,
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	jmp	.L100	 #
.L99:
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # iftmp.1_33,
.L100:
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	test	al, al	 # iftmp.1_33
	je	.L101	 #,
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # _34,
 # src/render.c:40:     if (!imgBackground || imgBackground->GetLastStatus() != Ok) return FALSE;
	jmp	.L131	 #
.L101:
 # src/render.c:42:     imgGround = Image::FromFile(L"assets/sprites_desktop/base.png");
	lea	rax, .LC5[rip]	 # tmp138,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp138
	call	_ZN7Gdiplus5Image8FromFileEPKwi	 #
 # src/render.c:42:     imgGround = Image::FromFile(L"assets/sprites_desktop/base.png");
	mov	QWORD PTR imgGround[rip], rax	 # imgGround, _5
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgGround[rip]	 # imgGround.6_6, imgGround
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	test	rax, rax	 # imgGround.6_6
	je	.L103	 #,
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgGround[rip]	 # imgGround.7_7, imgGround
	mov	rcx, rax	 #, imgGround.7_7
	call	_ZNK7Gdiplus5Image13GetLastStatusEv	 #
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	test	eax, eax	 # _8
	je	.L104	 #,
.L103:
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	mov	eax, 1	 # iftmp.5_35,
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	jmp	.L105	 #
.L104:
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # iftmp.5_35,
.L105:
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	test	al, al	 # iftmp.5_35
	je	.L106	 #,
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # _34,
 # src/render.c:43:     if (!imgGround || imgGround->GetLastStatus() != Ok) return FALSE;
	jmp	.L131	 #
.L106:
 # src/render.c:45:     imgPipeGreen = Image::FromFile(L"assets/sprites_desktop/pipe-green.png");
	lea	rax, .LC6[rip]	 # tmp139,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp139
	call	_ZN7Gdiplus5Image8FromFileEPKwi	 #
 # src/render.c:45:     imgPipeGreen = Image::FromFile(L"assets/sprites_desktop/pipe-green.png");
	mov	QWORD PTR imgPipeGreen[rip], rax	 # imgPipeGreen, _9
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.10_10, imgPipeGreen
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	test	rax, rax	 # imgPipeGreen.10_10
	je	.L107	 #,
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.11_11, imgPipeGreen
	mov	rcx, rax	 #, imgPipeGreen.11_11
	call	_ZNK7Gdiplus5Image13GetLastStatusEv	 #
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	test	eax, eax	 # _12
	je	.L108	 #,
.L107:
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	mov	eax, 1	 # iftmp.9_36,
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	jmp	.L109	 #
.L108:
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # iftmp.9_36,
.L109:
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	test	al, al	 # iftmp.9_36
	je	.L110	 #,
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # _34,
 # src/render.c:46:     if (!imgPipeGreen || imgPipeGreen->GetLastStatus() != Ok) return FALSE;
	jmp	.L131	 #
.L110:
 # src/render.c:48:     imgBirdFrames[0] = Image::FromFile(L"assets/sprites_desktop/yellowbird-downflap.png");
	lea	rax, .LC7[rip]	 # tmp140,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp140
	call	_ZN7Gdiplus5Image8FromFileEPKwi	 #
 # src/render.c:48:     imgBirdFrames[0] = Image::FromFile(L"assets/sprites_desktop/yellowbird-downflap.png");
	mov	QWORD PTR imgBirdFrames[rip], rax	 # imgBirdFrames[0], _13
 # src/render.c:49:     imgBirdFrames[1] = Image::FromFile(L"assets/sprites_desktop/yellowbird-midflap.png");
	lea	rax, .LC8[rip]	 # tmp141,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp141
	call	_ZN7Gdiplus5Image8FromFileEPKwi	 #
 # src/render.c:49:     imgBirdFrames[1] = Image::FromFile(L"assets/sprites_desktop/yellowbird-midflap.png");
	mov	QWORD PTR imgBirdFrames[rip+8], rax	 # imgBirdFrames[1], _14
 # src/render.c:50:     imgBirdFrames[2] = Image::FromFile(L"assets/sprites_desktop/yellowbird-upflap.png");
	lea	rax, .LC9[rip]	 # tmp142,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp142
	call	_ZN7Gdiplus5Image8FromFileEPKwi	 #
 # src/render.c:50:     imgBirdFrames[2] = Image::FromFile(L"assets/sprites_desktop/yellowbird-upflap.png");
	mov	QWORD PTR imgBirdFrames[rip+16], rax	 # imgBirdFrames[2], _15
 # src/render.c:51:     for (int i = 0; i < 3; i++) {
	mov	DWORD PTR 428[rbp], 0	 # i,
 # src/render.c:51:     for (int i = 0; i < 3; i++) {
	jmp	.L111	 #
.L116:
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, DWORD PTR 428[rbp]	 # tmp144, i
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp145,
	lea	rax, imgBirdFrames[rip]	 # tmp146,
	mov	rax, QWORD PTR [rdx+rax]	 # _16, imgBirdFrames[i_31]
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	test	rax, rax	 # _16
	je	.L112	 #,
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, DWORD PTR 428[rbp]	 # tmp148, i
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp149,
	lea	rax, imgBirdFrames[rip]	 # tmp150,
	mov	rax, QWORD PTR [rdx+rax]	 # _17, imgBirdFrames[i_31]
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	mov	rcx, rax	 #, _17
	call	_ZNK7Gdiplus5Image13GetLastStatusEv	 #
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	test	eax, eax	 # _18
	je	.L113	 #,
.L112:
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, 1	 # iftmp.13_37,
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	jmp	.L114	 #
.L113:
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # iftmp.13_37,
.L114:
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	test	al, al	 # iftmp.13_37
	je	.L115	 #,
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # _34,
 # src/render.c:52:         if (!imgBirdFrames[i] || imgBirdFrames[i]->GetLastStatus() != Ok) return FALSE;
	jmp	.L131	 #
.L115:
 # src/render.c:51:     for (int i = 0; i < 3; i++) {
	add	DWORD PTR 428[rbp], 1	 # i,
.L111:
 # src/render.c:51:     for (int i = 0; i < 3; i++) {
	cmp	DWORD PTR 428[rbp], 2	 # i,
	jle	.L116	 #,
 # src/render.c:56:     for (int i = 0; i < 10; i++) {
	mov	DWORD PTR 424[rbp], 0	 # i,
 # src/render.c:56:     for (int i = 0; i < 10; i++) {
	jmp	.L117	 #
.L122:
 # src/render.c:57:         swprintf(numPath, 256, L"assets/sprites_desktop/%d.png", i);
	mov	edx, DWORD PTR 424[rbp]	 # tmp151, i
	lea	rcx, .LC10[rip]	 # tmp152,
	lea	rax, -96[rbp]	 # tmp153,
	mov	r9d, edx	 #, tmp151
	mov	r8, rcx	 #, tmp152
	mov	edx, 256	 #,
	mov	rcx, rax	 #, tmp153
	call	__mingw_swprintf	 #
 # src/render.c:58:         imgNumbers[i] = Image::FromFile(numPath);
	lea	rax, -96[rbp]	 # tmp154,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp154
	call	_ZN7Gdiplus5Image8FromFileEPKwi	 #
 # src/render.c:58:         imgNumbers[i] = Image::FromFile(numPath);
	mov	edx, DWORD PTR 424[rbp]	 # tmp156, i
	movsx	rdx, edx	 # tmp155, tmp156
	lea	rcx, 0[0+rdx*8]	 # tmp157,
	lea	rdx, imgNumbers[rip]	 # tmp158,
	mov	QWORD PTR [rcx+rdx], rax	 # imgNumbers[i_32], _19
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, DWORD PTR 424[rbp]	 # tmp160, i
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp161,
	lea	rax, imgNumbers[rip]	 # tmp162,
	mov	rax, QWORD PTR [rdx+rax]	 # _20, imgNumbers[i_32]
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	test	rax, rax	 # _20
	je	.L118	 #,
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, DWORD PTR 424[rbp]	 # tmp164, i
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp165,
	lea	rax, imgNumbers[rip]	 # tmp166,
	mov	rax, QWORD PTR [rdx+rax]	 # _21, imgNumbers[i_32]
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	mov	rcx, rax	 #, _21
	call	_ZNK7Gdiplus5Image13GetLastStatusEv	 #
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	test	eax, eax	 # _22
	je	.L119	 #,
.L118:
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, 1	 # iftmp.15_38,
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	jmp	.L120	 #
.L119:
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # iftmp.15_38,
.L120:
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	test	al, al	 # iftmp.15_38
	je	.L121	 #,
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # _34,
 # src/render.c:59:         if (!imgNumbers[i] || imgNumbers[i]->GetLastStatus() != Ok) return FALSE;
	jmp	.L131	 #
.L121:
 # src/render.c:56:     for (int i = 0; i < 10; i++) {
	add	DWORD PTR 424[rbp], 1	 # i,
.L117:
 # src/render.c:56:     for (int i = 0; i < 10; i++) {
	cmp	DWORD PTR 424[rbp], 9	 # i,
	jle	.L122	 #,
 # src/render.c:62:     imgGameOver = Image::FromFile(L"assets/sprites_desktop/gameover.png");
	lea	rax, .LC11[rip]	 # tmp167,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp167
	call	_ZN7Gdiplus5Image8FromFileEPKwi	 #
 # src/render.c:62:     imgGameOver = Image::FromFile(L"assets/sprites_desktop/gameover.png");
	mov	QWORD PTR imgGameOver[rip], rax	 # imgGameOver, _23
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgGameOver[rip]	 # imgGameOver.18_24, imgGameOver
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	test	rax, rax	 # imgGameOver.18_24
	je	.L123	 #,
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgGameOver[rip]	 # imgGameOver.19_25, imgGameOver
	mov	rcx, rax	 #, imgGameOver.19_25
	call	_ZNK7Gdiplus5Image13GetLastStatusEv	 #
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	test	eax, eax	 # _26
	je	.L124	 #,
.L123:
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	mov	eax, 1	 # iftmp.17_39,
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	jmp	.L125	 #
.L124:
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # iftmp.17_39,
.L125:
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	test	al, al	 # iftmp.17_39
	je	.L126	 #,
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # _34,
 # src/render.c:63:     if (!imgGameOver || imgGameOver->GetLastStatus() != Ok) return FALSE;
	jmp	.L131	 #
.L126:
 # src/render.c:65:     imgMessage = Image::FromFile(L"assets/sprites_desktop/message.png");
	lea	rax, .LC12[rip]	 # tmp168,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp168
	call	_ZN7Gdiplus5Image8FromFileEPKwi	 #
 # src/render.c:65:     imgMessage = Image::FromFile(L"assets/sprites_desktop/message.png");
	mov	QWORD PTR imgMessage[rip], rax	 # imgMessage, _27
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgMessage[rip]	 # imgMessage.22_28, imgMessage
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	test	rax, rax	 # imgMessage.22_28
	je	.L127	 #,
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	mov	rax, QWORD PTR imgMessage[rip]	 # imgMessage.23_29, imgMessage
	mov	rcx, rax	 #, imgMessage.23_29
	call	_ZNK7Gdiplus5Image13GetLastStatusEv	 #
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	test	eax, eax	 # _30
	je	.L128	 #,
.L127:
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	mov	eax, 1	 # iftmp.21_40,
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	jmp	.L129	 #
.L128:
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # iftmp.21_40,
.L129:
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	test	al, al	 # iftmp.21_40
	je	.L130	 #,
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	mov	eax, 0	 # _34,
 # src/render.c:66:     if (!imgMessage || imgMessage->GetLastStatus() != Ok) return FALSE;
	jmp	.L131	 #
.L130:
 # src/render.c:68:     return TRUE;
	mov	eax, 1	 # _34,
.L131:
 # src/render.c:69: }
	add	rsp, 560	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
.LC13:
	.ascii "Error\0"
	.align 8
.LC14:
	.ascii "Failed to load game sprites!\12Make sure assets/sprites_desktop folder exists.\0"
	.text
	.globl	_Z12InitGraphicsP6HWND__
	.def	_Z12InitGraphicsP6HWND__;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z12InitGraphicsP6HWND__
_Z12InitGraphicsP6HWND__:
.LFB8690:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 64	 #,
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # hwnd, hwnd
 # src/render.c:72:     GdiplusStartupInput gdiplusStartupInput;
	lea	rax, -32[rbp]	 # tmp105,
	mov	r9d, 0	 #,
	mov	r8d, 0	 #,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp105
	call	_ZN7Gdiplus19GdiplusStartupInputC1EPvii	 #
 # src/render.c:73:     GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);
	lea	rax, -32[rbp]	 # tmp106,
	lea	rcx, gdiplusToken[rip]	 # tmp107,
	mov	r8d, 0	 #,
	mov	rdx, rax	 #, tmp106
	call	GdiplusStartup	 #
 # src/render.c:75:     HDC hdc = GetDC(hwnd);
	mov	rax, QWORD PTR 16[rbp]	 # tmp108, hwnd
	mov	rcx, rax	 #, tmp108
	mov	rax, QWORD PTR __imp_GetDC[rip]	 # tmp109,
	call	rax	 # tmp109
 # src/render.c:75:     HDC hdc = GetDC(hwnd);
	mov	QWORD PTR -8[rbp], rax	 # hdc, _13
 # src/render.c:76:     hdcBackBuffer = CreateCompatibleDC(hdc);
	mov	rax, QWORD PTR -8[rbp]	 # tmp110, hdc
	mov	rcx, rax	 #, tmp110
	mov	rax, QWORD PTR __imp_CreateCompatibleDC[rip]	 # tmp111,
	call	rax	 # tmp111
 # src/render.c:76:     hdcBackBuffer = CreateCompatibleDC(hdc);
	mov	QWORD PTR hdcBackBuffer[rip], rax	 # hdcBackBuffer, _1
 # src/render.c:77:     hbmBackBuffer = CreateCompatibleBitmap(hdc, WINDOW_WIDTH, WINDOW_HEIGHT);
	mov	rax, QWORD PTR -8[rbp]	 # tmp112, hdc
	mov	r8d, 720	 #,
	mov	edx, 1280	 #,
	mov	rcx, rax	 #, tmp112
	mov	rax, QWORD PTR __imp_CreateCompatibleBitmap[rip]	 # tmp113,
	call	rax	 # tmp113
 # src/render.c:77:     hbmBackBuffer = CreateCompatibleBitmap(hdc, WINDOW_WIDTH, WINDOW_HEIGHT);
	mov	QWORD PTR hbmBackBuffer[rip], rax	 # hbmBackBuffer, _2
 # src/render.c:78:     SelectObject(hdcBackBuffer, hbmBackBuffer);
	mov	rdx, QWORD PTR hbmBackBuffer[rip]	 # hbmBackBuffer.26_3, hbmBackBuffer
	mov	rax, QWORD PTR hdcBackBuffer[rip]	 # hdcBackBuffer.27_4, hdcBackBuffer
	mov	rcx, rax	 #, hdcBackBuffer.27_4
	mov	rax, QWORD PTR __imp_SelectObject[rip]	 # tmp114,
	call	rax	 # tmp114
 # src/render.c:79:     ReleaseDC(hwnd, hdc);
	mov	rdx, QWORD PTR -8[rbp]	 # tmp115, hdc
	mov	rax, QWORD PTR 16[rbp]	 # tmp116, hwnd
	mov	rcx, rax	 #, tmp116
	mov	rax, QWORD PTR __imp_ReleaseDC[rip]	 # tmp117,
	call	rax	 # tmp117
 # src/render.c:81:     if (!LoadImages()) {
	call	_Z10LoadImagesv	 #
 # src/render.c:81:     if (!LoadImages()) {
	test	eax, eax	 # _5
	sete	al	 #, retval.28_25
 # src/render.c:81:     if (!LoadImages()) {
	test	al, al	 # retval.28_25
	je	.L134	 #,
 # src/render.c:82:         MessageBox(hwnd, "Failed to load game sprites!\nMake sure assets/sprites_desktop folder exists.", "Error", MB_ICONERROR);
	lea	rcx, .LC13[rip]	 # tmp118,
	lea	rdx, .LC14[rip]	 # tmp119,
	mov	rax, QWORD PTR 16[rbp]	 # tmp120, hwnd
	mov	r9d, 16	 #,
	mov	r8, rcx	 #, tmp118
	mov	rcx, rax	 #, tmp120
	mov	rax, QWORD PTR __imp_MessageBoxA[rip]	 # tmp121,
	call	rax	 # tmp121
.L134:
 # src/render.c:84: }
	nop	
	add	rsp, 64	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.globl	_Z15CleanupGraphicsv
	.def	_Z15CleanupGraphicsv;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z15CleanupGraphicsv
_Z15CleanupGraphicsv:
.LFB8691:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 48	 #,
	.seh_stackalloc	48
	.seh_endprologue
 # src/render.c:87:     if (imgBackground) delete imgBackground;
	mov	rax, QWORD PTR imgBackground[rip]	 # imgBackground.29_1, imgBackground
 # src/render.c:87:     if (imgBackground) delete imgBackground;
	test	rax, rax	 # imgBackground.29_1
	je	.L136	 #,
 # src/render.c:87:     if (imgBackground) delete imgBackground;
	mov	rax, QWORD PTR imgBackground[rip]	 # _44, imgBackground
	test	rax, rax	 # _44
	je	.L136	 #,
 # src/render.c:87:     if (imgBackground) delete imgBackground;
	mov	rdx, QWORD PTR [rax]	 # _2, _44->_vptr.Image
	add	rdx, 8	 # _3,
	mov	rdx, QWORD PTR [rdx]	 # _4, *_3
	mov	rcx, rax	 #, _44
	call	rdx	 # _4
.L136:
 # src/render.c:88:     if (imgGround) delete imgGround;
	mov	rax, QWORD PTR imgGround[rip]	 # imgGround.30_5, imgGround
 # src/render.c:88:     if (imgGround) delete imgGround;
	test	rax, rax	 # imgGround.30_5
	je	.L137	 #,
 # src/render.c:88:     if (imgGround) delete imgGround;
	mov	rax, QWORD PTR imgGround[rip]	 # _46, imgGround
	test	rax, rax	 # _46
	je	.L137	 #,
 # src/render.c:88:     if (imgGround) delete imgGround;
	mov	rdx, QWORD PTR [rax]	 # _6, _46->_vptr.Image
	add	rdx, 8	 # _7,
	mov	rdx, QWORD PTR [rdx]	 # _8, *_7
	mov	rcx, rax	 #, _46
	call	rdx	 # _8
.L137:
 # src/render.c:89:     if (imgPipeGreen) delete imgPipeGreen;
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.31_9, imgPipeGreen
 # src/render.c:89:     if (imgPipeGreen) delete imgPipeGreen;
	test	rax, rax	 # imgPipeGreen.31_9
	je	.L138	 #,
 # src/render.c:89:     if (imgPipeGreen) delete imgPipeGreen;
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # _48, imgPipeGreen
	test	rax, rax	 # _48
	je	.L138	 #,
 # src/render.c:89:     if (imgPipeGreen) delete imgPipeGreen;
	mov	rdx, QWORD PTR [rax]	 # _10, _48->_vptr.Image
	add	rdx, 8	 # _11,
	mov	rdx, QWORD PTR [rdx]	 # _12, *_11
	mov	rcx, rax	 #, _48
	call	rdx	 # _12
.L138:
 # src/render.c:90:     for (int i = 0; i < 3; i++) if (imgBirdFrames[i]) delete imgBirdFrames[i];
	mov	DWORD PTR -4[rbp], 0	 # i,
 # src/render.c:90:     for (int i = 0; i < 3; i++) if (imgBirdFrames[i]) delete imgBirdFrames[i];
	jmp	.L139	 #
.L141:
 # src/render.c:90:     for (int i = 0; i < 3; i++) if (imgBirdFrames[i]) delete imgBirdFrames[i];
	mov	eax, DWORD PTR -4[rbp]	 # tmp137, i
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp138,
	lea	rax, imgBirdFrames[rip]	 # tmp139,
	mov	rax, QWORD PTR [rdx+rax]	 # _13, imgBirdFrames[i_32]
 # src/render.c:90:     for (int i = 0; i < 3; i++) if (imgBirdFrames[i]) delete imgBirdFrames[i];
	test	rax, rax	 # _13
	je	.L140	 #,
 # src/render.c:90:     for (int i = 0; i < 3; i++) if (imgBirdFrames[i]) delete imgBirdFrames[i];
	mov	eax, DWORD PTR -4[rbp]	 # tmp141, i
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp142,
	lea	rax, imgBirdFrames[rip]	 # tmp143,
	mov	rax, QWORD PTR [rdx+rax]	 # _62, imgBirdFrames[i_32]
	test	rax, rax	 # _62
	je	.L140	 #,
 # src/render.c:90:     for (int i = 0; i < 3; i++) if (imgBirdFrames[i]) delete imgBirdFrames[i];
	mov	rdx, QWORD PTR [rax]	 # _14, _62->_vptr.Image
	add	rdx, 8	 # _15,
	mov	rdx, QWORD PTR [rdx]	 # _16, *_15
	mov	rcx, rax	 #, _62
	call	rdx	 # _16
.L140:
 # src/render.c:90:     for (int i = 0; i < 3; i++) if (imgBirdFrames[i]) delete imgBirdFrames[i];
	add	DWORD PTR -4[rbp], 1	 # i,
.L139:
 # src/render.c:90:     for (int i = 0; i < 3; i++) if (imgBirdFrames[i]) delete imgBirdFrames[i];
	cmp	DWORD PTR -4[rbp], 2	 # i,
	jle	.L141	 #,
 # src/render.c:91:     for (int i = 0; i < 10; i++) if (imgNumbers[i]) delete imgNumbers[i];
	mov	DWORD PTR -8[rbp], 0	 # i,
 # src/render.c:91:     for (int i = 0; i < 10; i++) if (imgNumbers[i]) delete imgNumbers[i];
	jmp	.L142	 #
.L144:
 # src/render.c:91:     for (int i = 0; i < 10; i++) if (imgNumbers[i]) delete imgNumbers[i];
	mov	eax, DWORD PTR -8[rbp]	 # tmp145, i
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp146,
	lea	rax, imgNumbers[rip]	 # tmp147,
	mov	rax, QWORD PTR [rdx+rax]	 # _17, imgNumbers[i_33]
 # src/render.c:91:     for (int i = 0; i < 10; i++) if (imgNumbers[i]) delete imgNumbers[i];
	test	rax, rax	 # _17
	je	.L143	 #,
 # src/render.c:91:     for (int i = 0; i < 10; i++) if (imgNumbers[i]) delete imgNumbers[i];
	mov	eax, DWORD PTR -8[rbp]	 # tmp149, i
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp150,
	lea	rax, imgNumbers[rip]	 # tmp151,
	mov	rax, QWORD PTR [rdx+rax]	 # _59, imgNumbers[i_33]
	test	rax, rax	 # _59
	je	.L143	 #,
 # src/render.c:91:     for (int i = 0; i < 10; i++) if (imgNumbers[i]) delete imgNumbers[i];
	mov	rdx, QWORD PTR [rax]	 # _18, _59->_vptr.Image
	add	rdx, 8	 # _19,
	mov	rdx, QWORD PTR [rdx]	 # _20, *_19
	mov	rcx, rax	 #, _59
	call	rdx	 # _20
.L143:
 # src/render.c:91:     for (int i = 0; i < 10; i++) if (imgNumbers[i]) delete imgNumbers[i];
	add	DWORD PTR -8[rbp], 1	 # i,
.L142:
 # src/render.c:91:     for (int i = 0; i < 10; i++) if (imgNumbers[i]) delete imgNumbers[i];
	cmp	DWORD PTR -8[rbp], 9	 # i,
	jle	.L144	 #,
 # src/render.c:92:     if (imgGameOver) delete imgGameOver;
	mov	rax, QWORD PTR imgGameOver[rip]	 # imgGameOver.32_21, imgGameOver
 # src/render.c:92:     if (imgGameOver) delete imgGameOver;
	test	rax, rax	 # imgGameOver.32_21
	je	.L145	 #,
 # src/render.c:92:     if (imgGameOver) delete imgGameOver;
	mov	rax, QWORD PTR imgGameOver[rip]	 # _52, imgGameOver
	test	rax, rax	 # _52
	je	.L145	 #,
 # src/render.c:92:     if (imgGameOver) delete imgGameOver;
	mov	rdx, QWORD PTR [rax]	 # _22, _52->_vptr.Image
	add	rdx, 8	 # _23,
	mov	rdx, QWORD PTR [rdx]	 # _24, *_23
	mov	rcx, rax	 #, _52
	call	rdx	 # _24
.L145:
 # src/render.c:93:     if (imgMessage) delete imgMessage;
	mov	rax, QWORD PTR imgMessage[rip]	 # imgMessage.33_25, imgMessage
 # src/render.c:93:     if (imgMessage) delete imgMessage;
	test	rax, rax	 # imgMessage.33_25
	je	.L146	 #,
 # src/render.c:93:     if (imgMessage) delete imgMessage;
	mov	rax, QWORD PTR imgMessage[rip]	 # _54, imgMessage
	test	rax, rax	 # _54
	je	.L146	 #,
 # src/render.c:93:     if (imgMessage) delete imgMessage;
	mov	rdx, QWORD PTR [rax]	 # _26, _54->_vptr.Image
	add	rdx, 8	 # _27,
	mov	rdx, QWORD PTR [rdx]	 # _28, *_27
	mov	rcx, rax	 #, _54
	call	rdx	 # _28
.L146:
 # src/render.c:95:     DeleteObject(hbmBackBuffer);
	mov	rax, QWORD PTR hbmBackBuffer[rip]	 # hbmBackBuffer.34_29, hbmBackBuffer
	mov	rcx, rax	 #, hbmBackBuffer.34_29
	mov	rax, QWORD PTR __imp_DeleteObject[rip]	 # tmp152,
	call	rax	 # tmp152
 # src/render.c:96:     DeleteDC(hdcBackBuffer);
	mov	rax, QWORD PTR hdcBackBuffer[rip]	 # hdcBackBuffer.35_30, hdcBackBuffer
	mov	rcx, rax	 #, hdcBackBuffer.35_30
	mov	rax, QWORD PTR __imp_DeleteDC[rip]	 # tmp153,
	call	rax	 # tmp153
 # src/render.c:97:     GdiplusShutdown(gdiplusToken);
	mov	rax, QWORD PTR gdiplusToken[rip]	 # gdiplusToken.36_31, gdiplusToken
	mov	rcx, rax	 #, gdiplusToken.36_31
	call	GdiplusShutdown	 #
 # src/render.c:98: }
	nop	
	add	rsp, 48	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus10SolidBrushD1Ev,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus10SolidBrushD1Ev
	.def	_ZN7Gdiplus10SolidBrushD1Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus10SolidBrushD1Ev
_ZN7Gdiplus10SolidBrushD1Ev:
.LFB8695:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:402: class SolidBrush: public Brush
	lea	rdx, _ZTVN7Gdiplus10SolidBrushE[rip+16]	 # _1,
	mov	rax, QWORD PTR 16[rbp]	 # tmp100, this
	mov	QWORD PTR [rax], rdx	 # this_4(D)->D.125025._vptr.Brush, _1
	mov	rax, QWORD PTR 16[rbp]	 # _2, this
	mov	rcx, rax	 #, _2
	call	_ZN7Gdiplus5BrushD2Ev	 #
	nop	
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.section	.text$_ZN7Gdiplus10SolidBrushD0Ev,"x"
	.linkonce discard
	.align 2
	.globl	_ZN7Gdiplus10SolidBrushD0Ev
	.def	_ZN7Gdiplus10SolidBrushD0Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN7Gdiplus10SolidBrushD0Ev
_ZN7Gdiplus10SolidBrushD0Ev:
.LFB8696:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 32	 #,
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # this, this
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:402: class SolidBrush: public Brush
	mov	rax, QWORD PTR 16[rbp]	 # tmp98, this
	mov	rcx, rax	 #, tmp98
	call	_ZN7Gdiplus10SolidBrushD1Ev	 #
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:402: class SolidBrush: public Brush
	mov	rax, QWORD PTR 16[rbp]	 # tmp99, this
	mov	rcx, rax	 #, tmp99
	call	_ZN7Gdiplus11GdiplusBasedlEPv	 #
	nop	
 # C:/mingw64/x86_64-w64-mingw32/include/gdiplus/gdiplusbrush.h:402: class SolidBrush: public Brush
	add	rsp, 32	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.text
	.globl	_Z13DrawParticlesPN7Gdiplus8GraphicsE
	.def	_Z13DrawParticlesPN7Gdiplus8GraphicsE;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z13DrawParticlesPN7Gdiplus8GraphicsE
_Z13DrawParticlesPN7Gdiplus8GraphicsE:
.LFB8692:
	push	rbp	 #
	.seh_pushreg	rbp
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 104	 #,
	.seh_stackalloc	104
	lea	rbp, 96[rsp]	 #,
	.seh_setframe	rbp, 96
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx	 # graphics, graphics
 # src/render.c:101:     for (int i = 0; i < MAX_PARTICLES; i++) {
	mov	DWORD PTR -4[rbp], 0	 # i,
 # src/render.c:101:     for (int i = 0; i < MAX_PARTICLES; i++) {
	jmp	.L150	 #
.L153:
 # src/render.c:102:         if (particles[i].life > 0) {
	mov	rcx, QWORD PTR .refptr.particles[rip]	 # tmp120,
	mov	eax, DWORD PTR -4[rbp]	 # tmp122, i
	movsx	rdx, eax	 # tmp121, tmp122
	mov	rax, rdx	 # tmp123, tmp121
	add	rax, rax	 # tmp123
	add	rax, rdx	 # tmp123, tmp121
	sal	rax, 3	 # tmp124,
	add	rax, rcx	 # tmp125, tmp120
	add	rax, 16	 # tmp126,
	mov	eax, DWORD PTR [rax]	 # _1, particles[i_22].life
 # src/render.c:102:         if (particles[i].life > 0) {
	test	eax, eax	 # _1
	jle	.L151	 #,
 # src/render.c:103:             int alpha = (particles[i].life * 255) / 40;
	mov	rcx, QWORD PTR .refptr.particles[rip]	 # tmp127,
	mov	eax, DWORD PTR -4[rbp]	 # tmp129, i
	movsx	rdx, eax	 # tmp128, tmp129
	mov	rax, rdx	 # tmp130, tmp128
	add	rax, rax	 # tmp130
	add	rax, rdx	 # tmp130, tmp128
	sal	rax, 3	 # tmp131,
	add	rax, rcx	 # tmp132, tmp127
	add	rax, 16	 # tmp133,
	mov	edx, DWORD PTR [rax]	 # _2, particles[i_22].life
 # src/render.c:103:             int alpha = (particles[i].life * 255) / 40;
	mov	eax, edx	 # tmp134, _2
	sal	eax, 8	 # tmp135,
	sub	eax, edx	 # _3, _2
 # src/render.c:103:             int alpha = (particles[i].life * 255) / 40;
	movsx	rdx, eax	 # tmp136, _3
	imul	rdx, rdx, 1717986919	 # tmp137, tmp136,
	shr	rdx, 32	 # tmp138,
	mov	ecx, edx	 # tmp139, tmp138
	sar	ecx, 4	 # tmp139,
	cdq
	mov	eax, ecx	 # tmp139, tmp139
	sub	eax, edx	 # tmp139, tmp140
	mov	DWORD PTR -8[rbp], eax	 # alpha, tmp141
 # src/render.c:104:             if (alpha > 255) alpha = 255;
	cmp	DWORD PTR -8[rbp], 255	 # alpha,
	jle	.L152	 #,
 # src/render.c:104:             if (alpha > 255) alpha = 255;
	mov	DWORD PTR -8[rbp], 255	 # alpha,
.L152:
 # src/render.c:107:                        GetGValue(particles[i].color), GetBValue(particles[i].color));
	mov	rcx, QWORD PTR .refptr.particles[rip]	 # tmp142,
	mov	eax, DWORD PTR -4[rbp]	 # tmp144, i
	movsx	rdx, eax	 # tmp143, tmp144
	mov	rax, rdx	 # tmp145, tmp143
	add	rax, rax	 # tmp145
	add	rax, rdx	 # tmp145, tmp143
	sal	rax, 3	 # tmp146,
	add	rax, rcx	 # tmp147, tmp142
	add	rax, 20	 # tmp148,
	mov	eax, DWORD PTR [rax]	 # _4, particles[i_22].color
	shr	eax, 16	 # _5,
 # src/render.c:107:                        GetGValue(particles[i].color), GetBValue(particles[i].color));
	movzx	ecx, al	 # _7, _6
 # src/render.c:107:                        GetGValue(particles[i].color), GetBValue(particles[i].color));
	mov	r8, QWORD PTR .refptr.particles[rip]	 # tmp149,
	mov	eax, DWORD PTR -4[rbp]	 # tmp151, i
	movsx	rdx, eax	 # tmp150, tmp151
	mov	rax, rdx	 # tmp152, tmp150
	add	rax, rax	 # tmp152
	add	rax, rdx	 # tmp152, tmp150
	sal	rax, 3	 # tmp153,
	add	rax, r8	 # tmp154, tmp149
	add	rax, 20	 # tmp155,
	mov	eax, DWORD PTR [rax]	 # _8, particles[i_22].color
	shr	ax, 8	 # _10,
 # src/render.c:107:                        GetGValue(particles[i].color), GetBValue(particles[i].color));
	movzx	r9d, al	 # _12, _11
 # src/render.c:106:             Color color(alpha, GetRValue(particles[i].color), 
	mov	r8, QWORD PTR .refptr.particles[rip]	 # tmp156,
	mov	eax, DWORD PTR -4[rbp]	 # tmp158, i
	movsx	rdx, eax	 # tmp157, tmp158
	mov	rax, rdx	 # tmp159, tmp157
	add	rax, rax	 # tmp159
	add	rax, rdx	 # tmp159, tmp157
	sal	rax, 3	 # tmp160,
	add	rax, r8	 # tmp161, tmp156
	add	rax, 20	 # tmp162,
	mov	eax, DWORD PTR [rax]	 # _13, particles[i_22].color
 # src/render.c:107:                        GetGValue(particles[i].color), GetBValue(particles[i].color));
	movzx	r8d, al	 # _15, _14
	mov	eax, DWORD PTR -8[rbp]	 # tmp163, alpha
	movzx	edx, al	 # _17, _16
	lea	rax, -12[rbp]	 # tmp164,
	mov	DWORD PTR 32[rsp], ecx	 #, _7
	mov	rcx, rax	 #, tmp164
	call	_ZN7Gdiplus5ColorC1Ehhhh	 #
 # src/render.c:108:             SolidBrush brush(color);
	lea	rdx, -12[rbp]	 # tmp165,
	lea	rax, -48[rbp]	 # tmp166,
	mov	rcx, rax	 #, tmp166
.LEHB6:
	call	_ZN7Gdiplus10SolidBrushC1ERKNS_5ColorE	 #
.LEHE6:
 # src/render.c:109:             graphics->FillEllipse(&brush, (int)particles[i].x, (int)particles[i].y, 4, 4);
	mov	rcx, QWORD PTR .refptr.particles[rip]	 # tmp167,
	mov	eax, DWORD PTR -4[rbp]	 # tmp169, i
	movsx	rdx, eax	 # tmp168, tmp169
	mov	rax, rdx	 # tmp170, tmp168
	add	rax, rax	 # tmp170
	add	rax, rdx	 # tmp170, tmp168
	sal	rax, 3	 # tmp171,
	add	rax, rcx	 # tmp172, tmp167
	add	rax, 4	 # tmp173,
	movss	xmm0, DWORD PTR [rax]	 # _18, particles[i_22].y
 # src/render.c:109:             graphics->FillEllipse(&brush, (int)particles[i].x, (int)particles[i].y, 4, 4);
	cvttss2si	r8d, xmm0	 # _19, _18
 # src/render.c:109:             graphics->FillEllipse(&brush, (int)particles[i].x, (int)particles[i].y, 4, 4);
	mov	rcx, QWORD PTR .refptr.particles[rip]	 # tmp174,
	mov	eax, DWORD PTR -4[rbp]	 # tmp176, i
	movsx	rdx, eax	 # tmp175, tmp176
	mov	rax, rdx	 # tmp178, tmp175
	add	rax, rax	 # tmp178
	add	rax, rdx	 # tmp178, tmp175
	sal	rax, 3	 # tmp179,
	add	rax, rcx	 # tmp180, tmp174
	movss	xmm0, DWORD PTR [rax]	 # _20, particles[i_22].x
 # src/render.c:109:             graphics->FillEllipse(&brush, (int)particles[i].x, (int)particles[i].y, 4, 4);
	cvttss2si	ecx, xmm0	 # _21, _20
	lea	rdx, -48[rbp]	 # tmp181,
	mov	rax, QWORD PTR 32[rbp]	 # tmp182, graphics
	mov	DWORD PTR 40[rsp], 4	 #,
	mov	DWORD PTR 32[rsp], 4	 #,
	mov	r9d, r8d	 #, _19
	mov	r8d, ecx	 #, _21
	mov	rcx, rax	 #, tmp182
.LEHB7:
	call	_ZN7Gdiplus8Graphics11FillEllipseEPKNS_5BrushEiiii	 #
.LEHE7:
 # src/render.c:110:         }
	lea	rax, -48[rbp]	 # tmp183,
	mov	rcx, rax	 #, tmp183
	call	_ZN7Gdiplus10SolidBrushD1Ev	 #
.L151:
 # src/render.c:101:     for (int i = 0; i < MAX_PARTICLES; i++) {
	add	DWORD PTR -4[rbp], 1	 # i,
.L150:
 # src/render.c:101:     for (int i = 0; i < MAX_PARTICLES; i++) {
	cmp	DWORD PTR -4[rbp], 49	 # i,
	jle	.L153	 #,
 # src/render.c:112: }
	jmp	.L156	 #
.L155:
 # src/render.c:110:         }
	mov	rbx, rax	 # tmp185,
	lea	rax, -48[rbp]	 # tmp184,
	mov	rcx, rax	 #, tmp184
	call	_ZN7Gdiplus10SolidBrushD1Ev	 #
	mov	rax, rbx	 # D.135098, tmp185
	mov	rcx, rax	 #, D.135098
.LEHB8:
	call	_Unwind_Resume	 #
	nop	
.LEHE8:
.L156:
 # src/render.c:112: }
	add	rsp, 104	 #,
	pop	rbx	 #
	pop	rbp	 #
	ret	
	.seh_handler	__gxx_personality_seh0, @unwind, @except
	.seh_handlerdata
.LLSDA8692:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8692-.LLSDACSB8692
.LLSDACSB8692:
	.uleb128 .LEHB6-.LFB8692
	.uleb128 .LEHE6-.LEHB6
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB7-.LFB8692
	.uleb128 .LEHE7-.LEHB7
	.uleb128 .L155-.LFB8692
	.uleb128 0
	.uleb128 .LEHB8-.LFB8692
	.uleb128 .LEHE8-.LEHB8
	.uleb128 0
	.uleb128 0
.LLSDACSE8692:
	.text
	.seh_endproc
	.section .rdata,"dr"
.LC15:
	.ascii "%d\0"
	.text
	.globl	_Z9DrawScorePN7Gdiplus8GraphicsEiii
	.def	_Z9DrawScorePN7Gdiplus8GraphicsEiii;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9DrawScorePN7Gdiplus8GraphicsEiii
_Z9DrawScorePN7Gdiplus8GraphicsEiii:
.LFB8697:
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 80	 #,
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx	 # graphics, graphics
	mov	DWORD PTR 24[rbp], edx	 # score, score
	mov	DWORD PTR 32[rbp], r8d	 # centerX, centerX
	mov	DWORD PTR 40[rbp], r9d	 # y, y
 # src/render.c:116:     sprintf(scoreStr, "%d", score);
	mov	ecx, DWORD PTR 24[rbp]	 # tmp115, score
	lea	rdx, .LC15[rip]	 # tmp116,
	lea	rax, -48[rbp]	 # tmp117,
	mov	r8d, ecx	 #, tmp115
	mov	rcx, rax	 #, tmp117
	call	__mingw_sprintf	 #
 # src/render.c:117:     int len = strlen(scoreStr);
	lea	rax, -48[rbp]	 # tmp118,
	mov	rcx, rax	 #, tmp118
	call	strlen	 #
 # src/render.c:117:     int len = strlen(scoreStr);
	mov	DWORD PTR -20[rbp], eax	 # len, _1
 # src/render.c:119:     int totalWidth = 0;
	mov	DWORD PTR -4[rbp], 0	 # totalWidth,
 # src/render.c:120:     for (int i = 0; i < len; i++) {
	mov	DWORD PTR -8[rbp], 0	 # i,
 # src/render.c:120:     for (int i = 0; i < len; i++) {
	jmp	.L158	 #
.L160:
 # src/render.c:121:         int digit = scoreStr[i] - '0';
	mov	eax, DWORD PTR -8[rbp]	 # tmp120, i
	cdqe
	movzx	eax, BYTE PTR -48[rbp+rax]	 # _2, scoreStr[i_18]
	movsx	eax, al	 # _3, _2
 # src/render.c:121:         int digit = scoreStr[i] - '0';
	sub	eax, 48	 # tmp121,
	mov	DWORD PTR -28[rbp], eax	 # digit, tmp121
 # src/render.c:122:         if (imgNumbers[digit]) totalWidth += imgNumbers[digit]->GetWidth();
	mov	eax, DWORD PTR -28[rbp]	 # tmp123, digit
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp124,
	lea	rax, imgNumbers[rip]	 # tmp125,
	mov	rax, QWORD PTR [rdx+rax]	 # _4, imgNumbers[digit_46]
 # src/render.c:122:         if (imgNumbers[digit]) totalWidth += imgNumbers[digit]->GetWidth();
	test	rax, rax	 # _4
	je	.L159	 #,
 # src/render.c:122:         if (imgNumbers[digit]) totalWidth += imgNumbers[digit]->GetWidth();
	mov	eax, DWORD PTR -28[rbp]	 # tmp127, digit
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp128,
	lea	rax, imgNumbers[rip]	 # tmp129,
	mov	rax, QWORD PTR [rdx+rax]	 # _5, imgNumbers[digit_46]
 # src/render.c:122:         if (imgNumbers[digit]) totalWidth += imgNumbers[digit]->GetWidth();
	mov	rcx, rax	 #, _5
	call	_ZN7Gdiplus5Image8GetWidthEv	 #
 # src/render.c:122:         if (imgNumbers[digit]) totalWidth += imgNumbers[digit]->GetWidth();
	mov	edx, DWORD PTR -4[rbp]	 # totalWidth.41_6, totalWidth
	add	eax, edx	 # _7, totalWidth.41_6
	mov	DWORD PTR -4[rbp], eax	 # totalWidth, _7
.L159:
 # src/render.c:120:     for (int i = 0; i < len; i++) {
	add	DWORD PTR -8[rbp], 1	 # i,
.L158:
 # src/render.c:120:     for (int i = 0; i < len; i++) {
	mov	eax, DWORD PTR -8[rbp]	 # tmp130, i
	cmp	eax, DWORD PTR -20[rbp]	 # tmp130, len
	jl	.L160	 #,
 # src/render.c:125:     int x = centerX - totalWidth / 2;
	mov	eax, DWORD PTR -4[rbp]	 # tmp131, totalWidth
	mov	edx, eax	 # tmp132, tmp131
	shr	edx, 31	 # tmp132,
	add	eax, edx	 # tmp133, tmp132
	sar	eax	 # _8
	neg	eax	 # _8
	mov	edx, eax	 # _8, _8
 # src/render.c:125:     int x = centerX - totalWidth / 2;
	mov	eax, DWORD PTR 32[rbp]	 # tmp138, centerX
	add	eax, edx	 # x_34, _8
	mov	DWORD PTR -12[rbp], eax	 # x, x_34
 # src/render.c:126:     for (int i = 0; i < len; i++) {
	mov	DWORD PTR -16[rbp], 0	 # i,
 # src/render.c:126:     for (int i = 0; i < len; i++) {
	jmp	.L161	 #
.L163:
 # src/render.c:127:         int digit = scoreStr[i] - '0';
	mov	eax, DWORD PTR -16[rbp]	 # tmp140, i
	cdqe
	movzx	eax, BYTE PTR -48[rbp+rax]	 # _9, scoreStr[i_21]
	movsx	eax, al	 # _10, _9
 # src/render.c:127:         int digit = scoreStr[i] - '0';
	sub	eax, 48	 # tmp141,
	mov	DWORD PTR -24[rbp], eax	 # digit, tmp141
 # src/render.c:128:         if (imgNumbers[digit]) {
	mov	eax, DWORD PTR -24[rbp]	 # tmp143, digit
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp144,
	lea	rax, imgNumbers[rip]	 # tmp145,
	mov	rax, QWORD PTR [rdx+rax]	 # _11, imgNumbers[digit_37]
 # src/render.c:128:         if (imgNumbers[digit]) {
	test	rax, rax	 # _11
	je	.L162	 #,
 # src/render.c:129:             graphics->DrawImage(imgNumbers[digit], x, y);
	mov	eax, DWORD PTR -24[rbp]	 # tmp147, digit
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp148,
	lea	rax, imgNumbers[rip]	 # tmp149,
	mov	rdx, QWORD PTR [rdx+rax]	 # _12, imgNumbers[digit_37]
	mov	r8d, DWORD PTR 40[rbp]	 # tmp150, y
	mov	ecx, DWORD PTR -12[rbp]	 # tmp151, x
	mov	rax, QWORD PTR 16[rbp]	 # tmp152, graphics
	mov	r9d, r8d	 #, tmp150
	mov	r8d, ecx	 #, tmp151
	mov	rcx, rax	 #, tmp152
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii	 #
 # src/render.c:130:             x += imgNumbers[digit]->GetWidth();
	mov	eax, DWORD PTR -24[rbp]	 # tmp154, digit
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp155,
	lea	rax, imgNumbers[rip]	 # tmp156,
	mov	rax, QWORD PTR [rdx+rax]	 # _13, imgNumbers[digit_37]
 # src/render.c:130:             x += imgNumbers[digit]->GetWidth();
	mov	rcx, rax	 #, _13
	call	_ZN7Gdiplus5Image8GetWidthEv	 #
 # src/render.c:130:             x += imgNumbers[digit]->GetWidth();
	mov	edx, DWORD PTR -12[rbp]	 # x.42_14, x
	add	eax, edx	 # _15, x.42_14
	mov	DWORD PTR -12[rbp], eax	 # x, _15
.L162:
 # src/render.c:126:     for (int i = 0; i < len; i++) {
	add	DWORD PTR -16[rbp], 1	 # i,
.L161:
 # src/render.c:126:     for (int i = 0; i < len; i++) {
	mov	eax, DWORD PTR -16[rbp]	 # tmp157, i
	cmp	eax, DWORD PTR -20[rbp]	 # tmp157, len
	jl	.L163	 #,
 # src/render.c:133: }
	nop	
	nop	
	add	rsp, 80	 #,
	pop	rbp	 #
	ret	
	.seh_endproc
	.globl	_Z8DrawGameP5HDC__
	.def	_Z8DrawGameP5HDC__;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z8DrawGameP5HDC__
_Z8DrawGameP5HDC__:
.LFB8698:
	push	rbp	 #
	.seh_pushreg	rbp
	push	rbx	 #
	.seh_pushreg	rbx
	sub	rsp, 168	 #,
	.seh_stackalloc	168
	lea	rbp, 160[rsp]	 #,
	.seh_setframe	rbp, 160
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx	 # hdc, hdc
 # src/render.c:136:     Graphics graphics(hdcBackBuffer);
	mov	rdx, QWORD PTR hdcBackBuffer[rip]	 # hdcBackBuffer.44_1, hdcBackBuffer
	lea	rax, -80[rbp]	 # tmp169,
	mov	rcx, rax	 #, tmp169
.LEHB9:
	call	_ZN7Gdiplus8GraphicsC1EP5HDC__	 #
.LEHE9:
 # src/render.c:137:     graphics.SetInterpolationMode(InterpolationModeNearestNeighbor);
	lea	rax, -80[rbp]	 # tmp170,
	mov	edx, 5	 #,
	mov	rcx, rax	 #, tmp170
.LEHB10:
	call	_ZN7Gdiplus8Graphics20SetInterpolationModeENS_17InterpolationModeE	 #
 # src/render.c:139:     int shakeX = 0, shakeY = 0;
	mov	DWORD PTR -4[rbp], 0	 # shakeX,
 # src/render.c:139:     int shakeX = 0, shakeY = 0;
	mov	DWORD PTR -8[rbp], 0	 # shakeY,
 # src/render.c:140:     if (game.screenShake > 0) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp171,
	mov	eax, DWORD PTR 84[rax]	 # _2, game.screenShake
 # src/render.c:140:     if (game.screenShake > 0) {
	test	eax, eax	 # _2
	jle	.L165	 #,
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	call	rand	 #
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	mov	rdx, QWORD PTR .refptr.game[rip]	 # tmp172,
	mov	edx, DWORD PTR 84[rdx]	 # _4, game.screenShake
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	lea	ebx, [rdx+rdx]	 # _5,
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	cdq
	idiv	ebx	 # _5
	mov	ecx, edx	 # _6, _6
	mov	edx, ecx	 # _6, _6
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp175,
	mov	eax, DWORD PTR 84[rax]	 # _7, game.screenShake
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	sub	edx, eax	 # tmp176, _7
	mov	DWORD PTR -4[rbp], edx	 # shakeX, tmp176
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	call	rand	 #
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	mov	rdx, QWORD PTR .refptr.game[rip]	 # tmp177,
	mov	edx, DWORD PTR 84[rdx]	 # _9, game.screenShake
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	lea	ebx, [rdx+rdx]	 # _10,
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	cdq
	idiv	ebx	 # _10
	mov	ecx, edx	 # _11, _11
	mov	edx, ecx	 # _11, _11
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp180,
	mov	eax, DWORD PTR 84[rax]	 # _12, game.screenShake
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	sub	edx, eax	 # tmp181, _12
	mov	DWORD PTR -8[rbp], edx	 # shakeY, tmp181
.L165:
 # src/render.c:146:     if (imgBackground) {
	mov	rax, QWORD PTR imgBackground[rip]	 # imgBackground.45_13, imgBackground
 # src/render.c:146:     if (imgBackground) {
	test	rax, rax	 # imgBackground.45_13
	je	.L166	 #,
 # src/render.c:147:         graphics.DrawImage(imgBackground, shakeX, shakeY, (INT)WINDOW_WIDTH, (INT)WINDOW_HEIGHT);
	mov	rdx, QWORD PTR imgBackground[rip]	 # imgBackground.46_14, imgBackground
	mov	r8d, DWORD PTR -8[rbp]	 # tmp182, shakeY
	mov	ecx, DWORD PTR -4[rbp]	 # tmp183, shakeX
	lea	rax, -80[rbp]	 # tmp184,
	mov	DWORD PTR 40[rsp], 720	 #,
	mov	DWORD PTR 32[rsp], 1280	 #,
	mov	r9d, r8d	 #, tmp182
	mov	r8d, ecx	 #, tmp183
	mov	rcx, rax	 #, tmp184
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii	 #
.L166:
 # src/render.c:151:     if (imgPipeGreen) {
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.47_15, imgPipeGreen
 # src/render.c:151:     if (imgPipeGreen) {
	test	rax, rax	 # imgPipeGreen.47_15
	je	.L167	 #,
 # src/render.c:152:         INT pipeW = (INT)imgPipeGreen->GetWidth();
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.48_16, imgPipeGreen
	mov	rcx, rax	 #, imgPipeGreen.48_16
	call	_ZN7Gdiplus5Image8GetWidthEv	 #
 # src/render.c:152:         INT pipeW = (INT)imgPipeGreen->GetWidth();
	mov	DWORD PTR -20[rbp], eax	 # pipeW, _17
 # src/render.c:153:         INT pipeH = (INT)imgPipeGreen->GetHeight();
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.49_18, imgPipeGreen
	mov	rcx, rax	 #, imgPipeGreen.49_18
	call	_ZN7Gdiplus5Image9GetHeightEv	 #
 # src/render.c:153:         INT pipeH = (INT)imgPipeGreen->GetHeight();
	mov	DWORD PTR -24[rbp], eax	 # pipeH, _19
 # src/render.c:155:         for (int i = 0; i < 3; i++) {
	mov	DWORD PTR -12[rbp], 0	 # i,
 # src/render.c:155:         for (int i = 0; i < 3; i++) {
	jmp	.L168	 #
.L169:
 # src/render.c:156:             INT pipeX = game.pipes[i].x + shakeX;
	mov	rcx, QWORD PTR .refptr.game[rip]	 # tmp185,
	mov	eax, DWORD PTR -12[rbp]	 # tmp187, i
	movsx	rdx, eax	 # tmp186, tmp187
	mov	rax, rdx	 # tmp188, tmp186
	add	rax, rax	 # tmp188
	add	rax, rdx	 # tmp188, tmp186
	sal	rax, 2	 # tmp189,
	add	rax, rcx	 # tmp190, tmp185
	add	rax, 16	 # tmp191,
	mov	edx, DWORD PTR [rax]	 # _20, game.pipes[i_73].x
 # src/render.c:156:             INT pipeX = game.pipes[i].x + shakeX;
	mov	eax, DWORD PTR -4[rbp]	 # tmp195, shakeX
	add	eax, edx	 # pipeX_105, _20
	mov	DWORD PTR -28[rbp], eax	 # pipeX, pipeX_105
 # src/render.c:157:             INT topHeight = game.pipes[i].topHeight;
	mov	rcx, QWORD PTR .refptr.game[rip]	 # tmp196,
	mov	eax, DWORD PTR -12[rbp]	 # tmp198, i
	movsx	rdx, eax	 # tmp197, tmp198
	mov	rax, rdx	 # tmp199, tmp197
	add	rax, rax	 # tmp199
	add	rax, rdx	 # tmp199, tmp197
	sal	rax, 2	 # tmp200,
	add	rax, rcx	 # tmp201, tmp196
	add	rax, 20	 # tmp202,
	mov	eax, DWORD PTR [rax]	 # tmp203, game.pipes[i_73].topHeight
	mov	DWORD PTR -32[rbp], eax	 # topHeight, tmp203
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	mov	edx, DWORD PTR -32[rbp]	 # tmp204, topHeight
	mov	eax, DWORD PTR -8[rbp]	 # tmp205, shakeY
	add	eax, edx	 # _21, tmp204
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	pxor	xmm1, xmm1	 # _22
	cvtsi2ss	xmm1, eax	 # _22, _21
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	mov	eax, DWORD PTR -20[rbp]	 # tmp206, pipeW
	mov	edx, eax	 # tmp207, tmp206
	shr	edx, 31	 # tmp207,
	add	eax, edx	 # tmp208, tmp207
	sar	eax	 # _23
	mov	edx, eax	 # _23, _23
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	mov	eax, DWORD PTR -28[rbp]	 # tmp210, pipeX
	add	eax, edx	 # _24, _23
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	pxor	xmm0, xmm0	 # _25
	cvtsi2ss	xmm0, eax	 # _25, _24
	lea	rax, -80[rbp]	 # tmp211,
	mov	r9d, 0	 #,
	movaps	xmm2, xmm1	 #, _22
	movaps	xmm1, xmm0	 #, _25
	mov	rcx, rax	 #, tmp211
	call	_ZN7Gdiplus8Graphics18TranslateTransformEffNS_11MatrixOrderE	 #
 # src/render.c:161:             graphics.RotateTransform(180);
	lea	rax, -80[rbp]	 # tmp212,
	mov	r8d, 0	 #,
	movss	xmm1, DWORD PTR .LC16[rip]	 #,
	mov	rcx, rax	 #, tmp212
	call	_ZN7Gdiplus8Graphics15RotateTransformEfNS_11MatrixOrderE	 #
 # src/render.c:162:             graphics.DrawImage(imgPipeGreen, -(pipeW/2), 0, pipeW, pipeH);
	mov	eax, DWORD PTR -20[rbp]	 # tmp213, pipeW
	mov	edx, eax	 # tmp214, tmp213
	shr	edx, 31	 # tmp214,
	add	eax, edx	 # tmp215, tmp214
	sar	eax	 # _26
	neg	eax	 # _26
	mov	r8d, eax	 # _26, _26
	mov	rdx, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.50_27, imgPipeGreen
	lea	rax, -80[rbp]	 # tmp217,
	mov	ecx, DWORD PTR -24[rbp]	 # tmp218, pipeH
	mov	DWORD PTR 40[rsp], ecx	 #, tmp218
	mov	ecx, DWORD PTR -20[rbp]	 # tmp219, pipeW
	mov	DWORD PTR 32[rsp], ecx	 #, tmp219
	mov	r9d, 0	 #,
	mov	rcx, rax	 #, tmp217
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii	 #
 # src/render.c:163:             graphics.ResetTransform();
	lea	rax, -80[rbp]	 # tmp220,
	mov	rcx, rax	 #, tmp220
	call	_ZN7Gdiplus8Graphics14ResetTransformEv	 #
 # src/render.c:166:             INT bottomPipeY = topHeight + PIPE_GAP + shakeY;
	mov	eax, DWORD PTR -32[rbp]	 # tmp221, topHeight
	lea	edx, 200[rax]	 # _28,
 # src/render.c:166:             INT bottomPipeY = topHeight + PIPE_GAP + shakeY;
	mov	eax, DWORD PTR -8[rbp]	 # tmp225, shakeY
	add	eax, edx	 # bottomPipeY_111, _28
	mov	DWORD PTR -36[rbp], eax	 # bottomPipeY, bottomPipeY_111
 # src/render.c:167:             graphics.DrawImage(imgPipeGreen, pipeX, bottomPipeY, pipeW, pipeH);
	mov	rdx, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.51_29, imgPipeGreen
	mov	r9d, DWORD PTR -36[rbp]	 # tmp226, bottomPipeY
	mov	r8d, DWORD PTR -28[rbp]	 # tmp227, pipeX
	lea	rax, -80[rbp]	 # tmp228,
	mov	ecx, DWORD PTR -24[rbp]	 # tmp229, pipeH
	mov	DWORD PTR 40[rsp], ecx	 #, tmp229
	mov	ecx, DWORD PTR -20[rbp]	 # tmp230, pipeW
	mov	DWORD PTR 32[rsp], ecx	 #, tmp230
	mov	rcx, rax	 #, tmp228
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii	 #
 # src/render.c:155:         for (int i = 0; i < 3; i++) {
	add	DWORD PTR -12[rbp], 1	 # i,
.L168:
 # src/render.c:155:         for (int i = 0; i < 3; i++) {
	cmp	DWORD PTR -12[rbp], 2	 # i,
	jle	.L169	 #,
.L167:
 # src/render.c:172:     if (imgGround) {
	mov	rax, QWORD PTR imgGround[rip]	 # imgGround.52_30, imgGround
 # src/render.c:172:     if (imgGround) {
	test	rax, rax	 # imgGround.52_30
	je	.L170	 #,
 # src/render.c:173:         INT groundW = (INT)imgGround->GetWidth();
	mov	rax, QWORD PTR imgGround[rip]	 # imgGround.53_31, imgGround
	mov	rcx, rax	 #, imgGround.53_31
	call	_ZN7Gdiplus5Image8GetWidthEv	 #
 # src/render.c:173:         INT groundW = (INT)imgGround->GetWidth();
	mov	DWORD PTR -40[rbp], eax	 # groundW, _32
 # src/render.c:174:         INT groundH = (INT)imgGround->GetHeight();
	mov	rax, QWORD PTR imgGround[rip]	 # imgGround.54_33, imgGround
	mov	rcx, rax	 #, imgGround.54_33
	call	_ZN7Gdiplus5Image9GetHeightEv	 #
 # src/render.c:174:         INT groundH = (INT)imgGround->GetHeight();
	mov	DWORD PTR -44[rbp], eax	 # groundH, _34
 # src/render.c:175:         INT groundY = WINDOW_HEIGHT - GROUND_HEIGHT;
	mov	DWORD PTR -48[rbp], 608	 # groundY,
 # src/render.c:177:         INT x = (INT)game.groundOffset + shakeX;
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp231,
	movss	xmm0, DWORD PTR 80[rax]	 # _35, game.groundOffset
 # src/render.c:177:         INT x = (INT)game.groundOffset + shakeX;
	cvttss2si	edx, xmm0	 # _36, _35
 # src/render.c:177:         INT x = (INT)game.groundOffset + shakeX;
	mov	eax, DWORD PTR -4[rbp]	 # tmp235, shakeX
	add	eax, edx	 # x_121, _36
	mov	DWORD PTR -16[rbp], eax	 # x, x_121
 # src/render.c:178:         while (x < WINDOW_WIDTH) {
	jmp	.L171	 #
.L172:
 # src/render.c:179:             graphics.DrawImage(imgGround, x, groundY + shakeY);
	mov	edx, DWORD PTR -48[rbp]	 # tmp236, groundY
	mov	eax, DWORD PTR -8[rbp]	 # tmp237, shakeY
	lea	r8d, [rdx+rax]	 # _37,
	mov	rdx, QWORD PTR imgGround[rip]	 # imgGround.55_38, imgGround
	mov	ecx, DWORD PTR -16[rbp]	 # tmp238, x
	lea	rax, -80[rbp]	 # tmp239,
	mov	r9d, r8d	 #, _37
	mov	r8d, ecx	 #, tmp238
	mov	rcx, rax	 #, tmp239
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii	 #
 # src/render.c:180:             x += groundW;
	mov	eax, DWORD PTR -40[rbp]	 # tmp240, groundW
	add	DWORD PTR -16[rbp], eax	 # x, tmp240
.L171:
 # src/render.c:178:         while (x < WINDOW_WIDTH) {
	cmp	DWORD PTR -16[rbp], 1279	 # x,
	jle	.L172	 #,
.L170:
 # src/render.c:185:     if (imgBirdFrames[game.birdFrame]) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp241,
	mov	eax, DWORD PTR 92[rax]	 # _39, game.birdFrame
 # src/render.c:185:     if (imgBirdFrames[game.birdFrame]) {
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp243,
	lea	rax, imgBirdFrames[rip]	 # tmp244,
	mov	rax, QWORD PTR [rdx+rax]	 # _40, imgBirdFrames[_39]
 # src/render.c:185:     if (imgBirdFrames[game.birdFrame]) {
	test	rax, rax	 # _40
	je	.L173	 #,
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp245,
	movss	xmm0, DWORD PTR [rax]	 # _41, game.bird.y
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	cvttss2si	edx, xmm0	 # _42, _41
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	mov	eax, DWORD PTR -8[rbp]	 # tmp246, shakeY
	lea	r8d, [rdx+rax]	 # _43,
	mov	eax, DWORD PTR -4[rbp]	 # tmp247, shakeX
	lea	ecx, 350[rax]	 # _44,
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp248,
	mov	eax, DWORD PTR 92[rax]	 # _45, game.birdFrame
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	cdqe
	lea	rdx, 0[0+rax*8]	 # tmp250,
	lea	rax, imgBirdFrames[rip]	 # tmp251,
	mov	rdx, QWORD PTR [rdx+rax]	 # _46, imgBirdFrames[_45]
	lea	rax, -80[rbp]	 # tmp252,
	mov	r9d, r8d	 #, _43
	mov	r8d, ecx	 #, _44
	mov	rcx, rax	 #, tmp252
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii	 #
.L173:
 # src/render.c:190:     DrawParticles(&graphics);
	lea	rax, -80[rbp]	 # tmp253,
	mov	rcx, rax	 #, tmp253
	call	_Z13DrawParticlesPN7Gdiplus8GraphicsE	 #
 # src/render.c:193:     if (game.started && !game.gameOver) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp254,
	mov	eax, DWORD PTR 64[rax]	 # _47, game.started
 # src/render.c:193:     if (game.started && !game.gameOver) {
	test	eax, eax	 # _47
	je	.L174	 #,
 # src/render.c:193:     if (game.started && !game.gameOver) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp255,
	mov	eax, DWORD PTR 60[rax]	 # _48, game.gameOver
 # src/render.c:193:     if (game.started && !game.gameOver) {
	test	eax, eax	 # _48
	jne	.L174	 #,
 # src/render.c:194:         DrawScore(&graphics, game.score, WINDOW_WIDTH / 2, 30);
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp256,
	mov	edx, DWORD PTR 52[rax]	 # _49, game.score
	lea	rax, -80[rbp]	 # tmp257,
	mov	r9d, 30	 #,
	mov	r8d, 640	 #,
	mov	rcx, rax	 #, tmp257
	call	_Z9DrawScorePN7Gdiplus8GraphicsEiii	 #
.L174:
 # src/render.c:198:     if (!game.started && imgMessage) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp258,
	mov	eax, DWORD PTR 64[rax]	 # _50, game.started
 # src/render.c:198:     if (!game.started && imgMessage) {
	test	eax, eax	 # _50
	jne	.L175	 #,
 # src/render.c:198:     if (!game.started && imgMessage) {
	mov	rax, QWORD PTR imgMessage[rip]	 # imgMessage.56_51, imgMessage
 # src/render.c:198:     if (!game.started && imgMessage) {
	test	rax, rax	 # imgMessage.56_51
	je	.L175	 #,
 # src/render.c:199:         INT msgW = (INT)imgMessage->GetWidth();
	mov	rax, QWORD PTR imgMessage[rip]	 # imgMessage.57_52, imgMessage
	mov	rcx, rax	 #, imgMessage.57_52
	call	_ZN7Gdiplus5Image8GetWidthEv	 #
 # src/render.c:199:         INT msgW = (INT)imgMessage->GetWidth();
	mov	DWORD PTR -52[rbp], eax	 # msgW, _53
 # src/render.c:200:         INT msgH = (INT)imgMessage->GetHeight();
	mov	rax, QWORD PTR imgMessage[rip]	 # imgMessage.58_54, imgMessage
	mov	rcx, rax	 #, imgMessage.58_54
	call	_ZN7Gdiplus5Image9GetHeightEv	 #
 # src/render.c:200:         INT msgH = (INT)imgMessage->GetHeight();
	mov	DWORD PTR -56[rbp], eax	 # msgH, _55
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	mov	eax, 720	 # tmp259,
	sub	eax, DWORD PTR -56[rbp]	 # _56, msgH
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	mov	edx, eax	 # tmp260, _56
	shr	edx, 31	 # tmp260,
	add	eax, edx	 # tmp261, tmp260
	sar	eax	 # _57
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	lea	ecx, -40[rax]	 # _58,
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	mov	eax, 1280	 # tmp263,
	sub	eax, DWORD PTR -52[rbp]	 # _59, msgW
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	mov	edx, eax	 # tmp264, _59
	shr	edx, 31	 # tmp264,
	add	eax, edx	 # tmp265, tmp264
	sar	eax	 # _60
	mov	r8d, eax	 # _60, _60
	mov	rdx, QWORD PTR imgMessage[rip]	 # imgMessage.59_61, imgMessage
	lea	rax, -80[rbp]	 # tmp267,
	mov	r9d, ecx	 #, _58
	mov	rcx, rax	 #, tmp267
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii	 #
.L175:
 # src/render.c:205:     if (game.gameOver) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp268,
	mov	eax, DWORD PTR 60[rax]	 # _62, game.gameOver
 # src/render.c:205:     if (game.gameOver) {
	test	eax, eax	 # _62
	je	.L176	 #,
 # src/render.c:206:         if (imgGameOver) {
	mov	rax, QWORD PTR imgGameOver[rip]	 # imgGameOver.60_63, imgGameOver
 # src/render.c:206:         if (imgGameOver) {
	test	rax, rax	 # imgGameOver.60_63
	je	.L177	 #,
 # src/render.c:207:             INT goW = (INT)imgGameOver->GetWidth();
	mov	rax, QWORD PTR imgGameOver[rip]	 # imgGameOver.61_64, imgGameOver
	mov	rcx, rax	 #, imgGameOver.61_64
	call	_ZN7Gdiplus5Image8GetWidthEv	 #
 # src/render.c:207:             INT goW = (INT)imgGameOver->GetWidth();
	mov	DWORD PTR -60[rbp], eax	 # goW, _65
 # src/render.c:208:             graphics.DrawImage(imgGameOver, (WINDOW_WIDTH - goW) / 2, 80);
	mov	eax, 1280	 # tmp269,
	sub	eax, DWORD PTR -60[rbp]	 # _66, goW
 # src/render.c:208:             graphics.DrawImage(imgGameOver, (WINDOW_WIDTH - goW) / 2, 80);
	mov	edx, eax	 # tmp270, _66
	shr	edx, 31	 # tmp270,
	add	eax, edx	 # tmp271, tmp270
	sar	eax	 # _67
	mov	ecx, eax	 # _67, _67
	mov	rdx, QWORD PTR imgGameOver[rip]	 # imgGameOver.62_68, imgGameOver
	lea	rax, -80[rbp]	 # tmp273,
	mov	r9d, 80	 #,
	mov	r8d, ecx	 #, _67
	mov	rcx, rax	 #, tmp273
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii	 #
.L177:
 # src/render.c:212:         DrawScore(&graphics, game.score, WINDOW_WIDTH / 2, 200);
	mov	rax, QWORD PTR .refptr.game[rip]	 # tmp274,
	mov	edx, DWORD PTR 52[rax]	 # _69, game.score
	lea	rax, -80[rbp]	 # tmp275,
	mov	r9d, 200	 #,
	mov	r8d, 640	 #,
	mov	rcx, rax	 #, tmp275
	call	_Z9DrawScorePN7Gdiplus8GraphicsEiii	 #
.L176:
 # src/render.c:216:     BitBlt(hdc, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, hdcBackBuffer, 0, 0, SRCCOPY);
	mov	rdx, QWORD PTR hdcBackBuffer[rip]	 # hdcBackBuffer.63_70, hdcBackBuffer
	mov	rax, QWORD PTR 32[rbp]	 # tmp276, hdc
	mov	DWORD PTR 64[rsp], 13369376	 #,
	mov	DWORD PTR 56[rsp], 0	 #,
	mov	DWORD PTR 48[rsp], 0	 #,
	mov	QWORD PTR 40[rsp], rdx	 #, hdcBackBuffer.63_70
	mov	DWORD PTR 32[rsp], 720	 #,
	mov	r9d, 1280	 #,
	mov	r8d, 0	 #,
	mov	edx, 0	 #,
	mov	rcx, rax	 #, tmp276
	mov	rax, QWORD PTR __imp_BitBlt[rip]	 # tmp277,
	call	rax	 # tmp277
.LEHE10:
 # src/render.c:217: }
	lea	rax, -80[rbp]	 # tmp278,
	mov	rcx, rax	 #, tmp278
	call	_ZN7Gdiplus8GraphicsD1Ev	 #
	jmp	.L180	 #
.L179:
	mov	rbx, rax	 # tmp280,
	lea	rax, -80[rbp]	 # tmp279,
	mov	rcx, rax	 #, tmp279
	call	_ZN7Gdiplus8GraphicsD1Ev	 #
	mov	rax, rbx	 # D.135101, tmp280
	mov	rcx, rax	 #, D.135101
.LEHB11:
	call	_Unwind_Resume	 #
	nop	
.LEHE11:
.L180:
	add	rsp, 168	 #,
	pop	rbx	 #
	pop	rbp	 #
	ret	
	.seh_handler	__gxx_personality_seh0, @unwind, @except
	.seh_handlerdata
.LLSDA8698:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8698-.LLSDACSB8698
.LLSDACSB8698:
	.uleb128 .LEHB9-.LFB8698
	.uleb128 .LEHE9-.LEHB9
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB10-.LFB8698
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L179-.LFB8698
	.uleb128 0
	.uleb128 .LEHB11-.LFB8698
	.uleb128 .LEHE11-.LEHB11
	.uleb128 0
	.uleb128 0
.LLSDACSE8698:
	.text
	.seh_endproc
	.globl	_ZTVN7Gdiplus10SolidBrushE
	.section	.rdata$_ZTVN7Gdiplus10SolidBrushE,"dr"
	.linkonce same_size
	.align 8
_ZTVN7Gdiplus10SolidBrushE:
	.quad	0
	.quad	_ZTIN7Gdiplus10SolidBrushE
	.quad	_ZN7Gdiplus10SolidBrushD1Ev
	.quad	_ZN7Gdiplus10SolidBrushD0Ev
	.quad	_ZNK7Gdiplus10SolidBrush5CloneEv
	.globl	_ZTVN7Gdiplus5BrushE
	.section	.rdata$_ZTVN7Gdiplus5BrushE,"dr"
	.linkonce same_size
	.align 8
_ZTVN7Gdiplus5BrushE:
	.quad	0
	.quad	_ZTIN7Gdiplus5BrushE
	.quad	_ZN7Gdiplus5BrushD1Ev
	.quad	_ZN7Gdiplus5BrushD0Ev
	.quad	_ZNK7Gdiplus5Brush5CloneEv
	.globl	_ZTVN7Gdiplus5ImageE
	.section	.rdata$_ZTVN7Gdiplus5ImageE,"dr"
	.linkonce same_size
	.align 8
_ZTVN7Gdiplus5ImageE:
	.quad	0
	.quad	_ZTIN7Gdiplus5ImageE
	.quad	_ZN7Gdiplus5ImageD1Ev
	.quad	_ZN7Gdiplus5ImageD0Ev
	.quad	_ZNK7Gdiplus5Image5CloneEv
	.globl	_ZTIN7Gdiplus10SolidBrushE
	.section	.rdata$_ZTIN7Gdiplus10SolidBrushE,"dr"
	.linkonce same_size
	.align 8
_ZTIN7Gdiplus10SolidBrushE:
 # <anonymous>:
 # <anonymous>:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
 # <anonymous>:
	.quad	_ZTSN7Gdiplus10SolidBrushE
 # <anonymous>:
	.quad	_ZTIN7Gdiplus5BrushE
	.globl	_ZTSN7Gdiplus10SolidBrushE
	.section	.rdata$_ZTSN7Gdiplus10SolidBrushE,"dr"
	.linkonce same_size
	.align 16
_ZTSN7Gdiplus10SolidBrushE:
	.ascii "N7Gdiplus10SolidBrushE\0"
	.globl	_ZTIN7Gdiplus5BrushE
	.section	.rdata$_ZTIN7Gdiplus5BrushE,"dr"
	.linkonce same_size
	.align 8
_ZTIN7Gdiplus5BrushE:
 # <anonymous>:
 # <anonymous>:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
 # <anonymous>:
	.quad	_ZTSN7Gdiplus5BrushE
 # <anonymous>:
	.quad	_ZTIN7Gdiplus11GdiplusBaseE
	.globl	_ZTSN7Gdiplus5BrushE
	.section	.rdata$_ZTSN7Gdiplus5BrushE,"dr"
	.linkonce same_size
	.align 16
_ZTSN7Gdiplus5BrushE:
	.ascii "N7Gdiplus5BrushE\0"
	.globl	_ZTIN7Gdiplus5ImageE
	.section	.rdata$_ZTIN7Gdiplus5ImageE,"dr"
	.linkonce same_size
	.align 8
_ZTIN7Gdiplus5ImageE:
 # <anonymous>:
 # <anonymous>:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
 # <anonymous>:
	.quad	_ZTSN7Gdiplus5ImageE
 # <anonymous>:
	.quad	_ZTIN7Gdiplus11GdiplusBaseE
	.globl	_ZTSN7Gdiplus5ImageE
	.section	.rdata$_ZTSN7Gdiplus5ImageE,"dr"
	.linkonce same_size
	.align 16
_ZTSN7Gdiplus5ImageE:
	.ascii "N7Gdiplus5ImageE\0"
	.globl	_ZTIN7Gdiplus11GdiplusBaseE
	.section	.rdata$_ZTIN7Gdiplus11GdiplusBaseE,"dr"
	.linkonce same_size
	.align 8
_ZTIN7Gdiplus11GdiplusBaseE:
 # <anonymous>:
 # <anonymous>:
	.quad	_ZTVN10__cxxabiv117__class_type_infoE+16
 # <anonymous>:
	.quad	_ZTSN7Gdiplus11GdiplusBaseE
	.globl	_ZTSN7Gdiplus11GdiplusBaseE
	.section	.rdata$_ZTSN7Gdiplus11GdiplusBaseE,"dr"
	.linkonce same_size
	.align 16
_ZTSN7Gdiplus11GdiplusBaseE:
	.ascii "N7Gdiplus11GdiplusBaseE\0"
	.section .rdata,"dr"
	.align 4
.LC16:
	.long	1127481344
	.def	__gxx_personality_seh0;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) 15.2.0"
	.def	GdipAlloc;	.scl	2;	.type	32;	.endef
	.def	GdipFree;	.scl	2;	.type	32;	.endef
	.def	GdipDisposeImage;	.scl	2;	.type	32;	.endef
	.def	GdipCloneImage;	.scl	2;	.type	32;	.endef
	.def	GdipDeleteBrush;	.scl	2;	.type	32;	.endef
	.def	GdipCreateSolidFill;	.scl	2;	.type	32;	.endef
	.def	_Unwind_Resume;	.scl	2;	.type	32;	.endef
	.def	GdipCloneBrush;	.scl	2;	.type	32;	.endef
	.def	GdipCreateFromHDC;	.scl	2;	.type	32;	.endef
	.def	GdipDeleteGraphics;	.scl	2;	.type	32;	.endef
	.def	GdipDrawImageI;	.scl	2;	.type	32;	.endef
	.def	GdipDrawImageRectI;	.scl	2;	.type	32;	.endef
	.def	GdipFillEllipseI;	.scl	2;	.type	32;	.endef
	.def	GdipResetWorldTransform;	.scl	2;	.type	32;	.endef
	.def	GdipRotateWorldTransform;	.scl	2;	.type	32;	.endef
	.def	GdipSetInterpolationMode;	.scl	2;	.type	32;	.endef
	.def	GdipTranslateWorldTransform;	.scl	2;	.type	32;	.endef
	.def	GdipLoadImageFromFileICM;	.scl	2;	.type	32;	.endef
	.def	GdipLoadImageFromFile;	.scl	2;	.type	32;	.endef
	.def	GdipGetImageHeight;	.scl	2;	.type	32;	.endef
	.def	GdipGetImageWidth;	.scl	2;	.type	32;	.endef
	.def	GdiplusStartup;	.scl	2;	.type	32;	.endef
	.def	GdiplusShutdown;	.scl	2;	.type	32;	.endef
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	rand;	.scl	2;	.type	32;	.endef
	.section	.rdata$.refptr.game, "dr"
	.p2align	3, 0
	.globl	.refptr.game
	.linkonce	discard
.refptr.game:
	.quad	game
	.section	.rdata$.refptr.particles, "dr"
	.p2align	3, 0
	.globl	.refptr.particles
	.linkonce	discard
.refptr.particles:
	.quad	particles
