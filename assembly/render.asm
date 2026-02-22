	.file	"render.c"
	.intel_syntax noprefix
 # GNU C++17 (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -masm=intel -mtune=generic -march=x86-64 -O0 -fno-omit-frame-pointer

# ============================================================================
# FILE:    render.asm
# SOURCE:  src/render.c
# PURPOSE: GDI+ sprite rendering pipeline for Flappy Bird.
#          Loads PNG sprites from disk, draws the game world each frame, and
#          copies the finished back-buffer to the screen (double buffering).
#
# *** WARNING: THIS FILE IS SIGNIFICANTLY MORE COMPLEX THAN game.asm / audio.asm ***
# The C source file includes <gdiplus.h> which pulls in hundreds of lines of
# C++ template and inline method definitions.  The compiler inlines all of those
# into THIS translation unit.  That produces ~1570 lines of GDI+ library code
# BEFORE the first line of game source code appears.
#
# HOW TO READ THIS FILE:
#   - Lines before _Z12GetMedalTexti (approx. line 1640)  → GDI+ library code
#     (inlined constructors, Color helpers, etc.)  Skip this section on first read.
#   - Lines from _Z12GetMedalTexti onward               → YOUR game code
#     (GetMedalText, GetMedalColor, LoadImages, InitGraphics, CleanupGraphics,
#      DrawParticles, DrawScore, DrawGame)              ← Start reading here.
#   - Lines after DrawGame (_ZTVN7Gdiplus...)           → C++ vtables & RTTI data
#
# FUNCTIONS IN THIS FILE (game code only — skip GDI+ header section):
#   GetMedalText(score)           - Return medal label string based on score
#   GetMedalColor(score)          - Return COLORREF for medal badge color
#   LoadImages()                  - Load all PNG sprites via Image::FromFile
#   InitGraphics(hwnd)            - Start GDI+, create back-buffer DC/bitmap
#   CleanupGraphics()             - Delete all Image objects, tear down GDI+
#   DrawParticles(graphics)       - Render all live particles as colored ellipses
#   DrawScore(graphics,score,x,y) - Render score using sprite digit images
#   DrawGame(hdc)                 - Master render function: background → pipes →
#                                   ground → bird → particles → UI → BitBlt
#
# HOW THIS FILE WAS GENERATED:
#   g++ -S -O0 -masm=intel -fno-omit-frame-pointer src/render.c
#   (same flags as game.asm — see game.asm file header for full flag explanation)
#   Note: -fverbose-asm was NOT used here, so you will see the raw compiler
#   comments like  # src/render.c:N  from -fverbose-asm on C source lines, but
#   NOT the register-variable hint comments seen in game.asm.
#
# WINDOWS x64 CALLING CONVENTION (same as all other .asm files):
#   Integer/pointer arguments 1-4  : RCX, RDX, R8, R9
#   Float arguments 1-4            : XMM0, XMM1, XMM2, XMM3
#   Return value (int/ptr)         : RAX
#   Return value (float)           : XMM0
#   Caller must reserve 32 bytes "shadow space" before every CALL
#   Stack must be 16-byte aligned at the point of CALL
#
# C++ NAME MANGLING — render.asm has the most mangling of any file:
#   The C++ compiler encodes full type signatures into function names.
#   Decoding key (Itanium ABI used by g++):
#     _Z          = mangled name prefix
#     N...E       = namespace-qualified name  (e.g. N7Gdiplus8GraphicsE)
#     number+name = name with length prefix   (e.g. 8Graphics)
#     C1          = complete constructor
#     D1          = complete destructor
#     D0          = deleting destructor  (calls D1 then operator delete)
#     K           = const qualifier on 'this'
#     v           = void return / void arg
#     P           = pointer   (PK = pointer to const)
#     R           = reference (RK = const reference)
#     i           = int,   h = unsigned char,  f = float,  E = enum
#
#   GAME FUNCTION NAMES (demangled → mangled):
#     GetMedalText(int)                    → _Z12GetMedalTexti
#     GetMedalColor(int)                   → _Z13GetMedalColori
#     LoadImages()                         → _Z10LoadImagesv
#     InitGraphics(HWND*)                  → _Z12InitGraphicsP6HWND__
#     CleanupGraphics()                    → _Z15CleanupGraphicsv
#     DrawParticles(Gdiplus::Graphics*)    → _Z13DrawParticlesPN7Gdiplus8GraphicsE
#     DrawScore(Gdiplus::Graphics*,int,int,int) → _Z9DrawScorePN7Gdiplus8GraphicsEiii
#     DrawGame(HDC*)                       → _Z8DrawGameP5HDC__
#
#   KEY GDI+ METHOD NAMES (seen in call instructions):
#     Gdiplus::Image::FromFile(wchar_t*, int)       → _ZN7Gdiplus5Image8FromFileEPKwi
#     Gdiplus::Image::GetLastStatus() const         → _ZNK7Gdiplus5Image13GetLastStatusEv
#     Gdiplus::Image::GetWidth()                    → _ZN7Gdiplus5Image8GetWidthEv
#     Gdiplus::Image::GetHeight()                   → _ZN7Gdiplus5Image9GetHeightEv
#     Gdiplus::Color::Color(byte,byte,byte,byte)    → _ZN7Gdiplus5ColorC1Ehhhh
#     Gdiplus::Color::MakeARGB(byte,byte,byte,byte) → _ZN7Gdiplus5Color8MakeARGBEhhhh
#     Gdiplus::SolidBrush::SolidBrush(Color&)      → _ZN7Gdiplus10SolidBrushC1ERKNS_5ColorE
#     Gdiplus::SolidBrush::~SolidBrush()           → _ZN7Gdiplus10SolidBrushD1Ev
#     Gdiplus::Graphics::Graphics(HDC*)             → _ZN7Gdiplus8GraphicsC1EP5HDC__
#     Gdiplus::Graphics::~Graphics()               → _ZN7Gdiplus8GraphicsD1Ev
#     Gdiplus::Graphics::DrawImage(Image*,int,int)     → _ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii
#     Gdiplus::Graphics::DrawImage(Image*,int,int,int,int) → _ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii
#     Gdiplus::Graphics::FillEllipse(Brush*,int,int,int,int) → _ZN7Gdiplus8Graphics11FillEllipseEPKNS_5BrushEiiii
#     Gdiplus::Graphics::SetInterpolationMode(mode) → _ZN7Gdiplus8Graphics20SetInterpolationModeENS_17InterpolationModeE
#     Gdiplus::Graphics::TranslateTransform(x,y)    → _ZN7Gdiplus8Graphics18TranslateTransformEffNS_11MatrixOrderE
#     Gdiplus::Graphics::RotateTransform(angle)     → _ZN7Gdiplus8Graphics15RotateTransformEfNS_11MatrixOrderE
#     Gdiplus::Graphics::ResetTransform()           → _ZN7Gdiplus8Graphics14ResetTransformEv
#
# GDI+ DOUBLE-BUFFER ARCHITECTURE:
#   Problem: Drawing directly to screen causes visible flicker (each element
#            drawn one-at-a-time is briefly visible as the next draws).
#   Solution: Draw everything to an off-screen bitmap (the "back buffer"),
#             then copy the completed frame to the screen in one fast blit.
#
#   The back-buffer components (global variables in .bss section):
#     hdcBackBuffer  — an off-screen GDI Device Context (like a virtual screen)
#     hbmBackBuffer  — a GDI Bitmap object (the off-screen pixel memory)
#     gdiplusToken   — ULONG_PTR returned by GdiplusStartup, used to shutdown GDI+
#
#   Rendering flow each frame:
#     1. Graphics graphics(hdcBackBuffer)   — wrap back-buffer DC in GDI+ object
#     2. Draw all scene elements into graphics (writes to off-screen bitmap)
#     3. BitBlt(hdc, ..., hdcBackBuffer, ..., SRCCOPY)  — copy back-buffer to screen
#     This ensures the screen only sees complete frames, eliminating flicker.
#
# VIRTUAL FUNCTION DISPATCH IN C++ (important for understanding CleanupGraphics):
#   GDI+ Image, Brush, SolidBrush are C++ classes with virtual destructors.
#   When you call  delete ptr   where ptr is an Image*, the compiler does NOT
#   generate a direct call — it uses a vtable lookup:
#     mov rdx, [rax]        ; rdx = vtable pointer (stored at object[0])
#     add rdx, 8            ; rdx = &vtable[1]  (skip vtable offset slot)
#     mov rdx, [rdx]        ; rdx = destructor function pointer
#     mov rcx, rax          ; rcx = 'this'  (arg1)
#     call rdx              ; call virtual destructor
#   This guarantees the most-derived destructor runs even through a base pointer.
#
# .linkonce discard / .linkonce same_size DIRECTIVES:
#   GDI+ inline methods are emitted into their own named sections with .linkonce.
#   When multiple translation units include <gdiplus.h>, each emits its own copy.
#   The linker discards all but one copy (for 'discard') or keeps the largest
#   (for 'same_size').  This prevents duplicate symbol errors.
#
# .refptr.game / .refptr.particles:
#   Because game[] and particles[] are defined in game.c (a separate translation
#   unit), render.c cannot access them with simple [rip] addressing.
#   The linker generates indirection pointers:
#     .refptr.game:     .quad game      ; 8-byte pointer → game global
#     .refptr.particles:.quad particles ; 8-byte pointer → particles global
#   Code loads these via:
#     mov rax, .refptr.game[rip]   ; rax = address of game struct
#     mov eax, [rax+offset]        ; eax = game.field
# ============================================================================

	.text

# ============================================================================
# SECTION 1: GDI+ HEADER INLINED CODE  (~lines 146 to ~1640)
# ============================================================================
# *** YOU DO NOT NEED TO STUDY THIS SECTION FOR THE GAME LOGIC ***
#
# Everything in this section comes from:
#   #include <gdiplus.h>   (which the C++ compiler pulls into render.c)
#
# The gdiplus.h header defines many C++ class methods as 'inline', meaning
# the compiler is REQUIRED to emit their machine code into every translation
# unit that uses them.  Because render.c uses Gdiplus::Color, Gdiplus::Image,
# Gdiplus::Graphics, and Gdiplus::SolidBrush — all of their constructors,
# destructors, and helper methods end up compiled into render.asm.
#
# FUNCTIONS INLINED FROM GDI+ HEADERS (partial list):
#   _ZN7Gdiplus19GdiplusStartupInputC1EPvii  = GdiplusStartupInput::GdiplusStartupInput(...)
#   _ZN7Gdiplus5Color8MakeARGBEhhhh          = Color::MakeARGB(alpha, r, g, b)
#   _ZN7Gdiplus5ColorC1Ehhhh                 = Color::Color(alpha, r, g, b)
#   _ZN7Gdiplus10SolidBrushC1ERKNS_5ColorE   = SolidBrush::SolidBrush(const Color&)
#   _ZN7Gdiplus10SolidBrushD1Ev              = SolidBrush::~SolidBrush()
#   _ZN7Gdiplus8GraphicsC1EP5HDC__           = Graphics::Graphics(HDC*)
#   _ZN7Gdiplus8GraphicsD1Ev                 = Graphics::~Graphics()
#   _ZN7Gdiplus8Graphics9DrawImageE...       = Graphics::DrawImage(...) [overloads]
#   _ZN7Gdiplus8Graphics11FillEllipseE...    = Graphics::FillEllipse(...)
#   (... and ~60 more GDI+ methods ...)
#
# INTERESTING PATTERN TO NOTICE: the GDI+ C++ methods call the underlying
# GDI+ C API functions (which are the real implementations in gdiplus.dll):
#   Graphics::DrawImage(...)  → calls GdipDrawImageRectI(...)
#   Graphics::FillEllipse()   → calls GdipFillEllipseI(...)
#   SolidBrush::SolidBrush()  → calls GdipCreateSolidFill(...)
#   etc.
# This two-level pattern (C++ wrapper → C function) is a common Windows API design.
#
# .text$_ZN7...  NAMED SECTIONS WITH LINKONCE:
#   Each GDI+ method gets its own named .text section:
#     .section .text$_ZN7Gdiplus19GdiplusStartupInputC1EPvii,"x"
#   The "x" flag marks it as executable code.  The .linkonce discard directive
#   tells the linker to keep only ONE copy across all translation units that
#   include this header.  Without this, linking multiple .o files would fail
#   with "duplicate symbol" errors for every inlined GDI+ method.
#
# SKIP TO LINE ~1640 for the first line of your game source code: GetMedalText()
# ============================================================================
	.section .rdata,"dr"
	.align 4
_ZN7GdiplusL15FlatnessDefaultE:
	.long	1048576000              # GDI+ FlatnessDefault = 0.25f (IEEE 754 bits)
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
	.ascii "BRONZE\0"                # medal label for score >= 10

# ============================================================================
# SECTION 2: GAME SOURCE CODE BEGINS HERE
# ============================================================================
# Everything below this line corresponds directly to src/render.c.
# The .LC0-.LC3 string constants above are the medal tier labels.
#
# STRING CONSTANT MAP (.rdata section above):
#   .LC0  = "PLATINUM\0"  — score >= 40
#   .LC1  = "GOLD\0"      — score >= 30
#   .LC2  = "SILVER\0"    — score >= 20
#   .LC3  = "BRONZE\0"    — score >= 10
# ============================================================================

