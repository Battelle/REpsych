all: image.asm

image.asm: bmp_conv image.bmp
	./bmp_conv < image.bmp > image.asm

bmp_conv: bmp_conv.c
	gcc bmp_conv.c -o bmp_conv

clean:
	rm -f bmp_conv image.asm
