#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
FAILED=0

echo -e "${BLUE}🧪 INICIANDO TESTES DO COMPILADOR LLVM${NC}"
echo "======================================="

# Função para executar um teste
run_test() {
    local test_file=$1
    local test_name=$(basename "$test_file" .c)
    
    echo -n "📝 Testando: $test_name ... "
    
    # Verifica se o arquivo existe
    if [ ! -f "$test_file" ]; then
        echo -e "${RED}✗ FILE NOT FOUND${NC}"
        ((FAILED++))
        return 1
    fi
    
    # Compila para IR
    if ! clang -S -emit-llvm "$test_file" -o "/tmp/${test_name}.ll" 2>/tmp/clang_error.log; then
        echo -e "${RED}✗ COMPILATION FAILED${NC}"
        if [ -s /tmp/clang_error.log ]; then
            echo "  Erro: $(head -1 /tmp/clang_error.log)"
        fi
        ((FAILED++))
        return 1
    fi
    
    # Executa via LLI e captura saída e código de saída
    lli "/tmp/${test_name}.ll" > "/tmp/${test_name}.out" 2>/tmp/lli_error.log
    local exit_code=$?
    
    # Mostra a saída do programa (se houver)
    if [ -s "/tmp/${test_name}.out" ]; then
        echo -n " $(cat /tmp/${test_name}.out | tr '\n' ' ') "
    fi
    
    # 🔧 CORREÇÃO: Verifica o valor de retorno esperado baseado no nome do teste
    local expected=0
    case $test_name in
        "test_arithmetic") expected=30 ;;
        "test_conditions") expected=0 ;;
        "test_functions") expected=30 ;;
        "test_loops") expected=45 ;;
        *) expected=0 ;;
    esac
    
    if [ $exit_code -eq $expected ]; then
        echo -e "${GREEN}✓ PASSED (retornou $exit_code)${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAILED (esperado $expected, retornou $exit_code)${NC}"
        if [ -s /tmp/lli_error.log ]; then
            echo "  Erro: $(head -1 /tmp/lli_error.log)"
        fi
        ((FAILED++))
        return 1
    fi
}

# Testes unitários
echo ""
echo -e "${BLUE}📦 TESTES UNITÁRIOS${NC}"
echo "-------------------"

if [ ! -d "tests/unit" ]; then
    echo -e "${RED}✗ Diretório tests/unit não encontrado!${NC}"
    exit 1
fi

# Lista os arquivos encontrados
echo "  Arquivos encontrados:"
for test_file in tests/unit/*.c; do
    if [ -f "$test_file" ]; then
        echo "    - $(basename "$test_file")"
    fi
done
echo ""

# Executa os testes
for test_file in tests/unit/*.c; do
    if [ -f "$test_file" ]; then
        run_test "$test_file"
    fi
done

# Sumário
echo ""
echo "======================================="
echo -e "${BLUE}📊 RESULTADO FINAL${NC}"
echo "   ✅ Passed: $PASSED"
echo "   ❌ Failed: $FAILED"
echo "======================================="

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 TODOS OS TESTES PASSARAM!${NC}"
    exit 0
else
    echo -e "${RED}💥 $FAILED teste(s) falharam${NC}"
    exit 1
fi