# ============================================================================
# FUNCTION: GetMedalText(int score)  →  const char*
# SOURCE:   src/render.c:20-26
# MANGLED:  _Z12GetMedalTexti
#
# PURPOSE: Returns a pointer to a medal tier label string based on score.
#          Returns NULL (0) if score < 10 (no medal).
#
# ARGUMENT:
#   ECX = score  (int, Win64 arg1)
#
# RETURN VALUE:
#   RAX = pointer to null-terminated medal string, or 0 (NULL)
#
# STACK FRAME:
#   push rbp; mov rbp, rsp    — minimal frame, no sub rsp (no local vars)
#   [rbp+16] = score          — shadow space, ecx spilled here
#
# PATTERN: Cascade of integer comparisons, each compiling  ">= N"  as  "> N-1"
#   In assembly, there is no "jge" that works for "x >= N" cleanly.
#   The compiler transforms:  if (score >= 40)  →  cmp score, 39; jle skip
#   ("if score is NOT > 39, skip this branch")
#   This avoids a separate subtraction and keeps comparisons efficient.
#
# RETURN MECHANISM: All return paths set RAX then jump to .L87 (the ret).
#   The final  mov eax, 0  in .L90 sets RAX = NULL for the "no medal" case.
# ============================================================================
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
# ============================================================================
# FUNCTION: GetMedalColor(int score)  →  COLORREF
# SOURCE:   src/render.c:29-35
# MANGLED:  _Z13GetMedalColori
#
# PURPOSE: Returns a Windows COLORREF (packed BGR 32-bit int) for the medal
#          badge color corresponding to the score tier.
#
# ARGUMENT:
#   ECX = score  (int, Win64 arg1)
#
# RETURN VALUE:
#   EAX = COLORREF  — a Windows RGB() macro result packed as 0x00BBGGRR
#   NOTE: Windows RGB() stores bytes as R in bits 0-7, G in bits 8-15, B in 16-23.
#         The compiler pre-computes the full packed constant at compile time,
#         so no RGB() function call appears in the assembly — just  mov eax, value.
#
# PRE-COMPUTED COLORREF VALUES (the compiler folds RGB() at compile time):
#   RGB(229,228,226) = 0x00E4E4E5 = 14869733  — PLATINUM (near-white silver)
#   RGB(255,215,  0) = 0x0000D7FF = 55295      — GOLD     (golden yellow)
#   RGB(192,192,192) = 0x00C0C0C0 = 12632256   — SILVER   (grey)
#   RGB(205,127, 50) = 0x00327FCD = 3309517    — BRONZE   (copper-brown)
#   RGB(255,255,255) = 0x00FFFFFF = 16777215   — WHITE    (no medal)
#
# PATTERN: Same ">= N compiled as > N-1" cascade as GetMedalText().
#   No pointer lookups needed — all return values are integer immediates.
# ============================================================================
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
# ============================================================================
# STRING CONSTANTS FOR LoadImages() — Wide-Character (UTF-16LE) File Paths
# ============================================================================
# Image::FromFile() takes a const wchar_t* (wide string), NOT a regular char*.
# On Windows, wchar_t is 2 bytes (UTF-16LE encoding).
# The compiler emits wide strings as .ascii with \0 inserted after each character:
#   "a\0s\0s\0e\0t\0s\0"  = UTF-16LE for "assets" (each char is 2 bytes)
# The final \0\0 is the UTF-16LE null terminator (2 zero bytes).
# This is why each sprite path looks double-spaced — it literally is, in memory.
#
# .LC4  = L"assets/sprites_desktop/background-day.png"
# .LC5  = L"assets/sprites_desktop/base.png"
# .LC6  = L"assets/sprites_desktop/pipe-green.png"
# .LC7  = L"assets/sprites_desktop/yellowbird-downflap.png"  (birdFrame[0])
# .LC8  = L"assets/sprites_desktop/yellowbird-midflap.png"   (birdFrame[1])
# .LC9  = L"assets/sprites_desktop/yellowbird-upflap.png"    (birdFrame[2])
# .LC10 = L"assets/sprites_desktop/%d.png"  (format template for digit sprites)
# .LC11 = L"assets/sprites_desktop/gameover.png"
# .LC12 = L"assets/sprites_desktop/message.png"
# ============================================================================
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
# ============================================================================
# FUNCTION: LoadImages()  →  BOOL
# SOURCE:   src/render.c:38-69
# MANGLED:  _Z10LoadImagesv
#
# PURPOSE: Loads all game sprite PNG files from disk into Image* global pointers.
#          Returns TRUE if all images loaded successfully, FALSE on any failure.
#
# ARGUMENTS: none
#
# RETURN VALUE:
#   EAX = 0 (FALSE) if any image failed to load, else 0 (wait — see below)
#   Actually: returns 0=FALSE (failure) or the function reaches the end
#   returning whatever was last in EAX (implies TRUE path falls through).
#
# STACK FRAME:
#   sub rsp, 560           — large allocation! 560 bytes for:
#                            • 32 bytes Win64 shadow space
#                            • 256-byte WCHAR numPath[256] buffer  (swprintf target)
#                            • padding and alignment
#   lea rbp, 128[rsp]      — rbp is offset from rsp, not at rsp.
#                            [rbp+N] locals are positive, [rsp+M] is shadow space.
#
# IMAGE LOADING PATTERN (repeated for each sprite):
#   1. lea rcx, .LC4[rip]            ; rcx = wide-string path (wchar_t*)
#      mov edx, 0                    ; edx = useEmbeddedColorManagement = false
#      call Image::FromFile           ; returns Image* in RAX
#      mov imgBackground[rip], rax   ; store pointer globally
#
#   2. mov rax, imgBackground[rip]   ; reload pointer
#      test rax, rax                 ; is it NULL?
#      je .L98                       ; NULL → error
#      mov rcx, rax
#      call Image::GetLastStatus()   ; returns Gdiplus::Status enum
#      test eax, eax                 ; is status == Ok (0)?
#      je .L99                       ; Ok → continue
#   .L98: (failure path)
#      mov eax, 0                    ; iftmp = TRUE (error condition)
#      jmp .L100
#   .L99: (success path)
#      mov eax, 0                    ; iftmp = FALSE (no error)
#   .L100:
#      test al, al                   ; if error flag set:
#      je .L101                      ; no error → continue to next image
#      mov eax, 0                    ; RETURN FALSE
#      jmp .L131                     ; jump to epilogue
#
#   NOTE: The compiler's iftmp pattern looks confusing because it tests the
#   ABSENCE of an error. "iftmp = 1" means "the NULL-check or status-check fired",
#   and then al=1 means "there WAS an error" → return FALSE.
#
# DIGIT SPRITES:
#   For imgNumbers[0..9], the C code uses:
#     swprintf(numPath, 256, L"assets/sprites_desktop/%d.png", i)
#   swprintf is the wide-char version of sprintf.  The .LC10 wide string is
#   the format template with %d for the digit index.
#
# GLOBALS WRITTEN:
#   imgBackground    — background-day.png
#   imgGround        — base.png
#   imgPipeGreen     — pipe-green.png
#   imgBirdFrames[0] — yellowbird-downflap.png
#   imgBirdFrames[1] — yellowbird-midflap.png
#   imgBirdFrames[2] — yellowbird-upflap.png
#   imgNumbers[0..9] — 0.png through 9.png
#   imgGameOver      — gameover.png
#   imgMessage       — message.png
# ============================================================================
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
	.ascii "Error\0"                 # MessageBox title for sprite load failure
	.align 8
.LC14:
	.ascii "Failed to load game sprites!\12Make sure assets/sprites_desktop folder exists.\0"
	                                 # \12 is octal for newline (\n). MessageBox body text.

# ============================================================================
# FUNCTION: InitGraphics(HWND* hwnd)  →  void
# SOURCE:   src/render.c:71-84
# MANGLED:  _Z12InitGraphicsP6HWND__
#
# PURPOSE: One-time initialization at game startup:
#   1. Start the GDI+ rendering subsystem (GdiplusStartup)
#   2. Create the off-screen back-buffer for double-buffering
#   3. Load all sprite images from disk (LoadImages)
#   4. Show an error MessageBox if sprites couldn't be loaded
#
# ARGUMENT:
#   RCX = hwnd  (HWND*, pointer to window handle, Win64 arg1)
#
# STACK FRAME:
#   sub rsp, 64     — 64 bytes: 32 shadow + 32 bytes for local GdiplusStartupInput struct
#   [rbp+16]        = hwnd argument (spilled from RCX)
#   [rbp-8]         = hdc (temp HDC from GetDC, used to create compatible DC)
#   [rbp-32]        = gdiplusStartupInput (GdiplusStartupInput struct, 24 bytes)
#                     Layout: [rbp-32]=GdiplusVersion(1), [rbp-24]=DebugEventCallback(0),
#                             [rbp-16]=SuppressBackgroundThread(0), [rbp-12]=SuppressExternalCodecs(0)
#
# STEP-BY-STEP:
#
#   --- GDI+ STARTUP ---
#   lea rax, -32[rbp]           ; rax = &gdiplusStartupInput (stack-local struct)
#   mov r9d,r8d,edx = 0         ; constructor args: NULL, 0, 0 (suppress options)
#   mov rcx, rax
#   call GdiplusStartupInput::GdiplusStartupInput(NULL,0,0)
#                               ; Initialize the struct on the stack
#   lea rax, -32[rbp]           ; rax = &gdiplusStartupInput
#   lea rcx, gdiplusToken[rip]  ; rcx = &gdiplusToken (output token)
#   mov r8d, 0                  ; r8 = NULL (no output for GdiplusStartupOutput)
#   mov rdx, rax                ; rdx = &gdiplusStartupInput
#   call GdiplusStartup          ; starts GDI+ subsystem, fills gdiplusToken
#
#   --- BACK BUFFER CREATION ---
#   mov rcx, hwnd
#   call GetDC(hwnd)            ; rax = screen DC for the game window
#   mov [rbp-8], rax            ; hdc = screen DC
#   mov rcx, hdc
#   call CreateCompatibleDC(hdc) ; creates an off-screen DC matching screen format
#   mov hdcBackBuffer[rip], rax  ; store it globally
#   mov edx, 1280               ; width = WINDOW_WIDTH
#   mov r8d, 720                ; height = WINDOW_HEIGHT
#   call CreateCompatibleBitmap(hdc, 1280, 720) ; creates the off-screen bitmap
#   mov hbmBackBuffer[rip], rax  ; store globally
#   call SelectObject(hdcBackBuffer, hbmBackBuffer) ; link bitmap into the DC
#   call ReleaseDC(hwnd, hdc)    ; release the screen DC (no longer needed)
#
#   --- SPRITE LOADING ---
#   call LoadImages()           ; load all PNG sprites
#   test eax, eax               ; did LoadImages return non-zero (success)?
#   sete al                     ; al = 1 if LoadImages returned 0 (failure)
#   test al, al                 ; is it a failure?
#   je .L134                    ; if success, skip error box
#   call MessageBoxA(hwnd, .LC14, .LC13, MB_ICONERROR=16)
#   .L134:
#   nop; epilogue
#
# NOTE ON sete: This is "set byte if equal" — sets AL=1 if ZF=1 (i.e., if the
# previous test set ZF, meaning LoadImages returned 0).  Combined with test eax,eax,
# "sete al" gives al=1 when eax was 0 (FALSE return from LoadImages = failure).
# ============================================================================
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
# ============================================================================
# FUNCTION: CleanupGraphics()  →  void
# SOURCE:   src/render.c:86-98
# MANGLED:  _Z15CleanupGraphicsv
#
# PURPOSE: Release all GDI+ resources at program exit:
#   1. delete all Image* sprite objects (using virtual destructor dispatch)
#   2. DeleteObject(hbmBackBuffer) — free the GDI bitmap
#   3. DeleteDC(hdcBackBuffer)    — free the off-screen DC
#   4. GdiplusShutdown(gdiplusToken) — shut down GDI+ subsystem
#
# ARGUMENTS: none
#
# STACK FRAME:
#   sub rsp, 48   — 48 bytes: 32 shadow + 8 local (i) + 8 alignment
#   [rbp-4]  = i  (loop counter for imgBirdFrames loop)
#   [rbp-8]  = i  (loop counter for imgNumbers loop)
#
# VIRTUAL DESTRUCTOR DISPATCH — "delete imgBackground" compiles to:
#   mov rax, imgBackground[rip]   ; rax = Image* pointer
#   test rax, rax                 ; is it NULL?
#   je .L136                      ; if NULL, skip (already deleted or never loaded)
#   mov rax, imgBackground[rip]   ; reload (redundant check emitted by -O0)
#   test rax, rax                 ; second null check
#   je .L136
#   mov rdx, [rax]                ; rdx = vtable pointer (first 8 bytes of object)
#   add rdx, 8                    ; rdx points to vtable[1] (skip vtable offset entry)
#   mov rdx, [rdx]                ; rdx = virtual destructor function pointer
#   mov rcx, rax                  ; rcx = 'this' pointer
#   call rdx                      ; call virtual destructor (dispatched via vtable)
#
# WHY TWO NULL CHECKS?
#   The -O0 flag prevents any optimization. The compiler emits the null check
#   twice: once for the outer  if (imgBackground)  and once for the inner
#   implicit check that C++ inserts before calling delete on a pointer.
#   With -O2 these would collapse into one check.
#
# ARRAY ELEMENT LOOP: For imgBirdFrames[i] (i=0..2) and imgNumbers[i] (i=0..9):
#   cdqe                ; sign-extend i from EAX to RAX (for 64-bit addressing)
#   lea rdx, [rax*8]    ; rdx = i*8  (each Image* is 8 bytes, pointer-sized)
#   lea rax, imgBirdFrames[rip] ; rax = base of pointer array
#   mov rax, [rdx+rax]  ; rax = imgBirdFrames[i]
#   (then same virtual destructor dispatch as above)
# ============================================================================
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
# ============================================================================
# FUNCTION: DrawParticles(Gdiplus::Graphics* graphics)  →  void
# SOURCE:   src/render.c:100-112
# MANGLED:  _Z13DrawParticlesPN7Gdiplus8GraphicsE
#
# PURPOSE: Iterate all 50 particle slots. For any particle with life > 0,
#          extract its color channels, compute alpha from remaining life,
#          create a GDI+ Color+SolidBrush, and draw a 4x4 pixel ellipse.
#
# ARGUMENT:
#   RCX = graphics  (Gdiplus::Graphics*, Win64 arg1)
#
# STACK FRAME:
#   push rbx           — RBX is callee-saved; needed to preserve across exception path
#   sub rsp, 104       — 104 bytes: 32 shadow + 36-byte SolidBrush struct +
#                        12-byte Color struct + loop var + alignment
#   lea rbp, 96[rsp]   — rbp is offset from rsp
#   [rbp+32]           = graphics argument
#   [rbp-4]            = i  (loop counter, 0..49)
#   [rbp-8]            = alpha  (computed transparency)
#   [rbp-12]           = color (Gdiplus::Color struct, 4 bytes)
#   [rbp-48]           = brush (Gdiplus::SolidBrush object, ~36 bytes on stack)
#
# PARTICLE STRUCT INDEXING (i*24, same pattern as game.asm chunk 5):
#   Particle struct = 24 bytes: x(4)+y(4)+vx(4)+vy(4)+color(4)+life(4)
#   i*24 computed as:  rdx=i; rax=rdx; rax+=rax(=2i); rax+=rdx(=3i); rax<<=3(=24i)
#   particles[i].life  is at offset 16 from particles[i] base
#   particles[i].color is at offset 20
#   particles[i].y     is at offset 4
#   particles[i].x     is at offset 0
#
# COLOR CHANNEL EXTRACTION from COLORREF (Windows BGR format):
#   The Windows COLORREF stores: bits 0-7=R, bits 8-15=G, bits 16-23=B
#   GetRValue(color) = (color >> 16) & 0xFF  → Blue channel (confusingly named)
#   GetGValue(color) = (color >> 8)  & 0xFF  → Green channel
#   GetBValue(color) = (color >> 0)  & 0xFF  → Red channel (confusingly named)
#
#   In assembly:
#     shr eax, 16 ; movzx ecx, al  → R argument (actually the Blue byte)
#     shr ax, 8   ; movzx r9d, al  → G argument
#     movzx r8d, al               → B argument (Red byte)
#
#   These go into Color::Color(alpha, r, g, b) as:
#     rcx = this (Color struct address on stack)
#     edx = alpha (byte, from [rbp-8])
#     r8d = R byte extracted from color (bit 16-23 of COLORREF)
#     r9d = G byte (bit 8-15)
#     [rsp+32] = B byte (bit 0-7)  ← 5th argument goes on stack
#
# ALPHA COMPUTATION:
#   alpha = (life * 255) / 40
#   Compiler implements (life*255): life<<8 - life = life*(256-1) = life*255
#   Then divides by 40 using magic number 1717986919 (same trick as game.asm)
#   This makes particles fade out from fully opaque (life=40) to transparent (life=1).
#
# C++ EXCEPTION HANDLING (LSDA tables at end of function):
#   SolidBrush is constructed on the stack. If FillEllipse() throws an exception,
#   the C++ runtime must destroy the SolidBrush (call its destructor) before
#   unwinding. The .seh_handler / LLSDA tables encode which instructions are
#   "within the SolidBrush lifetime" for the exception unwinder.
#   The .LEHB/.LEHE labels mark the begin/end of exception-active regions.
#   This machinery is automatic C++ RAII — it doesn't affect normal execution.
# ============================================================================
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

