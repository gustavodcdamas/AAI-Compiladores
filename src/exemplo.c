#include <stdio.h>

// Função simples para demonstrar operações aritméticas
int soma(int a, int b) {
    return a + b;
}

int multiplica(int x, int y) {
    return x * y;
}

// Função com condicional para demonstrar fluxo de controle
int calcula(int valor) {
    if (valor > 10) {
        printf("Valor > 10, multiplicando por 2\n");
        return multiplica(valor, 2);
    } else {
        printf("Valor <= 10, somando 5\n");
        return soma(valor, 5);
    }
}

int main() {
    printf("=== Demonstracao Compilador LLVM ===\n\n");
    
    // Teste 1: valor <= 10
    int resultado1 = calcula(7);
    printf("Resultado 1 (7): %d\n\n", resultado1);
    
    // Teste 2: valor > 10
    int resultado2 = calcula(15);
    printf("Resultado 2 (15): %d\n\n", resultado2);
    
    return 0;
}