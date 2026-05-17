#include <stdio.h>

int main() {
    int x = 5;
    if (x > 10) {
        return 1;  // Não deve entrar aqui
    } else {
        return 0;  // Deve retornar 0
    }
}