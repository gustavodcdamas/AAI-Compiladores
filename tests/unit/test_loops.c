#include <stdio.h>

int main() {
    int sum = 0;
    for (int i = 0; i < 10; i++) {
        sum += i;
    }
    printf("Soma do loop: %d\n", sum);
    return sum;
}