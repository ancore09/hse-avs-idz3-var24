#include <stdio.h>
#include <math.h>

void output(char *path, double e, int n) {
    FILE *fp = fopen(path, "w");
    if (fp == NULL) {
        printf("you must provide a valid file path\n");
        return;
    }
    fprintf(fp, "e = %.*f\n", n, e);
    fclose(fp);
}

int main(int argc, char** argv)
{
    if (argc != 2) {
        printf("you must a file path\n");
        return 1;
    }

    register double e asm("xmm0") = 1.0;
    register double term asm("xmm1") = 1.0;
    register double i asm("xmm2") = 1;

    while (term != 0.0) {
        term *= 1.0 / i;
        e += term;
        i++;
    }

    output(argv[1], e, 55);
}