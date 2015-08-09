; REpsych
; domas @xoreaxeaxeax

USE32

%include "gen/gen.asm"
%include "gfx/image.asm"
%include "code/code.asm"

global _start
_start:
call code
call main
mov eax, 1
mov edx, 0
int 0x80

; Tie nodes together, or use the newer switch opening,
; which avoids the need for tight tying.
%ifdef TIE
	%assign TIED 1
%else
	%assign TIED 0
%endif

; max instructions in a node, picked to match width
%assign instructions 26

; insert a wider instructure to make nodes larger to emphasize contrast
%macro widen 0
	; any arbitrary long instruction that won't fault
	; don't use a long nop, ida will decode the graph differently
	; wide+4 prevents instruction from shortening due to existing symbol
	vfmaddsub132ps xmm0,xmm1,[cs:edi+esi*4+wide+4]

	;mov dword [eax+4*edx+0x11111111], 0x11111111
	;lea eax, [eax+4*edx+0x11111111]
	;mov dword [edi+4*esi+wide+4], 0x11111111
%endmacro

; widen instruction setup, if necessary
section .data
wide: dd 0, 0, 0
section .text
%macro init_widen 0
	xor edi, edi
	xor esi, esi
%endmacro

%macro invert 0
	%assign pixel 255-pixel
%endmacro

%macro check 2
	%assign pixel pixel_%1_%2
%endmacro

%macro block_fill 2

	; force column filled to ensure all rows have at least 1 pixel on
	%if %2 == 0
		%assign pixel 255
	%else
		; adjust for all on column
		%assign T %2 - 1
		check T, %1
	%endif

	widen

	%assign lines pixel*instructions/255

	; junk code, should not branch or interfere with execution
	%rep lines
		rand_insn
	%endrep
%endmacro

%macro diag 5 ; row, column, width, height, done
	%assign r %1
	%assign c %2
	%assign width %3
	%assign height %4

	%rep 256 ; max size
		%assign nr r+1
		%if TIED
			%assign nc c+1
		%else
			%assign nc c
		%endif

		%if TIED
			%if nc >= width
				; create orphan jump to node to get right side aligned
				widen
				jmp e_%+r%+_%+c
			%endif
		%endif

		e_%+r%+_%+c:
		%if nr >= height
			block_fill r, c
		%elif TIED && nc >= width
			block_fill r, c
			je e_%+nr%+_%+c
		%else
			%if c == 0
				; force unconditional jmp in column 0
				block_fill r, c
				jmp e_%+nr%+_%+nc

				%if TIED
					; warning: exitrep doesn't take effect until endrep is reached
					%exitrep
				%endif
			%else
				block_fill r, c
				%if TIED
					je e_%+nr%+_%+nc
				%else
					jmp e_%+nr%+_%+nc
				%endif
			%endif
		%endif
		
		%assign r r+1
		%if TIED
			%assign c c-1
		%endif
		%if r>=height 
			jmp %5
			%exitrep
		%endif
	%endrep
%endmacro

; table for opening switch
s:
%assign c 0
%rep WIDTH+1
dd e_0_%+c
%assign c c+1
%endrep

global main
main:

init_widen

nop       ; prevent ida from thinking this is a thunk, if no code above us
mov eax, 0
jmp [s+eax*4]

; adjust for adding all on column
%assign WIDTH WIDTH+1

%assign CC 0
%rep WIDTH
	diag 0, CC, WIDTH, HEIGHT, done
	%assign CC CC+1
%endrep

%if TIED
	%assign RC 1
	%rep HEIGHT-1
		diag RC, WIDTH-1, WIDTH, HEIGHT, done
		%assign RC RC+1
	%endrep
%endif

done:
ret