# ============================================================================
# STRING CONSTANT FOR DrawScore() — sprintf format
# ============================================================================
# .LC15  = "%d\0"  — format string passed to __mingw_sprintf to convert
#          the integer score into a decimal ASCII string ("0", "42", "123"...)
# ============================================================================
	.section .rdata,"dr"
.LC15:
	.ascii "%d\0"

# ============================================================================
# FUNCTION: DrawScore(Gdiplus::Graphics* graphics, int score, int centerX, int y)
# SOURCE:   src/render.c:114-133
# MANGLED:  _Z9DrawScorePN7Gdiplus8GraphicsEiii
#
# PURPOSE: Render the score value on screen using pre-loaded digit sprite images.
#          Converts the integer score to a string, measures the total pixel width
#          of all digit sprites, then draws them centered around centerX.
#
# ARGUMENTS (Win64 calling convention — see audio.asm header for full ABI):
#   RCX = graphics*  — Gdiplus::Graphics* object to draw into
#   EDX = score      — integer score value to display
#   R8D = centerX    — X pixel coordinate to center digits around
#   R9D = y          — Y pixel coordinate for top of digit sprites
#
# RETURN VALUE: void (no return)
#
# STACK FRAME (sub rsp, 80  →  80 bytes total):
#   [rbp+16]  = graphics  (spilled from RCX — 8 bytes)
#   [rbp+24]  = score     (spilled from EDX — 4 bytes)
#   [rbp+32]  = centerX   (spilled from R8D — 4 bytes)
#   [rbp+40]  = y         (spilled from R9D — 4 bytes)
#   [rbp- 4]  = totalWidth (int) — accumulates total pixel width of all digits
#   [rbp- 8]  = i         (int, loop 1 — measure pass)
#   [rbp-12]  = x         (int) — current X draw position (advances each digit)
#   [rbp-16]  = i         (int, loop 2 — draw pass)
#   [rbp-20]  = len       (int) — result of strlen(scoreStr)
#   [rbp-24]  = digit     (int, draw loop)
#   [rbp-28]  = digit     (int, measure loop)
#   [rbp-48]  = scoreStr[16] — char buffer target for sprintf
#   + 32 bytes Win64 shadow space at bottom of frame
#
# ALGORITHM — TWO PASSES over the digit character string:
#
#   Step 1: sprintf(scoreStr, "%d", score)
#           Converts the integer score to decimal ASCII string in scoreStr[].
#           e.g. score=42  →  scoreStr[] = "42\0"
#               score=0   →  scoreStr[] = "0\0"
#
#   Step 2: len = strlen(scoreStr)
#           Count how many digit characters there are.
#
#   PASS 1 — MEASURE (loop .L160):
#     for i=0; i<len; i++
#       digit = scoreStr[i] - '0'        ← subtract ASCII 48 to get index 0..9
#       if (imgNumbers[digit] != NULL)
#         totalWidth += imgNumbers[digit]->GetWidth()
#     Goal: find the total pixel width so the score can be centered.
#
#   Centering:
#     x = centerX - totalWidth / 2       ← left edge of first digit
#     (signed division by 2 uses SAR trick — see below)
#
#   PASS 2 — DRAW (loop .L163):
#     for i=0; i<len; i++
#       digit = scoreStr[i] - '0'
#       if (imgNumbers[digit] != NULL)
#         graphics->DrawImage(imgNumbers[digit], x, y)  ← draw digit sprite
#         x += imgNumbers[digit]->GetWidth()            ← advance cursor right
#
# KEY INSTRUCTION PATTERNS:
#
#   Array indexing — imgNumbers[digit]:
#     cdqe                       ; sign-extend digit (EAX) to 64-bit RAX
#     lea rdx, 0[0+rax*8]       ; rdx = digit * 8  (Image* pointers are 8 bytes)
#     lea rax, imgNumbers[rip]   ; rax = base address of imgNumbers[] global array
#     mov rax, [rdx+rax]         ; rax = imgNumbers[digit]  (dereference pointer)
#
#   Character extraction — scoreStr[i] - '0':
#     cdqe                               ; sign-extend i (EAX) to 64-bit RAX
#     movzx eax, BYTE PTR -48[rbp+rax]  ; load byte scoreStr[i], zero-extend
#     movsx eax, al                      ; sign-extend byte AL to full int EAX
#     sub eax, 48                        ; subtract ASCII '0' (48) → value 0..9
#
#   Signed division by 2 for centering (-(totalWidth/2)):
#     mov edx, eax   ; copy totalWidth
#     shr edx, 31    ; shift sign bit to bit 0 — gives 1 if negative, 0 if positive
#     add eax, edx   ; bias: rounds toward zero for negative values
#     sar eax        ; arithmetic right shift by 1 = divide by 2 (with correct rounding)
#     neg eax        ; negate because formula is centerX MINUS half-width
#   This is GCC's canonical -O0 pattern for signed integer division by 2.
# ============================================================================
	.text
	.globl	_Z9DrawScorePN7Gdiplus8GraphicsEiii
	.def	_Z9DrawScorePN7Gdiplus8GraphicsEiii;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9DrawScorePN7Gdiplus8GraphicsEiii
_Z9DrawScorePN7Gdiplus8GraphicsEiii:
.LFB8697:
	# --- PROLOGUE ---
	push	rbp	 #
	.seh_pushreg	rbp
	mov	rbp, rsp	 #,
	.seh_setframe	rbp, 0
	sub	rsp, 80	 #                 ; 80 bytes: shadow(32) + locals(48)
	.seh_stackalloc	80
	.seh_endprologue
	# Spill all 4 arguments to shadow space above rbp
	mov	QWORD PTR 16[rbp], rcx	 # graphics, graphics
	mov	DWORD PTR 24[rbp], edx	 # score, score
	mov	DWORD PTR 32[rbp], r8d	 # centerX, centerX
	mov	DWORD PTR 40[rbp], r9d	 # y, y

	# --- STEP 1: sprintf(scoreStr, "%d", score) ---
	# Convert integer score to decimal string in scoreStr[] at [rbp-48]
	# __mingw_sprintf(rcx=scoreStr, rdx="%d", r8d=score)
 # src/render.c:116:     sprintf(scoreStr, "%d", score);
	mov	ecx, DWORD PTR 24[rbp]	 # tmp115, score
	lea	rdx, .LC15[rip]	 # tmp116,    ; rdx = &"%d"
	lea	rax, -48[rbp]	 # tmp117,     ; rax = &scoreStr[0]
	mov	r8d, ecx	 #, tmp115            ; r8d = score
	mov	rcx, rax	 #, tmp117            ; rcx = &scoreStr
	call	__mingw_sprintf	 #           ; fills scoreStr with "0","42","123"…

	# --- STEP 2: len = strlen(scoreStr) ---
	# Count how many digit characters the string has (1 digit for 0-9, 2 for 10-99…)
 # src/render.c:117:     int len = strlen(scoreStr);
	lea	rax, -48[rbp]	 # tmp118,     ; rax = &scoreStr[0]
	mov	rcx, rax	 #, tmp118            ; rcx = &scoreStr
	call	strlen	 #                   ; returns length in EAX
 # src/render.c:117:     int len = strlen(scoreStr);
	mov	DWORD PTR -20[rbp], eax	 # len, _1   ; store len at [rbp-20]

	# --- PASS 1: MEASURE — totalWidth = 0; for(i=0;i<len;i++) totalWidth+=digit_width ---
 # src/render.c:119:     int totalWidth = 0;
	mov	DWORD PTR -4[rbp], 0	 # totalWidth,  ; initialize totalWidth = 0
 # src/render.c:120:     for (int i = 0; i < len; i++) {
	mov	DWORD PTR -8[rbp], 0	 # i,           ; i = 0 (measure loop counter)
 # src/render.c:120:     for (int i = 0; i < len; i++) {
	jmp	.L158	 #                   ; jump to loop condition first (do-while pattern)
.L160:                                   # === MEASURE LOOP BODY ===
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
	# --- MEASURE LOOP: increment i and check condition ---
 # src/render.c:120:     for (int i = 0; i < len; i++) {
	add	DWORD PTR -8[rbp], 1	 # i,       ; i++
.L158:                                   # === MEASURE LOOP CONDITION ===
 # src/render.c:120:     for (int i = 0; i < len; i++) {
	mov	eax, DWORD PTR -8[rbp]	 # tmp130, i
	cmp	eax, DWORD PTR -20[rbp]	 # tmp130, len  ; i < len?
	jl	.L160	 #,                  ; yes → loop back to body

	# --- CENTERING: x = centerX - totalWidth / 2 ---
	# Implements signed division by 2 then negation using shift+bias trick.
	# Equivalent C: x = centerX - (totalWidth >> 1)  (for non-negative totalWidth)
 # src/render.c:125:     int x = centerX - totalWidth / 2;
	mov	eax, DWORD PTR -4[rbp]	 # tmp131, totalWidth
	mov	edx, eax	 # tmp132, tmp131   ; edx = totalWidth
	shr	edx, 31	 # tmp132,           ; edx = sign bit (1 if negative)
	add	eax, edx	 # tmp133, tmp132   ; bias for rounding toward zero
	sar	eax	 # _8                    ; EAX = totalWidth / 2  (signed)
	neg	eax	 # _8                    ; EAX = -(totalWidth / 2)
	mov	edx, eax	 # _8, _8           ; EDX = -(totalWidth / 2)
 # src/render.c:125:     int x = centerX - totalWidth / 2;
	mov	eax, DWORD PTR 32[rbp]	 # tmp138, centerX
	add	eax, edx	 # x_34, _8         ; x = centerX + (-(totalWidth/2))
	mov	DWORD PTR -12[rbp], eax	 # x, x_34   ; store x at [rbp-12]

	# --- PASS 2: DRAW — for(i=0;i<len;i++) draw digit sprite, advance x ---
 # src/render.c:126:     for (int i = 0; i < len; i++) {
	mov	DWORD PTR -16[rbp], 0	 # i,       ; i = 0 (draw loop counter)
 # src/render.c:126:     for (int i = 0; i < len; i++) {
	jmp	.L161	 #                   ; jump to condition first
