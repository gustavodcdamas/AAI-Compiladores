#!/bin/bash
# Script para construir todas as etapas do compilador

set -e

echo "🔨 CONSTRUINDO O COMPILADOR LLVM DEMO"
echo "===================================="

# Cria diretório de saída
mkdir -p output

# Verifica memória disponível
MEM_AVAIL=$(free -m | awk '/^Mem:/{print $7}')
MIN_MEM=500  # 500MB mínimo

if [ $MEM_AVAIL -lt $MIN_MEM ]; then
    echo "⚠️ Low memory detected (${MEM_AVAIL}MB). Using lightweight mode..."
    export CFLAGS="-O1"  # Reduz otimização para economizar memória
fi


# 1. Gera o LLVM IR
echo "📝 1. Gerando LLVM IR (exemplo.ll)..."
clang -S -emit-llvm src/exemplo.c -o output/exemplo.ll
sync && echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true

# 2. Gera o IR otimizado
echo "⚡ 2. Gerando IR otimizado (exemplo_opt.ll)..."
opt -O2 output/exemplo.ll -S -o output/exemplo_opt.ll
sync && echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true

# 3. Gera código assembly
echo "🔧 3. Gerando Assembly (exemplo.s)..."
llc output/exemplo.ll -o output/exemplo.s
sync && echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true

# 4. Gera executável
echo "🚀 4. Gerando executável (programa)..."
clang src/exemplo.c -o output/programa

echo "✅ Build concluído! Arquivos em ./output/"