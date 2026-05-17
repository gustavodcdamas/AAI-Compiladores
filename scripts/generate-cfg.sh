#!/bin/bash
# Gera gráficos de fluxo de controle (CFG) a partir do IR

echo "📊 GERANDO GRÁFICOS DE FLUXO DE CONTROLE"
echo "======================================="

mkdir -p output/cfg

# Gera IR se não existir
if [ ! -f output/exemplo.ll ]; then
    clang -S -emit-llvm src/exemplo.c -o output/exemplo.ll
fi

# Gera CFG para cada função
echo "🎨 Gerando CFG para cada função..."

# Usa o opt para gerar arquivos .dot
opt -dot-cfg output/exemplo.ll

# Converte cada .dot para PNG
for dotfile in .*.dot; do
    if [ -f "$dotfile" ]; then
        # Extrai nome da função (remove o ponto inicial)
        funcname=$(echo "$dotfile" | sed 's/^\.//' | sed 's/\.dot$//')
        echo "  Processando: $funcname"
        dot -Tpng "$dotfile" -o "output/cfg/${funcname}.png"
        rm "$dotfile"  # Limpa arquivos temporários
    fi
done

echo "✅ Gráficos gerados em ./output/cfg/"
ls -la output/cfg/