.L163:                                   # === DRAW LOOP BODY ===
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
.L162:                                   # === DRAW LOOP INCREMENT & CONDITION ===
	# --- DRAW LOOP: increment i and check condition ---
 # src/render.c:126:     for (int i = 0; i < len; i++) {
	add	DWORD PTR -16[rbp], 1	 # i,       ; i++
.L161:
 # src/render.c:126:     for (int i = 0; i < len; i++) {
	mov	eax, DWORD PTR -16[rbp]	 # tmp157, i
	cmp	eax, DWORD PTR -20[rbp]	 # tmp157, len  ; i < len?
	jl	.L163	 #,                  ; yes → loop back

	# --- EPILOGUE ---
	# All digit sprites drawn — clean up frame and return
 # src/render.c:133: }
	nop	
	nop	
	add	rsp, 80	 #,             ; deallocate 80-byte frame
	pop	rbp	 #                 ; restore caller's frame pointer
	ret	                            # return to DrawScore caller
	.seh_endproc

# ============================================================================
# FUNCTION: DrawGame(HDC* hdc)  →  void
# SOURCE:   src/render.c:135-217
# MANGLED:  _Z8DrawGameP5HDC__
#
# PURPOSE: Master rendering function — draws ONE complete game frame.
#          Called from WndProc every WM_PAINT (which fires after each WM_TIMER).
#          Uses double-buffering: draws everything into hdcBackBuffer (off-screen),
#          then copies the finished frame to the screen with a single BitBlt.
#
# ARGUMENT:
#   RCX = hdc  — HDC* handle to the on-screen device context (window surface)
#
# RETURN VALUE: void
#
# STACK FRAME (sub rsp, 168  →  168 bytes):
#   Note: rbp is offset from rsp:  lea rbp, 160[rsp]
#         So  [rbp+N]  is ABOVE rbp (shadow space / args),
#         and [rbp-N]  is BELOW rbp (locals within the 168-byte allocation).
#
#   [rbp+32]  = hdc           (spilled from RCX — 8 bytes, arg shadow)
#   [rbp- 4]  = shakeX        (int — screen shake offset X, 0 if not shaking)
#   [rbp- 8]  = shakeY        (int — screen shake offset Y, 0 if not shaking)
#   [rbp-12]  = i             (int — pipe draw loop counter, 0..2)
#   [rbp-16]  = x             (int — ground tile draw cursor)
#   [rbp-20]  = pipeW         (int — pipe image width from GetWidth())
#   [rbp-24]  = pipeH         (int — pipe image height from GetHeight())
#   [rbp-28]  = pipeX         (int — screen X of pipe + shakeX)
#   [rbp-32]  = topHeight     (int — game.pipes[i].topHeight)
#   [rbp-36]  = bottomPipeY   (int — topHeight + PIPE_GAP + shakeY)
#   [rbp-40]  = groundW       (int — ground image width)
#   [rbp-44]  = groundH       (int — ground image height, unused in draw)
#   [rbp-48]  = groundY       (int — WINDOW_HEIGHT - GROUND_HEIGHT = 608)
#   [rbp-52]  = msgW          (int — "message" sprite width)
#   [rbp-56]  = msgH          (int — "message" sprite height)
#   [rbp-60]  = goW           (int — "gameover" sprite width)
#   [rbp-80]  = graphics      (Gdiplus::Graphics object on stack, ~80 bytes)
#               constructed with Graphics(hdcBackBuffer) — wraps back-buffer DC
#
#   RBX is pushed (callee-saved) to preserve across exception handler path.
#
# DRAW ORDER (layers, back to front — painter's algorithm):
#   1. Background image  (full 1280x720, offset by shakeX/shakeY)
#   2. Pipes (3 pairs): top pipe (rotated 180°), bottom pipe (normal)
#   3. Ground tile (tiled horizontally, scrolls left via game.groundOffset)
#   4. Bird sprite  (at BIRD_X=350, game.bird.y, current birdFrame)
#   5. Particles   (DrawParticles — colored ellipses over bird)
#   6. Score       (if started && !gameOver: DrawScore at top center)
#   7. Message     (if !started: "get ready" message centered)
#   8. Game Over   (if gameOver: "GAME OVER" banner + score)
#   9. BitBlt      (copy back-buffer to screen — single atomic operation)
#
# PIPE ROTATION TRICK (top pipe drawn upside-down):
#   GDI+ does not have a "flip vertically" mode.  Instead, the game uses:
#     TranslateTransform(pipeCenterX, topHeight)  ← move origin to pipe tip
#     RotateTransform(180)                         ← rotate 180 degrees
#     DrawImage(pipeGreen, -pipeW/2, 0, pipeW, pipeH)
#     ResetTransform()                             ← restore identity matrix
#   Net effect: the pipe image is drawn flipped and positioned correctly.
#   The coordinate of the BOTTOM of the top pipe is exactly topHeight.
#
# SCREEN SHAKE:
#   If game.screenShake > 0, shakeX and shakeY are set to small random offsets.
#   Every draw call that takes an (x, y) coordinate adds these offsets,
#   making the entire scene jitter for a brief period after collision.
#   Implemented as:
#     shakeX = rand() % (game.screenShake * 2) - game.screenShake
#     shakeY = rand() % (game.screenShake * 2) - game.screenShake
#   Division via IDIV EBX (EBX = game.screenShake * 2, computed with LEA).
#
# GROUND SCROLLING:
#   game.groundOffset (a float) is decremented each frame in UpdateGame.
#   DrawGame casts it to INT and tiles the ground sprite starting from x=groundOffset,
#   repeating until x >= WINDOW_WIDTH (1280).  The while loop uses:
#     cmp [rbp-16], 1279 ; jle .L172   (loop while x <= 1279)
#
# C++ EXCEPTION HANDLING IN DrawGame:
#   Gdiplus::Graphics is constructed on the stack at [rbp-80].
#   If any GDI+ call between .LEHB9 and .LEHE10 throws a C++ exception,
#   the SEH handler at .L179 destroys the Graphics object before re-throwing.
#   Labels:
#     .LEHB9 / .LEHE9   — exception region for Graphics constructor
#     .LEHB10 / .LEHE10 — exception region for all draw calls
#     .L179             — landing pad: calls Graphics::~Graphics then Unwind_Resume
#   The .LLSDA8698 table at the end of the function maps instruction ranges
#   to these cleanup handlers (Language Specific Data Area).
#
# GAME STATE OFFSETS in the game struct (accessed via .refptr.game):
#   game.bird.y        at offset  0  (float, 4 bytes)
#   game.score         at offset 52  (int)
#   game.gameOver      at offset 60  (int / bool)
#   game.started       at offset 64  (int / bool)
#   game.groundOffset  at offset 80  (float)
#   game.screenShake   at offset 84  (int)
#   game.birdFrame     at offset 92  (int)
#   game.pipes[i].x    at offset 16 + i*12  (Pipe struct = 12 bytes: x,topHeight,passed)
#   game.pipes[i].topHeight at offset 20 + i*12
# ============================================================================
	.globl	_Z8DrawGameP5HDC__
	.def	_Z8DrawGameP5HDC__;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z8DrawGameP5HDC__
_Z8DrawGameP5HDC__:
.LFB8698:
	# --- PROLOGUE ---
	# RBP is pushed first, then RBX (needed to preserve across exception handler).
	# Sub 168 allocates the frame.  rbp = rsp+160 (offset to keep local vars negative).
	push	rbp	 #
	.seh_pushreg	rbp
	push	rbx	 #                 ; RBX is callee-saved — used in screen shake div
	.seh_pushreg	rbx
	sub	rsp, 168	 #,             ; 168 = shadow(32) + locals(128) + alignment(8)
	.seh_stackalloc	168
	lea	rbp, 160[rsp]	 #,         ; rbp = rsp+160 → locals are [rbp-N]
	.seh_setframe	rbp, 160
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx	 # hdc, hdc   ; spill hdc argument

	# --- STEP 1: Construct Graphics object on stack, set interpolation mode ---
	# Graphics::Graphics(HDC*) creates a GDI+ drawing context wrapping the back-buffer DC.
	# InterpolationModeNearestNeighbor (5) = pixel-perfect scaling, no bilinear blur.
	# The .LEHB9/.LEHE9 markers define the exception region for the constructor call
	# — if it throws, the SEH handler will know to skip destructor (not constructed yet).
 # src/render.c:136:     Graphics graphics(hdcBackBuffer);
	mov	rdx, QWORD PTR hdcBackBuffer[rip]	 # hdcBackBuffer.44_1, hdcBackBuffer
	lea	rax, -80[rbp]	 # tmp169,     ; rax = &graphics (stack space at [rbp-80])
	mov	rcx, rax	 #, tmp169        ; rcx = this pointer
.LEHB9:                                  # BEGIN exception region (constructor)
	call	_ZN7Gdiplus8GraphicsC1EP5HDC__	 # Graphics::Graphics(hdcBackBuffer)
.LEHE9:                                  # END exception region (constructor)
 # src/render.c:137:     graphics.SetInterpolationMode(InterpolationModeNearestNeighbor);
	lea	rax, -80[rbp]	 # tmp170,     ; rax = &graphics
	mov	edx, 5	 #,                   ; edx = InterpolationModeNearestNeighbor = 5
	mov	rcx, rax	 #, tmp170        ; rcx = this
.LEHB10:                                 # BEGIN exception region (all draw calls)
	call	_ZN7Gdiplus8Graphics20SetInterpolationModeENS_17InterpolationModeE	 #

	# --- STEP 2: Screen Shake — compute shakeX, shakeY random offsets ---
	# shakeX = shakeY = 0 always; only overwritten if game.screenShake > 0.
	# game.screenShake decrements each frame in UpdateGame until it reaches 0.
 # src/render.c:139:     int shakeX = 0, shakeY = 0;
	mov	DWORD PTR -4[rbp], 0	 # shakeX,   ; default: no shake
 # src/render.c:139:     int shakeX = 0, shakeY = 0;
	mov	DWORD PTR -8[rbp], 0	 # shakeY,
 # src/render.c:140:     if (game.screenShake > 0) {
	mov	rax, QWORD PTR .refptr.game[rip]	 # ; rax = &game struct
	mov	eax, DWORD PTR 84[rax]	 # _2, game.screenShake   ; load screenShake field
 # src/render.c:140:     if (game.screenShake > 0) {
	test	eax, eax	 # _2                             ; is screenShake > 0?
	jle	.L165	 #,                                   ; no → skip shake

	# --- shakeX = rand() % (screenShake*2) - screenShake ---
	# EBX = screenShake * 2  (via LEA [rdx+rdx])
	# IDIV EBX uses signed division; EDX gets the remainder (= rand() % range)
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	call	rand	 #                                    ; EAX = random int
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	mov	rdx, QWORD PTR .refptr.game[rip]	 #
	mov	edx, DWORD PTR 84[rdx]	 # _4, game.screenShake
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	lea	ebx, [rdx+rdx]	 # _5,            ; ebx = screenShake * 2
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	cdq                                        # sign-extend EAX → EDX:EAX for IDIV
	idiv	ebx	 # _5                          ; EDX = EAX % EBX (remainder)
	mov	ecx, edx	 # _6, _6              ; ecx = remainder
	mov	edx, ecx	 # _6, _6              ; edx = remainder (redundant at -O0)
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	eax, DWORD PTR 84[rax]	 # _7, game.screenShake
 # src/render.c:141:         shakeX = (rand() % (game.screenShake * 2)) - game.screenShake;
	sub	edx, eax	 # tmp176, _7          ; edx = remainder - screenShake
	mov	DWORD PTR -4[rbp], edx	 # shakeX, tmp176   ; store shakeX

	# --- shakeY = rand() % (screenShake*2) - screenShake  (same pattern) ---
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	call	rand	 #
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	mov	rdx, QWORD PTR .refptr.game[rip]	 #
	mov	edx, DWORD PTR 84[rdx]	 # _9, game.screenShake
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	lea	ebx, [rdx+rdx]	 # _10,           ; ebx = screenShake * 2
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	cdq
	idiv	ebx	 # _10                         ; EDX = rand() % range
	mov	ecx, edx	 # _11, _11
	mov	edx, ecx	 # _11, _11
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	eax, DWORD PTR 84[rax]	 # _12, game.screenShake
 # src/render.c:142:         shakeY = (rand() % (game.screenShake * 2)) - game.screenShake;
	sub	edx, eax	 # tmp181, _12
	mov	DWORD PTR -8[rbp], edx	 # shakeY, tmp181

	# ===================================================================
	# LAYER 1: BACKGROUND
	# ===================================================================
