// Advent of code 2018 day 1 part 1
// compile: % gcc -g -oO -Wall 1_1_sum_numbers.c -o 1_1_sum_numbers.o
// usage: 1_1_sum_numbers.o input.txt
#include <stdio.h>

int main(int argc, char *argv[]){
    int sum = 0;
    int value;
    FILE * f = fopen(argv[1], "r");
    while(!feof (f)  ){
        fscanf(f, "%d", &value);
        sum += value;
        value = 0;
    }
    fclose(f);
    printf("%d\n", sum);
}
