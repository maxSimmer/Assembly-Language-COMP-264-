
#include <stdio.h>

char array[1024] = "longstring";


void main(){
        int k;
        char *p;
        p = array; // LEA array, a0

        while(*p != '\0'){ // while loop
                *p -= 32; // sub 32
                p++; // increment
        }

        printf("%s\n", array);

        return;
}