.L165:
 # src/render.c:146:     if (imgBackground) {
	mov	rax, QWORD PTR imgBackground[rip]	 # imgBackground.45_13, imgBackground
 # src/render.c:146:     if (imgBackground) {
	test	rax, rax	 # imgBackground.45_13     ; is imgBackground loaded?
	je	.L166	 #,                               ; no → skip background draw

	# graphics.DrawImage(imgBackground, shakeX, shakeY, WINDOW_WIDTH, WINDOW_HEIGHT)
	# 5-argument DrawImage: draws image scaled to fit the specified rectangle.
	# Win64: first 4 args in RCX,RDX,R8,R9; 5th and 6th go on stack at [rsp+32],[rsp+40]
 # src/render.c:147:         graphics.DrawImage(imgBackground, shakeX, shakeY, (INT)WINDOW_WIDTH, (INT)WINDOW_HEIGHT);
	mov	rdx, QWORD PTR imgBackground[rip]	 # ; rdx = imgBackground (Image* arg2)
	mov	r8d, DWORD PTR -8[rbp]	 # tmp182, shakeY   ; r8d = shakeY (x arg3 = shakeX, see below)
	mov	ecx, DWORD PTR -4[rbp]	 # tmp183, shakeX
	lea	rax, -80[rbp]	 # tmp184,             ; rax = &graphics (this)
	mov	DWORD PTR 40[rsp], 720	 #,            ; [rsp+40] = height = 720 (arg6 on stack)
	mov	DWORD PTR 32[rsp], 1280	 #,           ; [rsp+32] = width  = 1280 (arg5 on stack)
	mov	r9d, r8d	 #, tmp182                 ; r9d = shakeY (y, arg4)
	mov	r8d, ecx	 #, tmp183                 ; r8d = shakeX (x, arg3)
	mov	rcx, rax	 #, tmp184                 ; rcx = &graphics (this, arg1)
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii	 # DrawImage(img,x,y,w,h)

	# ===================================================================
	# LAYER 2: PIPES (3 pairs — top pipe rotated 180°, bottom pipe upright)
	# ===================================================================
.L166:
 # src/render.c:151:     if (imgPipeGreen) {
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.47_15, imgPipeGreen
 # src/render.c:151:     if (imgPipeGreen) {
	test	rax, rax	 # imgPipeGreen.47_15     ; is pipe image loaded?
	je	.L167	 #,                               ; no → skip all pipe drawing

	# Pre-compute pipe image dimensions (same for all 3 pipes)
 # src/render.c:152:         INT pipeW = (INT)imgPipeGreen->GetWidth();
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.48_16, imgPipeGreen
	mov	rcx, rax	 #, imgPipeGreen.48_16
	call	_ZN7Gdiplus5Image8GetWidthEv	 # → pipeW in EAX
 # src/render.c:152:         INT pipeW = (INT)imgPipeGreen->GetWidth();
	mov	DWORD PTR -20[rbp], eax	 # pipeW, _17
 # src/render.c:153:         INT pipeH = (INT)imgPipeGreen->GetHeight();
	mov	rax, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.49_18, imgPipeGreen
	mov	rcx, rax	 #, imgPipeGreen.49_18
	call	_ZN7Gdiplus5Image9GetHeightEv	 #
 # src/render.c:153:         INT pipeH = (INT)imgPipeGreen->GetHeight();
	mov	DWORD PTR -24[rbp], eax	 # pipeH, _19
	# Start pipe for-loop: i = 0, 1, 2
 # src/render.c:155:         for (int i = 0; i < 3; i++) {
	mov	DWORD PTR -12[rbp], 0	 # i,            ; i = 0
 # src/render.c:155:         for (int i = 0; i < 3; i++) {
	jmp	.L168	 #                   ; jump to condition check
.L169:                                   # === PIPE LOOP BODY (runs 3 times) ===

	# --- Load game.pipes[i].x ---
	# Pipe struct = 12 bytes: {int x, int topHeight, int passed} → each field 4 bytes
	# Offset of pipes[i].x  = base_of_pipes + i*12 + 0  = game+16 + i*12
	# i*12 computed as: rdx=i; rax=rdx; rax+=rax(=2i); rax+=rdx(=3i); rax<<=2(=12i)
 # src/render.c:156:             INT pipeX = game.pipes[i].x + shakeX;
	mov	rcx, QWORD PTR .refptr.game[rip]	 # ; rcx = &game
	mov	eax, DWORD PTR -12[rbp]	 # tmp187, i    ; eax = i
	movsx	rdx, eax	 # ; rdx = i (sign-extended)
	mov	rax, rdx	 # ; rax = i
	add	rax, rax	 # ; rax = 2i
	add	rax, rdx	 # ; rax = 3i
	sal	rax, 2	 # ; rax = 12i  (Pipe struct is 12 bytes)
	add	rax, rcx	 # ; rax = &game + 12i
	add	rax, 16	 # ; rax = &game.pipes[i]  (pipes starts at offset 16 in game struct)
	mov	edx, DWORD PTR [rax]	 # _20, game.pipes[i_73].x  ; edx = pipes[i].x
 # src/render.c:156:             INT pipeX = game.pipes[i].x + shakeX;
	mov	eax, DWORD PTR -4[rbp]	 # tmp195, shakeX
	add	eax, edx	 # ; eax = pipes[i].x + shakeX
	mov	DWORD PTR -28[rbp], eax	 # pipeX    ; store pipeX at [rbp-28]

	# --- Load game.pipes[i].topHeight --- (same indexing, offset +20 = +16 + 4)
 # src/render.c:157:             INT topHeight = game.pipes[i].topHeight;
	mov	rcx, QWORD PTR .refptr.game[rip]	 #
	mov	eax, DWORD PTR -12[rbp]	 # tmp198, i
	movsx	rdx, eax	 # ; rdx = i
	mov	rax, rdx	 #
	add	rax, rax	 # ; 2i
	add	rax, rdx	 # ; 3i
	sal	rax, 2	 # ; 12i
	add	rax, rcx	 # ; &game + 12i
	add	rax, 20	 # ; &game.pipes[i].topHeight  (offset 16 for pipes base + 4 for .topHeight)
	mov	eax, DWORD PTR [rax]	 # tmp203, game.pipes[i_73].topHeight
	mov	DWORD PTR -32[rbp], eax	 # topHeight

	# --- TOP PIPE: draw pipe image rotated 180° (upside-down) ---
	# Strategy: use GDI+ transform to flip the pipe without a separate flipped sprite.
	#   Step A: TranslateTransform(pipeX + pipeW/2, topHeight + shakeY)
	#           → move the drawing origin to the center-bottom of where the top pipe tip goes
	#   Step B: RotateTransform(180)
	#           → rotate all subsequent drawing by 180 degrees around the new origin
	#   Step C: DrawImage(pipeGreen, -pipeW/2, 0, pipeW, pipeH)
	#           → draw pipe starting left of origin; combined with 180° rotation this flips it
	#   Step D: ResetTransform()
	#           → restore identity transform for subsequent drawing

	# Step A: Convert integer coords to float (REAL) for TranslateTransform
	#   Y argument: topHeight + shakeY → convert to float via cvtsi2ss → XMM1
	#   X argument: pipeX + pipeW/2   → convert to float via cvtsi2ss → XMM0
	#   TranslateTransform(REAL x, REAL y, MatrixOrder=0) takes float args in XMM1,XMM2
	#   (Win64 floating-point args: XMM1=arg2, XMM2=arg3 after rcx=this)
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	mov	edx, DWORD PTR -32[rbp]	 # ; edx = topHeight
	mov	eax, DWORD PTR -8[rbp]	 # ; eax = shakeY
	add	eax, edx	 # ; eax = topHeight + shakeY
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	pxor	xmm1, xmm1	 #            ; clear XMM1 (to avoid stale NaN/denormal bits)
	cvtsi2ss	xmm1, eax	 # ; XMM1 = (float)(topHeight + shakeY)  — Y arg
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	mov	eax, DWORD PTR -20[rbp]	 # ; eax = pipeW
	mov	edx, eax	 #
	shr	edx, 31	 #                 ; sign bit (for signed div by 2)
	add	eax, edx	 #                ; bias for rounding
	sar	eax	 #                     ; eax = pipeW / 2
	mov	edx, eax	 # ; edx = pipeW/2
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	mov	eax, DWORD PTR -28[rbp]	 # ; eax = pipeX
	add	eax, edx	 # ; eax = pipeX + pipeW/2
 # src/render.c:160:             graphics.TranslateTransform((REAL)(pipeX + pipeW/2), (REAL)(topHeight + shakeY));
	pxor	xmm0, xmm0	 #            ; clear XMM0
	cvtsi2ss	xmm0, eax	 # ; XMM0 = (float)(pipeX + pipeW/2) — X arg
	lea	rax, -80[rbp]	 # ; rax = &graphics (this)
	mov	r9d, 0	 #,                ; r9d = MatrixOrder::MatrixOrderPrepend = 0
	movaps	xmm2, xmm1	 #        ; xmm2 = Y (3rd float arg → XMM2 in Win64 ABI)
	movaps	xmm1, xmm0	 #        ; xmm1 = X (2nd float arg → XMM1)
	mov	rcx, rax	 #            ; rcx = this (arg1)
	call	_ZN7Gdiplus8Graphics18TranslateTransformEffNS_11MatrixOrderE	 # TranslateTransform(x,y,order)

	# Step B: RotateTransform(180.0f, MatrixOrderPrepend)
	# .LC16 = 1127481344 = 0x43340000 = 180.0f in IEEE 754 single precision
 # src/render.c:161:             graphics.RotateTransform(180);
	lea	rax, -80[rbp]	 # ; &graphics
	mov	r8d, 0	 #,                ; r8d = MatrixOrder = 0 (Prepend)
	movss	xmm1, DWORD PTR .LC16[rip]	 # ; xmm1 = 180.0f  (angle arg)
	mov	rcx, rax	 #            ; rcx = this
	call	_ZN7Gdiplus8Graphics15RotateTransformEfNS_11MatrixOrderE	 # RotateTransform(180.0f, 0)

	# Step C: DrawImage(pipeGreen, -(pipeW/2), 0, pipeW, pipeH)
	# X = -(pipeW/2) places the pipe left of origin so rotation centers it
	# Y = 0 because origin is already at the pipe tip after TranslateTransform
 # src/render.c:162:             graphics.DrawImage(imgPipeGreen, -(pipeW/2), 0, pipeW, pipeH);
	mov	eax, DWORD PTR -20[rbp]	 # ; eax = pipeW
	mov	edx, eax	 #
	shr	edx, 31	 #
	add	eax, edx	 #
	sar	eax	 #                     ; eax = pipeW/2
	neg	eax	 # ; eax = -(pipeW/2)  ← negative X offset
	mov	r8d, eax	 #             ; r8d = -(pipeW/2)  (arg3 = x)
	mov	rdx, QWORD PTR imgPipeGreen[rip]	 # ; rdx = imgPipeGreen (arg2)
	lea	rax, -80[rbp]	 #         ; rax = &graphics
	mov	ecx, DWORD PTR -24[rbp]	 # ; ecx = pipeH
	mov	DWORD PTR 40[rsp], ecx	 # ; [rsp+40] = pipeH (arg6, on stack)
	mov	ecx, DWORD PTR -20[rbp]	 # ; ecx = pipeW
	mov	DWORD PTR 32[rsp], ecx	 # ; [rsp+32] = pipeW (arg5, on stack)
	mov	r9d, 0	 #,                ; r9d = y = 0 (arg4)
	mov	rcx, rax	 #             ; rcx = &graphics (this, arg1)
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii	 # DrawImage(img, x, y, w, h)

	# Step D: ResetTransform() — restore identity matrix for next draw
 # src/render.c:163:             graphics.ResetTransform();
	lea	rax, -80[rbp]	 #         ; rax = &graphics
	mov	rcx, rax	 #
	call	_ZN7Gdiplus8Graphics14ResetTransformEv	 # ResetTransform()

	# --- BOTTOM PIPE: draw upright at bottomPipeY = topHeight + PIPE_GAP + shakeY ---
	# PIPE_GAP = 200 pixels — the gap between top and bottom pipe
	# lea edx, 200[rax] is GCC's idiom for edx = rax + 200 (topHeight + PIPE_GAP)
 # src/render.c:166:             INT bottomPipeY = topHeight + PIPE_GAP + shakeY;
	mov	eax, DWORD PTR -32[rbp]	 # ; eax = topHeight
	lea	edx, 200[rax]	 # ; edx = topHeight + 200 (PIPE_GAP = 200)
 # src/render.c:166:             INT bottomPipeY = topHeight + PIPE_GAP + shakeY;
	mov	eax, DWORD PTR -8[rbp]	 # ; eax = shakeY
	add	eax, edx	 # ; eax = topHeight + 200 + shakeY
	mov	DWORD PTR -36[rbp], eax	 # bottomPipeY
 # src/render.c:167:             graphics.DrawImage(imgPipeGreen, pipeX, bottomPipeY, pipeW, pipeH);
	mov	rdx, QWORD PTR imgPipeGreen[rip]	 # imgPipeGreen.51_29, imgPipeGreen
	mov	r9d, DWORD PTR -36[rbp]	 # tmp226, bottomPipeY
	mov	r8d, DWORD PTR -28[rbp]	 # tmp227, pipeX
	lea	rax, -80[rbp]	 #             ; rax = &graphics (this)
	mov	ecx, DWORD PTR -24[rbp]	 # ; ecx = pipeH (arg6)
	mov	DWORD PTR 40[rsp], ecx	 # ; [rsp+40] = pipeH
	mov	ecx, DWORD PTR -20[rbp]	 # ; ecx = pipeW (arg5)
	mov	DWORD PTR 32[rsp], ecx	 # ; [rsp+32] = pipeW
	mov	rcx, rax	 #             ; rcx = this (arg1)
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEiiii	 # DrawImage(img,pipeX,bottomPipeY,pipeW,pipeH)

	# --- Pipe loop: i++ and check i <= 2 ---
 # src/render.c:155:         for (int i = 0; i < 3; i++) {
	add	DWORD PTR -12[rbp], 1	 # i,            ; i++
