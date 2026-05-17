#!/bin/bash
# Script completo para demonstração ao vivo

echo "🎓 DEMONSTRAÇÃO COMPLETA - COMPILADOR LLVM"
echo "=========================================="
echo ""

# Cores para melhor visualização
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para pausar a demonstração
pause() {
    echo ""
    read -p "⏸️  Pressione ENTER para continuar a demonstração..." 
    echo ""
}

# Etapa 1: Mostrar código fonte
echo -e "${BLUE}📄 ETAPA 1: CÓDIGO FONTE${NC}"
echo "-----------------------------------"
echo -e "${YELLOW}Arquivo: src/exemplo.c${NC}"
echo ""
cat src/exemplo.c | head -20
echo "..."
pause

# Etapa 2: Gerar e mostrar IR
echo -e "${BLUE}🔧 ETAPA 2: GERANDO LLVM IR${NC}"
echo "-----------------------------------"
echo -e "${YELLOW}Comando: clang -S -emit-llvm src/exemplo.c -o output/exemplo.ll${NC}"
echo ""
./scripts/build.sh
echo ""
echo -e "${GREEN}✓ IR Gerado!${NC}"
echo ""
echo -e "${YELLOW}Conteúdo do IR (primeiras 30 linhas):${NC}"
head -30 output/exemplo.ll
pause

# Etapa 3: Explicar o IR
echo -e "${BLUE}📖 ETAPA 3: ANALISANDO O IR${NC}"
echo "-----------------------------------"
echo -e "${GREEN}Características do LLVM IR:${NC}"
echo "• Forma SSA (Static Single Assignment)"
echo "• Instruções como: %add = add i32 %a, %b"
echo "• Tipagem forte (i32, i8*, etc.)"
echo "• Independente de arquitetura"
echo ""
echo -e "${YELLOW}Exemplo prático (função soma):${NC}"
grep -A 3 "define i32 @soma" output/exemplo.ll
pause

# Etapa 4: Gerar gráficos CFG
echo -e "${BLUE}📊 ETAPA 4: ANÁLISE DE FLUXO${NC}"
echo "-----------------------------------"
echo -e "${YELLOW}Gerando gráficos de fluxo de controle...${NC}"
./scripts/generate-cfg.sh
echo ""
echo -e "${GREEN}✓ Gráficos gerados!${NC}"
echo -e "Veja os arquivos PNG em: ${BLUE}output/cfg/${NC}"
echo ""
echo -e "${YELLOW}O gráfico mostra:${NC}"
echo "• Blocos básicos (entry, then, else, return)"
echo "• Arestas de controle (condições)"
echo "• Estrutura do if/else"
pause

# Etapa 5: Mostrar otimização
echo -e "${BLUE}⚡ ETAPA 5: OTIMIZAÇÃO${NC}"
echo "-----------------------------------"
echo -e "${YELLOW}Comparando IR sem e com otimização (-O2)${NC}"
echo ""
echo -e "${GREEN}SEM otimização (exemplo.ll):${NC}"
echo "Função calcula antes:"
grep -A 15 "define i32 @calcula" output/exemplo.ll | head -10
echo ""
echo -e "${GREEN}COM otimização (exemplo_opt.ll):${NC}"
grep -A 10 "define i32 @calcula" output/exemplo_opt.ll | head -8
pause

# Etapa 6: Executar programa
echo -e "${BLUE}🚀 ETAPA 6: EXECUTANDO O PROGRAMA${NC}"
echo "-----------------------------------"
echo -e "${YELLOW}Opção 1 - Interpretando o IR diretamente (lli):${NC}"
echo "Comando: lli output/exemplo.ll"
echo ""
lli output/exemplo.ll
echo ""
echo -e "${YELLOW}Opção 2 - Executando o binário compilado:${NC}"
echo "Comando: ./output/programa"
echo ""
./output/programa
echo ""
pause

# Etapa 7: Gerar assembly
echo -e "${BLUE}🔬 ETAPA 7: CÓDIGO ASSEMBLY${NC}"
echo "-----------------------------------"
echo -e "${YELLOW}Gerando assembly com llc:${NC}"
echo ""
echo -e "${GREEN}Primeiras 20 linhas do assembly gerado:${NC}"
head -20 output/exemplo.s
pause

# Finalização
echo -e "${BLUE}✅ DEMONSTRAÇÃO CONCLUÍDA${NC}"
echo "=========================================="
echo -e "${GREEN}Arquivos gerados:${NC}"
echo "• output/exemplo.ll      - LLVM IR"
echo "• output/exemplo_opt.ll  - IR otimizado"
echo "• output/exemplo.s       - Assembly"
echo "• output/programa        - Executável"
echo "• output/cfg/*.png       - Gráficos CFG"
echo ""
echo -e "${YELLOW}Dica para apresentação: Abra os gráficos PNG para mostrar visualmente!${NC}"