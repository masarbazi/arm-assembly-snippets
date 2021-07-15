#include<math.h>

float result;
float input;
float a;
float p;
float q; 
float x1;
float x2;
float x3;

void calcCbrt() {
	result = cbrt(input);
	return ;
}

void calcNegDelta() {
	x1 = (2/sqrt(3)) * sqrt(-1 * p) * sin((1/3) * asin((3 * sqrt(3) * q) / (2 * pow(sqrt(-1 * p), 3)))) - (a/3);
	x2 = (-1 * 2/sqrt(3)) * sqrt(-1 * p) * sin((1/3) * asin((3 * sqrt(3) * q) / (2 * pow(sqrt(-1 * p), 3))) + (3.1415 / 3)) - (a/3);
	x3 = (2/sqrt(3)) * sqrt(-1 * p) * cos((1/3) * asin((3 * sqrt(3) * q) / (2 * pow(sqrt(-1 * p), 3))) + (3.1415 / 6)) - (a/3);
}
