%: gfx/%.bmp
	mkdir -p bin
	cp gfx/$@.bmp gfx/image.bmp
	make -C gfx
	nasm -U TIE -O1 -felf repsych.asm -o ./bin/$@_v1.o
	ld ./bin/$@_v1.o -melf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc -o ./bin/$@_v1
	nasm -D TIE -O1 -felf repsych.asm -o ./bin/$@_v2.o
	ld ./bin/$@_v2.o -melf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc -o ./bin/$@_v2

clean:
	rm -f ./bin/*
	make -C gfx clean