.L168:                                   # === PIPE LOOP CONDITION ===
 # src/render.c:155:         for (int i = 0; i < 3; i++) {
	cmp	DWORD PTR -12[rbp], 2	 # i,            ; i <= 2 (i.e. i < 3)?
	jle	.L169	 #,                  ; yes → draw next pipe

	# ===================================================================
	# LAYER 3: GROUND (tiled horizontally, scrolling left)
	# ===================================================================
.L167:
 # src/render.c:172:     if (imgGround) {
	mov	rax, QWORD PTR imgGround[rip]	 # imgGround.52_30, imgGround
 # src/render.c:172:     if (imgGround) {
	test	rax, rax	 #                ; is imgGround loaded?
	je	.L170	 #,                   ; no → skip ground draw

	# Get ground image dimensions (sprite is narrower than the screen, so must tile it)
 # src/render.c:173:         INT groundW = (INT)imgGround->GetWidth();
	mov	rax, QWORD PTR imgGround[rip]	 #
	mov	rcx, rax	 #
	call	_ZN7Gdiplus5Image8GetWidthEv	 # → groundW in EAX
 # src/render.c:173:         INT groundW = (INT)imgGround->GetWidth();
	mov	DWORD PTR -40[rbp], eax	 # groundW
 # src/render.c:174:         INT groundH = (INT)imgGround->GetHeight();
	mov	rax, QWORD PTR imgGround[rip]	 #
	mov	rcx, rax	 #
	call	_ZN7Gdiplus5Image9GetHeightEv	 # → groundH in EAX (loaded but not used directly)
 # src/render.c:174:         INT groundH = (INT)imgGround->GetHeight();
	mov	DWORD PTR -44[rbp], eax	 # groundH

	# groundY = 608 = WINDOW_HEIGHT(720) - GROUND_HEIGHT(112) — fixed Y position
 # src/render.c:175:         INT groundY = WINDOW_HEIGHT - GROUND_HEIGHT;
	mov	DWORD PTR -48[rbp], 608	 # groundY,  ; compile-time constant

	# Starting X: cast game.groundOffset (float) to int, add shakeX
	# game.groundOffset is a float at game+80, decremented each frame in UpdateGame
	# cvttss2si = convert scalar single-precision to signed int (truncate toward zero)
 # src/render.c:177:         INT x = (INT)game.groundOffset + shakeX;
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	movss	xmm0, DWORD PTR 80[rax]	 # ; xmm0 = game.groundOffset (float)
 # src/render.c:177:         INT x = (INT)game.groundOffset + shakeX;
	cvttss2si	edx, xmm0	 # ; edx = (INT)groundOffset  (truncate float→int)
 # src/render.c:177:         INT x = (INT)game.groundOffset + shakeX;
	mov	eax, DWORD PTR -4[rbp]	 # ; eax = shakeX
	add	eax, edx	 # ; eax = (int)groundOffset + shakeX
	mov	DWORD PTR -16[rbp], eax	 # x

	# Tile the ground: while (x < 1280) { DrawImage(ground, x, groundY+shakeY); x += groundW; }
	# cmp x, 1279 ; jle = "if x <= 1279 continue" which is same as "while x < 1280"
 # src/render.c:178:         while (x < WINDOW_WIDTH) {
	jmp	.L171	 #                   ; jump to condition first
.L172:                                   # === GROUND TILE DRAW ===
 # src/render.c:179:             graphics.DrawImage(imgGround, x, groundY + shakeY);
	mov	edx, DWORD PTR -48[rbp]	 # ; edx = groundY (608)
	mov	eax, DWORD PTR -8[rbp]	 # ; eax = shakeY
	lea	r8d, [rdx+rax]	 # ; r8d = groundY + shakeY (3-arg DrawImage Y)
	mov	rdx, QWORD PTR imgGround[rip]	 # ; rdx = imgGround (arg2)
	mov	ecx, DWORD PTR -16[rbp]	 # ; ecx = x (draw X position)
	lea	rax, -80[rbp]	 #         ; rax = &graphics
	mov	r9d, r8d	 #             ; r9d = y (arg4)
	mov	r8d, ecx	 #             ; r8d = x (arg3)
	mov	rcx, rax	 #             ; rcx = this (arg1)
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii	 # DrawImage(ground, x, groundY+shakeY)
 # src/render.c:180:             x += groundW;
	mov	eax, DWORD PTR -40[rbp]	 # ; eax = groundW
	add	DWORD PTR -16[rbp], eax	 # x += groundW  (advance tile cursor right)
.L171:                                   # === GROUND LOOP CONDITION ===
 # src/render.c:178:         while (x < WINDOW_WIDTH) {
	cmp	DWORD PTR -16[rbp], 1279	 # ; x <= 1279 ?  (same as x < 1280)
	jle	.L172	 #,                  ; yes → draw another tile

	# ===================================================================
	# LAYER 4: BIRD SPRITE
	# ===================================================================
.L170:
 # src/render.c:185:     if (imgBirdFrames[game.birdFrame]) {
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	eax, DWORD PTR 92[rax]	 # ; eax = game.birdFrame (0=down, 1=mid, 2=up)
 # src/render.c:185:     if (imgBirdFrames[game.birdFrame]) {
	cdqe                                   # sign-extend to 64-bit for array index
	lea	rdx, 0[0+rax*8]	 #             ; rdx = birdFrame * 8
	lea	rax, imgBirdFrames[rip]	 #     ; rax = &imgBirdFrames[0]
	mov	rax, QWORD PTR [rdx+rax]	 #   ; rax = imgBirdFrames[birdFrame]
 # src/render.c:185:     if (imgBirdFrames[game.birdFrame]) {
	test	rax, rax	 #                ; is the sprite pointer non-NULL?
	je	.L173	 #,                   ; NULL → skip bird draw

	# bird.y is a float at game+0. Cast to INT for DrawImage.
	# cvttss2si truncates float→int (e.g. 150.7f → 150).
	# BIRD_X = 350 is a compile-time constant, folded into lea ecx, 350[rax].
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	movss	xmm0, DWORD PTR [rax]	 # ; xmm0 = game.bird.y (float, offset 0)
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	cvttss2si	edx, xmm0	 # ; edx = (int)bird.y
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	mov	eax, DWORD PTR -8[rbp]	 # ; eax = shakeY
	lea	r8d, [rdx+rax]	 # ; r8d = (int)bird.y + shakeY  (Y arg)
	mov	eax, DWORD PTR -4[rbp]	 # ; eax = shakeX
	lea	ecx, 350[rax]	 # ; ecx = BIRD_X(350) + shakeX  (X arg)
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	eax, DWORD PTR 92[rax]	 # ; eax = game.birdFrame (re-load for index)
 # src/render.c:186:         graphics.DrawImage(imgBirdFrames[game.birdFrame], BIRD_X + shakeX, (INT)game.bird.y + shakeY);
	cdqe
	lea	rdx, 0[0+rax*8]	 # ; rdx = birdFrame*8
	lea	rax, imgBirdFrames[rip]	 #
	mov	rdx, QWORD PTR [rdx+rax]	 # ; rdx = imgBirdFrames[birdFrame]  (arg2)
	lea	rax, -80[rbp]	 #         ; rax = &graphics
	mov	r9d, r8d	 #             ; r9d = Y = (int)bird.y + shakeY
	mov	r8d, ecx	 #             ; r8d = X = BIRD_X + shakeX
	mov	rcx, rax	 #             ; rcx = &graphics (this)
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii	 # DrawImage(birdSprite, x, y)

	# ===================================================================
	# LAYER 5: PARTICLES
	# ===================================================================
.L173:
 # src/render.c:190:     DrawParticles(&graphics);
	# Draws all active particles as colored ellipses (see DrawParticles above)
	lea	rax, -80[rbp]	 #         ; rax = &graphics
	mov	rcx, rax	 #
	call	_Z13DrawParticlesPN7Gdiplus8GraphicsE	 # DrawParticles(&graphics)

	# ===================================================================
	# LAYER 6: IN-GAME SCORE (only while playing, not game-over)
	# ===================================================================
 # src/render.c:193:     if (game.started && !game.gameOver) {
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	eax, DWORD PTR 64[rax]	 # ; eax = game.started
 # src/render.c:193:     if (game.started && !game.gameOver) {
	test	eax, eax	 # ; is game.started != 0?
	je	.L174	 #,                   ; not started → skip score
 # src/render.c:193:     if (game.started && !game.gameOver) {
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	eax, DWORD PTR 60[rax]	 # ; eax = game.gameOver
 # src/render.c:193:     if (game.started && !game.gameOver) {
	test	eax, eax	 # ; is game.gameOver == 0?
	jne	.L174	 #,                   ; game over → skip (score shown in gameOver UI instead)

	# DrawScore(&graphics, game.score, WINDOW_WIDTH/2=640, y=30)
	# Draws score at top-center of screen while player is actively playing
 # src/render.c:194:         DrawScore(&graphics, game.score, WINDOW_WIDTH / 2, 30);
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	edx, DWORD PTR 52[rax]	 # ; edx = game.score (arg2)
	lea	rax, -80[rbp]	 #         ; rax = &graphics
	mov	r9d, 30	 #,              ; r9d = y = 30  (arg4)
	mov	r8d, 640	 #,
	mov	rcx, rax	 #, tmp257
	call	_Z9DrawScorePN7Gdiplus8GraphicsEiii	 #

	# ===================================================================
	# LAYER 7: START SCREEN MESSAGE (shown before game starts)
	# ===================================================================
.L174:
 # src/render.c:198:     if (!game.started && imgMessage) {
	# Show "message" sprite (get-ready screen) only when game hasn't started yet
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	eax, DWORD PTR 64[rax]	 # ; eax = game.started
 # src/render.c:198:     if (!game.started && imgMessage) {
	test	eax, eax	 #             ; is started != 0?
	jne	.L175	 #,                ; yes → skip message (game is running)
 # src/render.c:198:     if (!game.started && imgMessage) {
	mov	rax, QWORD PTR imgMessage[rip]	 # ; rax = imgMessage ptr
 # src/render.c:198:     if (!game.started && imgMessage) {
	test	rax, rax	 #             ; is imgMessage loaded?
	je	.L175	 #,                ; no → skip

	# Center the message sprite: x = (1280-msgW)/2,  y = (720-msgH)/2 - 40
	# The -40 offset shifts the splash screen slightly upward from screen center.
	# Centering X and Y both use the signed-division-by-2 (SAR+bias) trick.
 # src/render.c:199:         INT msgW = (INT)imgMessage->GetWidth();
	mov	rax, QWORD PTR imgMessage[rip]	 #
	mov	rcx, rax	 #
	call	_ZN7Gdiplus5Image8GetWidthEv	 # → msgW in EAX
 # src/render.c:199:         INT msgW = (INT)imgMessage->GetWidth();
	mov	DWORD PTR -52[rbp], eax	 # msgW
 # src/render.c:200:         INT msgH = (INT)imgMessage->GetHeight();
	mov	rax, QWORD PTR imgMessage[rip]	 #
	mov	rcx, rax	 #
	call	_ZN7Gdiplus5Image9GetHeightEv	 # → msgH in EAX
 # src/render.c:200:         INT msgH = (INT)imgMessage->GetHeight();
	mov	DWORD PTR -56[rbp], eax	 # msgH

	# Compute Y = (720 - msgH) / 2 - 40
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	mov	eax, 720	 #                ; 720 = WINDOW_HEIGHT
	sub	eax, DWORD PTR -56[rbp]	 # ; eax = 720 - msgH
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	mov	edx, eax	 # ; edx = 720 - msgH
	shr	edx, 31	 # ; sign bit (bias for signed div)
	add	eax, edx	 # ; bias
	sar	eax	 # ; eax = (720 - msgH) / 2
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	lea	ecx, -40[rax]	 # ; ecx = (720-msgH)/2 - 40   ← Y argument

	# Compute X = (1280 - msgW) / 2
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	mov	eax, 1280	 #               ; 1280 = WINDOW_WIDTH
	sub	eax, DWORD PTR -52[rbp]	 # ; eax = 1280 - msgW
 # src/render.c:201:         graphics.DrawImage(imgMessage, (WINDOW_WIDTH - msgW) / 2, (WINDOW_HEIGHT - msgH) / 2 - 40);
	mov	edx, eax	 #
	shr	edx, 31	 #
	add	eax, edx	 #
	sar	eax	 # ; eax = (1280 - msgW) / 2   ← X argument
	mov	r8d, eax	 # ; r8d = X (arg3)
	mov	rdx, QWORD PTR imgMessage[rip]	 # ; rdx = imgMessage (arg2)
	lea	rax, -80[rbp]	 #           ; rax = &graphics
	mov	r9d, ecx	 # ; r9d = Y (arg4)
	mov	rcx, rax	 # ; rcx = &graphics (this, arg1)
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii	 # DrawImage(imgMessage, X, Y)

	# ===================================================================
	# LAYER 8: GAME-OVER SCREEN (banner + score)
	# ===================================================================
