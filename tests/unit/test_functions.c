#include <stdio.h>

int soma(int a, int b) {
    return a + b;
}

int main() {
    int resultado = soma(10, 20);
    printf("Resultado da soma: %d\n", resultado);
    return resultado;
}