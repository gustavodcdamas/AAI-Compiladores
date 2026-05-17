# AAI-Compiladores

> Atividade Auto Instrucional - Disciplina de Compiladores - Ciência da Computação

# Compilador LLVM - Demonstração Acadêmica

## 🎯 Objetivo

Demonstrar as etapas de um compilador moderno usando LLVM, desde a análise até a geração de código, containerização e segurança automatizada.

[![CI/CD Pipeline](https://github.com/gustavodcdamas/AAI-Compiladores/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/gustavodcdamas/AAI-Compiladores/actions/workflows/docker-publish.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Arquitetura do Pipeline](#%EF%B8%8F-arquitetura-do-pipeline)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação e Execução](#-instalação-e-execução)
- [Demonstração Prática](#-demonstração-prática)
- [Pipeline CI/CD](#-pipeline-cicd)
- [Segurança e Scans](#-segurança-e-scans)
- [Troubleshooting](#-troubleshooting)
- [Referências](#-referências)
- [Autor](#-autor)

---

## 🎯 Visão Geral

Este projeto demonstra, de forma educacional, as etapas de um compilador moderno usando a infraestrutura **LLVM (Low Level Virtual Machine)**. O foco está na etapa de **Geração de Código Intermediário (IR)**.

### Objetivos Acadêmicos

| Etapa do Compilador | Ferramenta Utilizada | Demonstração |
|:---|:---|:---|
| Geração de IR | Clang (`-emit-llvm`) | Transformação de C → LLVM IR |
| Análise de Fluxo | `opt -dot-cfg` | Geração de gráficos de blocos básicos |
| Otimização | `opt -O2` | Comparação IR sem/com otimização |
| Geração de Assembly | `llc` | IR → Código de máquina (x86_64) |
| Execução | `lli` / executável | Interpretação direta do IR |

### Stack Tecnológica

![LLVM](https://img.shields.io/badge/LLVM-14.0-blue)
![Docker](https://img.shields.io/badge/Docker-24.0-blue)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-DevSecOps-blue)

---

## 🏗️ Arquitetura do Pipeline

```text
┌─────────────────────────────────────────────────────────────────┐
│                        CÓDIGO FONTE (C)                         │
│                          src/exemplo.c                          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                 FRONT-END: CLANG (-emit-llvm)                   │
│ • Análise léxica, sintática e semântica                         │
│ • Geração do LLVM IR (Static Single Assignment)                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                MIDDLE-END: OPTIMIZER (opt -O2)                  │
│ • Constant Folding                  • Dead Code Elimination     │
│ • Function Inlining                 • Loop Unrolling            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                        BACK-END: LLC (llc)                      │
│ • Seleção de instruções (Pattern Matching)                      │
│ • Alocação de registradores (Greedy Register Allocation)        │
│ • Geração de Assembly x86_64                                    │
└─────────────────────────────────────────────────────────────────┘
🚀 Instalação e Execução
Clone o repositório
bash

git clone https://github.com/gustavodcdamas/AAI-Compiladores.git
cd AAI-Compiladores

Execute com Docker
bash

# Constrói a imagem
make build
# ou
docker-compose build

# Executa a demonstração completa
make demo
# ou
docker-compose run --rm compilador-llvm /usr/local/bin/demo.sh

# Abre shell interativo para explorar
make shell
# ou
docker-compose run --rm compilador-llvm /bin/bash

Comandos disponíveis no shell
bash

# Dentro do container, execute:
./scripts/build.sh          # Gera IR, assembly e executável
./scripts/generate-cfg.sh   # Gera gráficos de fluxo
lli output/exemplo.ll       # Executa o IR diretamente

Build e testa em um único comando
bash

docker build -t compilador-llvm:test . && \
docker run --rm compilador-llvm:test /bin/bash -c " \
  echo '=== TESTANDO COMPILADOR ===' && \
  clang --version && \
  echo '--- Teste 1: Código simples ---' && \
  echo 'int main(){return 42;}' | clang -x c - -S -emit-llvm -o - && \
  echo '--- Teste 2: Executando demo ---' && \
  /usr/local/bin/demo.sh \
"

📁 Estrutura do Projeto
text

AAI-Compiladores/
├── .github/workflows/
│   └── docker-publish.yml    # Pipeline CI/CD
├── scripts/
│   ├── build.sh              # Gera representações
│   ├── generate-cfg.sh       # Gera gráficos CFG
│   ├── demo.sh               # Script de demonstração
│   └── run-tests.sh          # Suite de testes
├── src/
│   └── exemplo.c             # Código fonte
├── tests/
│   ├── unit/                 # Testes unitários
│   ├── integration/          # Testes de integração
│   └── regression/           # Testes de regressão
├── output/                   # Diretório gerado
├── Dockerfile
├── docker-compose.yml
├── Makefile
└── README.md

Arquivos Gerados (diretório output/)
Arquivo	Descrição
exemplo.ll	LLVM IR (textual)
exemplo_opt.ll	IR otimizado com -O2
exemplo.s	Código Assembly x86_64
programa	Executável binário
cfg/*.png	Gráficos do fluxo de controle
🎬 Demonstração Prática
Código Fonte (src/exemplo.c)
c

#include <stdio.h>

int soma(int a, int b) {
    return a + b;
}

int multiplica(int x, int y) {
    return x * y;
}

int calcula(int valor) {
    if (valor > 10) {
        return multiplica(valor, 2);
    } else {
        return soma(valor, 5);
    }
}

int main() {
    printf("Resultado (7): %d\n", calcula(7));   // 7+5 = 12
    printf("Resultado (15): %d\n", calcula(15)); // 15*2 = 30
    return 0;
}

LLVM IR Gerado (exemplo)
llvm

define i32 @soma(i32 %a, i32 %b) {
entry:
  %add = add nsw i32 %a, %b
  ret i32 %add
}

define i32 @calcula(i32 %valor) {
entry:
  %cmp = icmp sgt i32 %valor, 10
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %call = call i32 @multiplica(i32 %valor, i32 2)
  ret i32 %call

if.else:
  %call1 = call i32 @soma(i32 %valor, i32 5)
  ret i32 %call1
}

Saída da Execução
text

=== Demonstracao Compilador LLVM ===

Valor <= 10, somando 5
Resultado 1 (7): 12

Valor > 10, multiplicando por 2
Resultado 2 (15): 30

🔄 Pipeline CI/CD

O pipeline executa automaticamente em todo push para a branch main:
Etapa	Ferramenta	Descrição
1	Docker Buildx	Constrói a imagem com cache
2	Trivy	Escaneia vulnerabilidades (CRITICAL/HIGH)
3	Gitleaks	Escaneia secrets no código
4	Docker Push	Publica no Docker Hub (se scan OK)
🛡️ Segurança e Scans
Trivy Configuration

O arquivo .trivyignore permite documentar vulnerabilidades aceitas:
bash

# Exemplo: CVE-2024-12345 - libc6 vulnerabilidade em função não utilizada
CVE-2024-12345

Gitleaks

Para configurar o Gitleaks, crie um arquivo .gitleaks.toml:
toml

[extend]
useDefault = true

[[rules]]
id = "custom-api-key"
description = "Mailgun API Key"
regex = '''key-[a-f0-9]{32}'''

🐛 Troubleshooting
Erro: make: command not found
bash

sudo apt install make  # Linux
brew install make      # macOS

Erro: permission denied ao executar scripts
bash

chmod +x scripts/*.sh

Erro no pipeline: Trivy scan failed

Verifique se a imagem foi carregada com load: true no step de build.
Container com problema de memória (exit 137)
bash

# Execute com limite de memória
docker run --memory="2g" --memory-swap="2g" -it --rm aai-compiladores-compilador-llvm:latest /bin/bash

📚 Referências

    LLVM LangRef

    Clang User Manual

    Trivy Documentation

    GitHub Actions

    LLVM: A Compilation Framework for Lifelong Program Analysis & Transformation

👥 Autor
Nome	Papel
Gustavo Damas	Desenvolvedor

Instituição: [Nome da Universidade] - Ciência da Computação
Disciplina: Compiladores
Data: Maio/2026