.L175:
 # src/render.c:205:     if (game.gameOver) {
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	eax, DWORD PTR 60[rax]	 # ; eax = game.gameOver
 # src/render.c:205:     if (game.gameOver) {
	test	eax, eax	 #             ; is gameOver != 0?
	je	.L176	 #,                ; no → skip gameover UI

	# Draw "GAME OVER" banner centered horizontally at Y=80
 # src/render.c:206:         if (imgGameOver) {
	mov	rax, QWORD PTR imgGameOver[rip]	 #
 # src/render.c:206:         if (imgGameOver) {
	test	rax, rax	 #             ; is imgGameOver loaded?
	je	.L177	 #,                ; no → skip banner, still draw score
 # src/render.c:207:             INT goW = (INT)imgGameOver->GetWidth();
	mov	rax, QWORD PTR imgGameOver[rip]	 #
	mov	rcx, rax	 #
	call	_ZN7Gdiplus5Image8GetWidthEv	 # → goW in EAX
 # src/render.c:207:             INT goW = (INT)imgGameOver->GetWidth();
	mov	DWORD PTR -60[rbp], eax	 # goW

	# X = (1280 - goW) / 2  (center horizontally)
 # src/render.c:208:             graphics.DrawImage(imgGameOver, (WINDOW_WIDTH - goW) / 2, 80);
	mov	eax, 1280	 #
	sub	eax, DWORD PTR -60[rbp]	 # ; eax = 1280 - goW
 # src/render.c:208:             graphics.DrawImage(imgGameOver, (WINDOW_WIDTH - goW) / 2, 80);
	mov	edx, eax	 #
	shr	edx, 31	 #
	add	eax, edx	 #
	sar	eax	 # ; eax = (1280-goW)/2
	mov	ecx, eax	 # ; ecx = X
	mov	rdx, QWORD PTR imgGameOver[rip]	 # ; rdx = imgGameOver
	lea	rax, -80[rbp]	 #
	mov	r9d, 80	 #,              ; r9d = Y = 80  (fixed position, near top)
	mov	r8d, ecx	 #             ; r8d = X = centered
	mov	rcx, rax	 #             ; rcx = &graphics
	call	_ZN7Gdiplus8Graphics9DrawImageEPNS_5ImageEii	 # DrawImage(gameOver, X, 80)

	# Draw score below the GAME OVER banner (y=200, horizontally centered)
.L177:
 # src/render.c:212:         DrawScore(&graphics, game.score, WINDOW_WIDTH / 2, 200);
	mov	rax, QWORD PTR .refptr.game[rip]	 #
	mov	edx, DWORD PTR 52[rax]	 # ; edx = game.score (arg2)
	lea	rax, -80[rbp]	 #         ; rax = &graphics
	mov	r9d, 200	 #,            ; r9d = y = 200 (arg4)  — below banner
	mov	r8d, 640	 #,            ; r8d = centerX = WINDOW_WIDTH/2 = 640 (arg3)
	mov	rcx, rax	 #             ; rcx = &graphics (arg1)
	call	_Z9DrawScorePN7Gdiplus8GraphicsEiii	 # DrawScore(&graphics, score, 640, 200)

	# ===================================================================
	# LAYER 9: BitBlt — COPY BACK-BUFFER TO SCREEN (double-buffer flip)
	# ===================================================================
.L176:
	# This is the most important step: transfers the completed off-screen frame
	# to the visible window in one atomic memory copy.
	# Without this, all drawing above happened in an invisible back-buffer.
	#
	# BitBlt(HDC dest, x, y, w, h, HDC src, srcX, srcY, DWORD rop)
	# Win64: args 1-4 in RCX,RDX,R8,R9; args 5-9 pushed on stack (right to left)
	# SRCCOPY = 0xCC0020 = 13369376 — direct copy (no raster operation)
	#
	# Stack layout for BitBlt args (5 extra args beyond the first 4):
	#   [rsp+32] = WINDOW_HEIGHT = 720   (arg5: height of copy region)
	#   [rsp+40] = hdcBackBuffer         (arg6: source DC — the back-buffer)
	#   [rsp+48] = 0                     (arg7: source X = 0)
	#   [rsp+56] = 0                     (arg8: source Y = 0)
	#   [rsp+64] = 13369376 = SRCCOPY    (arg9: raster operation code)
 # src/render.c:216:     BitBlt(hdc, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, hdcBackBuffer, 0, 0, SRCCOPY);
	mov	rdx, QWORD PTR hdcBackBuffer[rip]	 # ; rdx = hdcBackBuffer (source DC)
	mov	rax, QWORD PTR 32[rbp]	 # ; rax = hdc (destination — screen DC)
	mov	DWORD PTR 64[rsp], 13369376	 # ; [rsp+64] = SRCCOPY (arg9)
	mov	DWORD PTR 56[rsp], 0	 #   ; [rsp+56] = srcY = 0 (arg8)
	mov	DWORD PTR 48[rsp], 0	 #   ; [rsp+48] = srcX = 0 (arg7)
	mov	QWORD PTR 40[rsp], rdx	 #   ; [rsp+40] = hdcBackBuffer (arg6)
	mov	DWORD PTR 32[rsp], 720	 #   ; [rsp+32] = height = 720 (arg5)
	mov	r9d, 1280	 #,              ; r9d = width = 1280 (arg4)
	mov	r8d, 0	 #,                ; r8d = destY = 0 (arg3)
	mov	edx, 0	 #,                ; rdx = destX = 0 (arg2)
	mov	rcx, rax	 #             ; rcx = hdc (dest DC, arg1)
	mov	rax, QWORD PTR __imp_BitBlt[rip]	 # ; load BitBlt function pointer (IAT)
	call	rax	 #                 ; BitBlt — screen now shows the completed frame

.LEHE10:                                 # END exception region (all draw calls above)

	# --- EPILOGUE (normal path) ---
	# Destroy the GDI+ Graphics object (releases GDI+ resources, not the DC itself)
 # src/render.c:217: }
	lea	rax, -80[rbp]	 #         ; rax = &graphics (stack object)
	mov	rcx, rax	 #             ; rcx = this
	call	_ZN7Gdiplus8GraphicsD1Ev	 # Graphics::~Graphics()
	jmp	.L180	 #               ; jump past exception handler to real epilogue

	# --- EXCEPTION HANDLER PATH (.L179) ---
	# This code runs ONLY if a C++ exception was thrown during a draw call.
	# RBX preserved the exception pointer (set before the call that threw).
	# We still must destroy the Graphics object to avoid resource leaks.
.L179:
	mov	rbx, rax	 # ; rbx = exception object pointer (save before call)
	lea	rax, -80[rbp]	 # ; rax = &graphics
	mov	rcx, rax	 # ; rcx = this
	call	_ZN7Gdiplus8GraphicsD1Ev	 # Graphics::~Graphics()  ← cleanup on exception
	mov	rax, rbx	 # ; rax = exception object (restore for _Unwind_Resume)
	mov	rcx, rax	 # ; rcx = exception object
	mov	rcx, rax	 #, D.135101
.LEHB11:                                 # BEGIN exception region (_Unwind_Resume call)
	call	_Unwind_Resume	 #           ; re-throw the exception after Graphics cleanup
	nop	
.LEHE11:                                 # END exception region

# === NORMAL EPILOGUE (executed on clean return from DrawGame) ===
.L180:
	add	rsp, 168	 #,             ; deallocate 168-byte stack frame (locals + shadow)
	pop	rbx	 #                 ; restore callee-saved RBX (used in screen shake div)
	pop	rbp	 #                 ; restore caller's frame pointer
	ret	                            # return to WndProc caller (DrawGame returns void)
	# SEH personality function:
	# __gxx_personality_seh0 handles C++ exceptions on Windows SEH.
	# It reads .LLSDA8698 to decide which cleanup code to run.
	.seh_handler	__gxx_personality_seh0, @unwind, @except
	.seh_handlerdata

# ============================================================================
# LSDA (Language Specific Data Area) — exception cleanup map for DrawGame
# ============================================================================
# The C++ runtime reads this table during stack unwinding to find landing pads.
# Each entry covers one guarded instruction region and names its handler.
#
# Entry format (4 uleb128 values each):
#   cs_start  : offset from function start (.LEHB - .LFB)
#   cs_len    : length of guarded region   (.LEHE - .LEHB)
#   cs_lp     : landing pad offset (0 = none, else .Lxx - .LFB)
#   cs_action : action index (0 = no type filter / cleanup only)
#
# Region 1: .LEHB9 → .LEHE9  (Graphics constructor)
#   cs_lp = 0 → if ctor throws, no cleanup (object is not yet constructed)
#
# Region 2: .LEHB10 → .LEHE10  (all GDI+ draw calls after construction)
#   cs_lp = .L179 → if any draw call throws, jump to .L179 to call ~Graphics()
#
# Region 3: .LEHB11 → .LEHE11  (_Unwind_Resume)
#   cs_lp = 0 → let the re-throw propagate upward, no further cleanup here
# ============================================================================
.LLSDA8698:
	.byte	0xff         # @LPStart encoding: 0xff = omitted (use function base)
	.byte	0xff         # @TType encoding:   0xff = omitted (no catch type filters)
	.byte	0x1          # call-site encoding: 0x01 = uleb128 values
	.uleb128 .LLSDACSE8698-.LLSDACSB8698   # total size of call-site table in bytes
.LLSDACSB8698:           # === call-site table entries ===

	# Entry 1: Graphics constructor — no cleanup landing pad
	.uleb128 .LEHB9-.LFB8698     # cs_start: offset to start of ctor region
	.uleb128 .LEHE9-.LEHB9       # cs_len:   length of ctor region
	.uleb128 0                   # cs_lp:    0 = no landing pad (ctor incomplete → skip dtor)
	.uleb128 0                   # cs_action: 0 (no type filter)

	# Entry 2: All draw calls — cleanup landing pad at .L179
	.uleb128 .LEHB10-.LFB8698    # cs_start: offset to start of draw call region
	.uleb128 .LEHE10-.LEHB10     # cs_len:   length of draw call region
	.uleb128 .L179-.LFB8698      # cs_lp:    .L179 = call ~Graphics() then re-throw
	.uleb128 0                   # cs_action: 0

	# Entry 3: _Unwind_Resume — no further cleanup
	.uleb128 .LEHB11-.LFB8698    # cs_start: offset to _Unwind_Resume region
	.uleb128 .LEHE11-.LEHB11     # cs_len:   length
	.uleb128 0                   # cs_lp:    0 = no handler, let exception propagate
	.uleb128 0                   # cs_action: 0
.LLSDACSE8698:                   # end of call-site table
	.text
	.seh_endproc

# ============================================================================
# C++ VTABLE AND RTTI DATA — GDI+ Class Metadata
# ============================================================================
# This section is entirely compiler-generated C++ infrastructure.
# It is NOT game logic — you can safely skip it for game understanding.
#
# WHY IT EXISTS HERE:
#   render.c includes <gdiplus.h> which defines inline virtual methods for
#   Gdiplus::Image, Gdiplus::Brush, and Gdiplus::SolidBrush.
#   The compiler emits their vtables and RTTI into THIS translation unit.
#
# VTABLES (_ZTVN...):
#   A vtable (virtual function table) is an array of function pointers.
#   Every C++ object with virtual methods stores a hidden vtable pointer
#   at offset 0 of the object.  Virtual calls dispatch through this table.
#
#   Layout of each vtable:
#     [+0]  = 0            ; "top offset" (0 = primary vtable, not a base subobject)
#     [+8]  = _ZTI...      ; pointer to RTTI type_info object for dynamic_cast
#     [+16] = D1 dtor ptr  ; "complete object destructor" — destroys + cleans up
#     [+24] = D0 dtor ptr  ; "deleting destructor"        — D1 + operator delete
#     [+32] = Clone()      ; virtual Clone() method pointer
#
#   _ZTVN7Gdiplus10SolidBrushE = vtable for Gdiplus::SolidBrush
#   _ZTVN7Gdiplus5BrushE       = vtable for Gdiplus::Brush (SolidBrush base class)
#   _ZTVN7Gdiplus5ImageE       = vtable for Gdiplus::Image
#
# RTTI objects (_ZTIN...): "type info" used by dynamic_cast and exception handling
#   Each contains: a pointer to the vtable of the RTTI class, a pointer to the
#   type name string, and (for derived classes) a pointer to the base type_info.
#   _ZTIN7Gdiplus10SolidBrushE = typeinfo for Gdiplus::SolidBrush
#   _ZTIN7Gdiplus5BrushE       = typeinfo for Gdiplus::Brush
#   _ZTIN7Gdiplus5ImageE       = typeinfo for Gdiplus::Image
#   _ZTIN7Gdiplus11GdiplusBaseE = typeinfo for Gdiplus::GdiplusBase (root)
#
# TYPE NAME STRINGS (_ZTSN...): mangled class name as a null-terminated string
#   Used by typeid(obj).name().  e.g. "N7Gdiplus5ImageE" = Gdiplus::Image
#
# .linkonce same_size DIRECTIVE:
#   Every .cpp that includes <gdiplus.h> emits its own copy of these vtables.
#   .linkonce same_size tells the linker: "keep only ONE copy; if sizes differ,
#   keep the largest."  This prevents multiply-defined symbol link errors.
#   In practice all copies are identical so any one is kept.
# ============================================================================
	.globl	_ZTVN7Gdiplus10SolidBrushE
	.section	.rdata$_ZTVN7Gdiplus10SolidBrushE,"dr"
	.linkonce same_size
	.align 8
