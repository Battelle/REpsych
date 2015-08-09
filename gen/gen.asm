; REpsych
; domas, @xoreaxeaxeax

; This file generates junk code to fill the basic blocks. The goal is to simply
; generate some instructions that won't fault. A more sophisticated approach
; would modify the CFG of existing code.  For now, we're just doing a PoC.

; This is really slow: if you're okay with nops, it'd increase increase the
; speed by 10x.

%assign next 1
%macro rand 1
    %assign next next * 1103515245 + 12345
	%assign R next % %1
%endmacro

%macro randreg 1
	rand 4
	%if R == 0
		%define %1 eax
	%elif R == 1
		%define %1 ebx
	%elif R == 2
		%define %1 ecx
	%elif R == 3
		%define %1 edx
	%endif
%endmacro

%macro randregl 1
	rand 8
	%if R == 0
		%define %1 al
	%elif R == 1
		%define %1 bl
	%elif R == 2
		%define %1 cl
	%elif R == 3
		%define %1 dl
	%elif R == 4
		%define %1 ah
	%elif R == 5
		%define %1 bh
	%elif R == 6
		%define %1 ch
	%elif R == 7
		%define %1 dh
	%endif
%endmacro

%macro randbiop 1
	rand 8
	%if R == 0
		%define %1 add
	%elif R == 1
		%define %1 sub
	%elif R == 2
		%define %1 and
	%elif R == 3
		%define %1 or
	%elif R == 4
		%define %1 xor
	%elif R == 5
		%define %1 cmp
	%elif R == 6
		%define %1 test
	%elif R == 7
		%define %1 mov
	%endif
%endmacro

%macro randmoop 1
	rand 4
	%if R == 0
		%define %1 inc
	%elif R == 1
		%define %1 dec
	%elif R == 2
		%define %1 not
	%elif R == 3
		%define %1 mul
	%endif
%endmacro

%macro rand_insn 0
	rand 10
	%undef op
	%undef r1
	%undef r2
	%undef r3
	%if R == 0
		randmoop op
		randreg r1
		op r1
	%elif R == 1
		randbiop op
		randreg r1
		randreg r2
		op r1, r2
	%elif R == 2
		randbiop op
		randreg r1
		rand 0xffffffff
		op r1, R
	%elif R == 3
		randreg r1
		randreg r2
		randreg r3
		lea r3, [r1+4*r2]
	%elif R == 4
		randreg r1
		randreg r2
		lea r1, [r2*2]
	%elif R == 5
		rand 6
		randreg r1
		lea r1, [ebp+R*4]
	%elif R == 6
		randreg r1
		rand 32
		shl r1, R
	%elif R == 7
		randreg r1
		rand 32
		shr r1, R
	%elif R == 8
		rand 0xff
		randregl r1
		mov r1, R
	%elif R == 9
		randreg r1
		randregl r2
		movzx r1, r2
	%endif
%endmacro
