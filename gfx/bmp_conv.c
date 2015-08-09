/*
 * REpsych
 * domas, @xoreaxeaxeax
 *
 * This file converts bitmap images to nasm constants.
 */

#include <stdio.h>
#include <stdlib.h>

#define MAX_BITMAP_SIZE    (1024*1024)
#define WIDTH_FIELD        18
#define HEIGHT_FIELD       22
#define PIXEL_ARRAY        54

int get_bitmap_width(unsigned char bitmap[]);
int get_bitmap_height(unsigned char bitmap[]);
unsigned char get_color_at(unsigned char bitmap[], int i);
unsigned char get_bw_at(unsigned char bitmap[], int x, int y);

unsigned char bitmap[MAX_BITMAP_SIZE];

int main(int argc, char** argv)
{
	int c;
	int x=0, y=0;
	int w, h;
	int i=0;

	while ((c=getchar())!=EOF) {
		bitmap[i++]=c;
	}

	w=get_bitmap_width(bitmap);
	h=get_bitmap_height(bitmap);

	printf("%%assign WIDTH %d\n", w);
	printf("%%assign HEIGHT %d\n", h);

	for (y=0; y<h; y++) {
		for (x=0; x<w; x++) {
			c=get_bw_at(bitmap, x, y);
			printf("%%assign pixel_%d_%d %d\n", x, y, c);
		}
	}

	return 0;
}

int get_bitmap_width(unsigned char bitmap[])
{
	return *(int*)(bitmap+WIDTH_FIELD);
}

int get_bitmap_height(unsigned char bitmap[])
{
	return *(int*)(bitmap+HEIGHT_FIELD);
}

unsigned char get_bw_at(unsigned char bitmap[], int x, int y)
{
	int width=*(int*)(bitmap+WIDTH_FIELD);
	int height=*(int*)(bitmap+HEIGHT_FIELD);
	return
		(
				get_color_at(bitmap, (height-y-1)*width*3+3*x+0)+
				get_color_at(bitmap, (height-y-1)*width*3+3*x+1)+
				get_color_at(bitmap, (height-y-1)*width*3+3*x+2)
		) / 3;
}

unsigned char get_color_at(unsigned char bitmap[], int i)
{
	int width=*(int*)(bitmap+WIDTH_FIELD);
	return *(bitmap+PIXEL_ARRAY+(width*3+3)/4*4*(i/3/width)+(i-i/3/width*width*3));
}
