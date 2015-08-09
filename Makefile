all: gfx/image.asm v1 v2

gfx/image.asm:
	make -C gfx

v1:
	nasm -U TIE -O1 -felf repsych.asm -o repsych_v1.o
	ld repsych_v1.o -melf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc -o repsych_v1

v2:
	nasm -D TIE -O1 -felf repsych.asm -o repsych_v2.o
	ld repsych_v2.o -melf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc -o repsych_v2

clean:
	rm repsych_v1 repsych_v2 repsych_v1.o repsych_v2.o
	make -C gfx clean
