 #include<stdio.h>
 
int main( int argc, char *argv[] ) {
	unsigned char v[15][16];
	fread( v, 1, 15 * 16, stdin );
	for( int i = 0; i < 15; i++ ) {
		unsigned char t1 = v[i][8];
		unsigned char t2 = v[i][9];
		v[i][8] = v[i][10];
		v[i][9] = v[i][11];
		v[i][10] = t1;
		v[i][11] = t2;
	}
	fwrite( v, 1, 15 * 16, stdout );
	return 0;
}
 
