#include <stdio.h>

/* função normal: gera IR com SSA */
int soma(int a, int b) {
    return a + b;
}

/* dead code: nunca chamada no main
   o opt -O2 vai ELIMINAR essa função do IR */
int nunca_usada() {
    return 42;
}

/* constant folding: 10 * 2 são constantes
   o opt -O2 vai PRÉ-CALCULAR e gerar direto: ret i32 20 */
int dobro_dez() {
    return 10 * 2;
}

/* CFG com if/else: gera 3 blocos básicos no IR
   entry → if.then OU if.else */
int calcula(int v) {
    if (v > 10) {
        return v * 2;
    } else {
        return soma(v, 5);
    }
}

int main() {
    printf("soma(3, 4):    %d\n", soma(3, 4));       /* 7  */
    printf("dobro_dez():   %d\n", dobro_dez());      /* 20 */
    printf("calcula(7):    %d\n", calcula(7));        /* 12 */
    printf("calcula(15):   %d\n", calcula(15));       /* 30 */
    return 0;
}