# --- vtable for Gdiplus::SolidBrush ---
# SolidBrush extends Brush (which extends GdiplusBase).
# DrawParticles constructs SolidBrush on the stack; virtual destructor is called
# at scope exit via this vtable.
_ZTVN7Gdiplus10SolidBrushE:
	.quad	0                                  # top_offset = 0 (this IS the primary object)
	.quad	_ZTIN7Gdiplus10SolidBrushE         # ptr to SolidBrush RTTI type_info
	.quad	_ZN7Gdiplus10SolidBrushD1Ev        # [vtable slot 0] complete dtor  SolidBrush::~SolidBrush()
	.quad	_ZN7Gdiplus10SolidBrushD0Ev        # [vtable slot 1] deleting dtor  (D1 + operator delete)
	.quad	_ZNK7Gdiplus10SolidBrush5CloneEv   # [vtable slot 2] Clone() — returns a heap copy
	.globl	_ZTVN7Gdiplus5BrushE
	.section	.rdata$_ZTVN7Gdiplus5BrushE,"dr"
	.linkonce same_size
	.align 8
# --- vtable for Gdiplus::Brush (base class of SolidBrush) ---
_ZTVN7Gdiplus5BrushE:
	.quad	0                                  # top_offset = 0
	.quad	_ZTIN7Gdiplus5BrushE               # ptr to Brush RTTI type_info
	.quad	_ZN7Gdiplus5BrushD1Ev              # [slot 0] complete dtor  Brush::~Brush()
	.quad	_ZN7Gdiplus5BrushD0Ev              # [slot 1] deleting dtor
	.quad	_ZNK7Gdiplus5Brush5CloneEv         # [slot 2] Clone() — pure virtual in Brush
	.globl	_ZTVN7Gdiplus5ImageE
	.section	.rdata$_ZTVN7Gdiplus5ImageE,"dr"
	.linkonce same_size
	.align 8
# --- vtable for Gdiplus::Image ---
# Image is the base of all sprite types.  CleanupGraphics deletes Image* pointers;
# the virtual destructor in this table ensures proper cleanup.
_ZTVN7Gdiplus5ImageE:
	.quad	0                                  # top_offset = 0
	.quad	_ZTIN7Gdiplus5ImageE               # ptr to Image RTTI type_info
	.quad	_ZN7Gdiplus5ImageD1Ev              # [slot 0] complete dtor  Image::~Image()
	.quad	_ZN7Gdiplus5ImageD0Ev              # [slot 1] deleting dtor  (called by  delete ptr)
	.quad	_ZNK7Gdiplus5Image5CloneEv         # [slot 2] Clone()
	.globl	_ZTIN7Gdiplus10SolidBrushE
	.section	.rdata$_ZTIN7Gdiplus10SolidBrushE,"dr"
	.linkonce same_size
	.align 8
# --- RTTI type_info object for Gdiplus::SolidBrush ---
# __si_class_type_info = single-inheritance class with one direct base.
# Layout: [vtable of si_class_type_info, type name string, base class type_info ptr]
_ZTIN7Gdiplus10SolidBrushE:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16   # typeinfo vtable ptr (skip top_offset+rtti slots)
	.quad	_ZTSN7Gdiplus10SolidBrushE                    # ptr to mangled name string
	.quad	_ZTIN7Gdiplus5BrushE                           # ptr to base class (Brush) type_info
	.globl	_ZTSN7Gdiplus10SolidBrushE
	.section	.rdata$_ZTSN7Gdiplus10SolidBrushE,"dr"
	.linkonce same_size
	.align 16
# --- Type name string for Gdiplus::SolidBrush ---
_ZTSN7Gdiplus10SolidBrushE:
	.ascii "N7Gdiplus10SolidBrushE\0"   # typeid(SolidBrush).name() returns this

	.globl	_ZTIN7Gdiplus5BrushE
	.section	.rdata$_ZTIN7Gdiplus5BrushE,"dr"
	.linkonce same_size
	.align 8
# --- RTTI type_info object for Gdiplus::Brush ---
# Single-inheritance: base is GdiplusBase.
_ZTIN7Gdiplus5BrushE:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16   # typeinfo vtable ptr
	.quad	_ZTSN7Gdiplus5BrushE                          # ptr to "N7Gdiplus5BrushE\0"
	.quad	_ZTIN7Gdiplus11GdiplusBaseE                   # ptr to base class (GdiplusBase) type_info
	.globl	_ZTSN7Gdiplus5BrushE
	.section	.rdata$_ZTSN7Gdiplus5BrushE,"dr"
	.linkonce same_size
	.align 16
# --- Type name string for Gdiplus::Brush ---
_ZTSN7Gdiplus5BrushE:
	.ascii "N7Gdiplus5BrushE\0"         # typeid(Brush).name() returns this

	.globl	_ZTIN7Gdiplus5ImageE
	.section	.rdata$_ZTIN7Gdiplus5ImageE,"dr"
	.linkonce same_size
	.align 8
# --- RTTI type_info object for Gdiplus::Image ---
# Single-inheritance: base is GdiplusBase.
# This is used when catching exceptions of type Image* or doing dynamic_cast<Image*>.
_ZTIN7Gdiplus5ImageE:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16   # typeinfo vtable ptr
	.quad	_ZTSN7Gdiplus5ImageE                          # ptr to "N7Gdiplus5ImageE\0"
	.quad	_ZTIN7Gdiplus11GdiplusBaseE                   # ptr to base class (GdiplusBase) type_info
	.globl	_ZTSN7Gdiplus5ImageE
	.section	.rdata$_ZTSN7Gdiplus5ImageE,"dr"
	.linkonce same_size
	.align 16
# --- Type name string for Gdiplus::Image ---
_ZTSN7Gdiplus5ImageE:
	.ascii "N7Gdiplus5ImageE\0"         # typeid(Image).name() returns this

	.globl	_ZTIN7Gdiplus11GdiplusBaseE
	.section	.rdata$_ZTIN7Gdiplus11GdiplusBaseE,"dr"
	.linkonce same_size
	.align 8
# --- RTTI type_info object for Gdiplus::GdiplusBase (root class) ---
# __class_type_info = a leaf class with no base classes (or the hierarchy root).
# GdiplusBase is the ultimate base for all GDI+ objects.
_ZTIN7Gdiplus11GdiplusBaseE:
	.quad	_ZTVN10__cxxabiv117__class_type_infoE+16      # class_type_info vtable (not si_ — no base)
	.quad	_ZTSN7Gdiplus11GdiplusBaseE                   # ptr to "N7Gdiplus11GdiplusBaseE\0"
	.globl	_ZTSN7Gdiplus11GdiplusBaseE
	.section	.rdata$_ZTSN7Gdiplus11GdiplusBaseE,"dr"
	.linkonce same_size
	.align 16
# --- Type name string for Gdiplus::GdiplusBase ---
_ZTSN7Gdiplus11GdiplusBaseE:
	.ascii "N7Gdiplus11GdiplusBaseE\0"  # typeid(GdiplusBase).name() returns this
# ============================================================================
# FLOAT CONSTANT — pipe rotation angle
# ============================================================================
	.section .rdata,"dr"
	.align 4
.LC16:
	# IEEE 754: 0x43340000 = 180.0f — angle passed to RotateTransform(180.0f)
	# to draw the top pipe upside-down.
	.long	1127481344         # = 0x43340000 = 180.0f

# ============================================================================
# EXTERNAL SYMBOL DECLARATIONS (.def directives)
# ============================================================================
# Each .def names an external function imported from a DLL at link time.
# .scl 2 = C_EXT (external/public)   .type 32 = function symbol
# These are metadata only — they do not generate executable code.
	.def	__gxx_personality_seh0;	.scl	2;	.type	32;	.endef  # C++ SEH personality (libgcc)
	.ident	"GCC: (MinGW-W64 x86_64-msvcrt-posix-seh, built by Brecht Sanders, r1) 15.2.0"  # compiler ID string
	# --- GDI+ C API (gdiplus.dll raw C functions — called by C++ wrappers above) ---
	.def	GdipAlloc;	.scl	2;	.type	32;	.endef              # heap alloc for GDI+ objects
	.def	GdipFree;	.scl	2;	.type	32;	.endef               # heap free for GDI+ objects
	.def	GdipDisposeImage;	.scl	2;	.type	32;	.endef      # Image::~Image() C API
	.def	GdipCloneImage;	.scl	2;	.type	32;	.endef          # Image::Clone() C API
	.def	GdipDeleteBrush;	.scl	2;	.type	32;	.endef       # Brush::~Brush() C API
	.def	GdipCreateSolidFill;	.scl	2;	.type	32;	.endef   # SolidBrush(color) C API — used in DrawParticles
	.def	_Unwind_Resume;	.scl	2;	.type	32;	.endef          # re-throw C++ exception (libgcc/SEH)
	.def	GdipCloneBrush;	.scl	2;	.type	32;	.endef          # Brush::Clone() C API
	.def	GdipCreateFromHDC;	.scl	2;	.type	32;	.endef      # Graphics(HDC) C API — DrawGame ctor
	.def	GdipDeleteGraphics;	.scl	2;	.type	32;	.endef     # ~Graphics() C API — DrawGame dtor
	.def	GdipDrawImageI;	.scl	2;	.type	32;	.endef          # DrawImage(img, x, y) C API
	.def	GdipDrawImageRectI;	.scl	2;	.type	32;	.endef     # DrawImage(img, x, y, w, h) C API
	.def	GdipFillEllipseI;	.scl	2;	.type	32;	.endef       # FillEllipse(brush,x,y,w,h) — DrawParticles
	.def	GdipResetWorldTransform;	.scl	2;	.type	32;	.endef # ResetTransform() — after pipe draw
	.def	GdipRotateWorldTransform;	.scl	2;	.type	32;	.endef # RotateTransform(180) — top pipe flip
	.def	GdipSetInterpolationMode;	.scl	2;	.type	32;	.endef # SetInterpolationMode(nearest) — no blur
	.def	GdipTranslateWorldTransform;	.scl	2;	.type	32;	.endef # TranslateTransform(x,y) — pipe origin
	.def	GdipLoadImageFromFileICM;	.scl	2;	.type	32;	.endef # Image::FromFile with ICM color management
	.def	GdipLoadImageFromFile;	.scl	2;	.type	32;	.endef  # Image::FromFile without ICM — used in LoadImages
	.def	GdipGetImageHeight;	.scl	2;	.type	32;	.endef      # Image::GetHeight() — pipe/ground sizing
	.def	GdipGetImageWidth;	.scl	2;	.type	32;	.endef       # Image::GetWidth() — pipe/ground/digit sizing
	.def	GdiplusStartup;	.scl	2;	.type	32;	.endef          # GdiplusStartup() — InitGraphics
	.def	GdiplusShutdown;	.scl	2;	.type	32;	.endef        # GdiplusShutdown() — CleanupGraphics
	# --- C runtime library ---
	.def	strlen;	.scl	2;	.type	32;	.endef                  # strlen() — DrawScore (count digits)
	.def	rand;	.scl	2;	.type	32;	.endef                    # rand() — DrawGame screen shake offsets

# ============================================================================
# CROSS-TRANSLATION-UNIT INDIRECTION POINTERS (.refptr)
# ============================================================================
# game[] and particles[] are defined in game.c (a separate translation unit).
# render.c cannot access them with simple [rip]-relative addressing because
# the linker needs to resolve the addresses at link time.
#
# Solution: the linker generates these 8-byte pointer slots in .rdata.
# Code loads the POINTER to the global, then dereferences it:
#   mov rax, .refptr.game[rip]    ; rax = address of 'game' global
#   mov eax, [rax + 52]           ; eax = game.score
#
# .linkonce discard: if multiple .o files emit the same .refptr (e.g. if
# render.c were included twice), the linker keeps only one copy.
# ============================================================================
	.section	.rdata$.refptr.game, "dr"
	.p2align	3, 0          # align to 8 bytes (pointer size)
	.globl	.refptr.game
	.linkonce	discard       # discard duplicates at link time
.refptr.game:
	.quad	game              # 8-byte slot: &game (GameState struct defined in game.c)

	.section	.rdata$.refptr.particles, "dr"
	.p2align	3, 0          # align to 8 bytes
	.globl	.refptr.particles
	.linkonce	discard       # discard duplicates at link time
.refptr.particles:
	.quad	particles         # 8-byte slot: &particles (Particle[MAX_PARTICLES] in game.c)

# ============================================================================
# END OF render.asm
# ============================================================================
# Reading guide recap:
#   Lines 1  - ~1640 : GDI+ inlined C++ library code  (skip on first read)
#   Lines ~1640-1800 : GetMedalText, GetMedalColor, LoadImages, InitGraphics,
#                      CleanupGraphics (sprite loading and lifecycle)
#   Lines ~1800-3095 : DrawParticles, DrawScore (particles + digit rendering)
#   Lines ~3095-4094 : DrawGame (master frame renderer, 9-layer painter's algo)
#   Lines 4094-end   : C++ vtables, RTTI objects, .def imports, .refptr slots
# ============================================================================
