#!/bin/bash
echo "📊 BENCHMARK DO COMPILADOR"
echo "=========================="

echo "🔧 Compilando com diferentes níveis de otimização..."

for opt in O0 O1 O2 O3; do
    echo ""
    echo "📈 Otimização -$opt:"
    clang -$opt tests/benchmark/matrix.c -o /tmp/matrix_$opt
    time /tmp/matrix_$opt
done