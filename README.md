# AAI-Compiladores

> Atividade Auto Instrucional — Disciplina de Compiladores — Ciência da Computação

# Compilador LLVM — Demonstração Acadêmica

## Objetivo

Demonstrar, de forma prática e educacional, as principais etapas de um compilador moderno utilizando a infraestrutura LLVM, incluindo:

- Geração de código intermediário (LLVM IR)
- Otimização de código
- Geração de assembly
- Execução do IR
- Containerização com Docker
- Automação com CI/CD
- Segurança automatizada com DevSecOps

[![CI/CD Pipeline](https://github.com/gustavodcdamas/AAI-Compiladores/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/gustavodcdamas/AAI-Compiladores/actions/workflows/docker-publish.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![LLVM](https://img.shields.io/badge/LLVM-14.0-blue)
![Docker](https://img.shields.io/badge/Docker-24.0-blue)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-DevSecOps-blue)

---

# Índice

- [📖 Visão Geral](#-visão-geral)
- [🏗️ Arquitetura do Pipeline](#️-arquitetura-do-pipeline)
- [⚙️ Pré-requisitos](#️-pré-requisitos)
- [🚀 Instalação e Execução](#-instalação-e-execução)
- [📁 Estrutura do Projeto](#-estrutura-do-projeto)
- [🎬 Demonstração Prática](#-demonstração-prática)
- [🔄 Pipeline CI/CD](#-pipeline-cicd)
- [🛡️ Segurança e Scans](#️-segurança-e-scans)
- [🐛 Troubleshooting](#-troubleshooting)
- [📚 Referências](#-referências)
- [👥 Autor](#-autor)

---

# Visão Geral

Este projeto demonstra, de maneira acadêmica, como funciona um compilador moderno utilizando a infraestrutura **LLVM (Low Level Virtual Machine)**.

O foco principal está nas etapas de:

- Geração de LLVM IR
- Otimização de código
- Fluxo de controle (CFG)
- Conversão para assembly
- Execução do código compilado

---

## Objetivos Acadêmicos

| Etapa do Compilador | Ferramenta | Demonstração |
|---|---|---|
| Geração de IR | `clang -emit-llvm` | Transformação de C → LLVM IR |
| Análise de Fluxo | `opt -dot-cfg` | Geração de CFG |
| Otimização | `opt -O2` | IR sem/com otimização |
| Geração de Assembly | `llc` | LLVM IR → x86_64 |
| Execução | `lli` / executável | Interpretação do IR |

---

# Arquitetura do Pipeline

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
│ • Geração do LLVM IR (SSA - Static Single Assignment)           │
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
│ • Seleção de instruções                                        │
│ • Alocação de registradores                                    │
│ • Geração de Assembly x86_64                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

# Pré-requisitos

Antes de executar o projeto, é necessário possuir:

- Docker ≥ 24
- Docker Compose
- Make
- Git

---

# Instalação e Execução

## Clone o repositório

```bash
git clone https://github.com/gustavodcdamas/AAI-Compiladores.git

cd AAI-Compiladores
```

---

## Executando com Docker

### Construir a imagem

```bash
make build

# ou

docker-compose build
```

---

### Executar a demonstração completa

```bash
make demo

# ou

docker-compose run --rm compilador-llvm /usr/local/bin/demo.sh
```

---

### Abrir shell interativo

```bash
make shell

# ou

docker-compose run --rm compilador-llvm /bin/bash
```

---

# Comandos disponíveis dentro do container

```bash
# Gerar LLVM IR, assembly e executável
./scripts/build.sh

# Gerar gráficos CFG
./scripts/generate-cfg.sh

# Executar LLVM IR diretamente
lli output/exemplo.ll
```

---

# Build e Teste em Um Único Comando

```bash
docker build -t compilador-llvm:test . && \
docker run --rm compilador-llvm:test /bin/bash -c " \
  echo '=== TESTANDO COMPILADOR ===' && \
  clang --version && \
  echo '--- Teste 1: Código simples ---' && \
  echo 'int main(){return 42;}' | clang -x c - -S -emit-llvm -o - && \
  echo '--- Teste 2: Executando demo ---' && \
  /usr/local/bin/demo.sh \
"
```

---

# Estrutura do Projeto

```text
AAI-Compiladores/
├── .github/workflows/
│   └── docker-publish.yml    # Pipeline CI/CD
├── scripts/
│   ├── build.sh              # Gera representações
│   ├── generate-cfg.sh       # Gera gráficos CFG
│   ├── demo.sh               # Demonstração automática
│   └── run-tests.sh          # Suite de testes
├── src/
│   └── exemplo.c             # Código-fonte principal
├── tests/
│   ├── unit/                 # Testes unitários
│   ├── integration/          # Testes de integração
│   └── regression/           # Testes de regressão
├── output/                   # Artefatos gerados
├── Dockerfile
├── docker-compose.yml
├── Makefile
└── README.md
```

---

## Arquivos Gerados (`output/`)

| Arquivo | Descrição |
|---|---|
| `exemplo.ll` | LLVM IR textual |
| `exemplo_opt.ll` | IR otimizado |
| `exemplo.s` | Assembly x86_64 |
| `programa` | Executável compilado |
| `cfg/*.png` | Gráficos CFG |

---

# Demonstração Prática

## Código Fonte (`src/exemplo.c`)

```c
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
    printf("Resultado (7): %d\n", calcula(7));
    printf("Resultado (15): %d\n", calcula(15));
    return 0;
}
```

---

## LLVM IR Gerado (Exemplo)

```llvm
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
```

---

## Saída da Execução

```text
=== Demonstracao Compilador LLVM ===

Valor <= 10, somando 5
Resultado 1 (7): 12

Valor > 10, multiplicando por 2
Resultado 2 (15): 30
```

---

# Pipeline CI/CD

O pipeline executa automaticamente a cada `push` na branch `main`.

| Etapa | Ferramenta | Descrição |
|---|---|---|
| 1 | Docker Buildx | Build da imagem |
| 2 | Trivy | Scan de vulnerabilidades |
| 3 | Gitleaks | Detecção de secrets |
| 4 | Docker Push | Publicação da imagem |

---

# 🛡️ Segurança e Scans

## Trivy

Exemplo de `.trivyignore`:

```bash
# Vulnerabilidade aceita/documentada
CVE-2024-12345
```

---

## Gitleaks

Exemplo de `.gitleaks.toml`:

```toml
[extend]
useDefault = true

[[rules]]
id = "custom-api-key"
description = "Mailgun API Key"
regex = '''key-[a-f0-9]{32}'''
```

---

# Troubleshooting

## Erro: `make: command not found`

```bash
# Ubuntu/Debian
sudo apt install make

# macOS
brew install make
```

---

## Erro: `permission denied`

```bash
chmod +x scripts/*.sh
```

---

## Erro no pipeline: `Trivy scan failed`

Verifique se a imagem foi carregada corretamente utilizando:

```yaml
load: true
```

no step de build.

---

## Container encerrando com código 137

Execute com limite maior de memória:

```bash
docker run \
  --memory="2g" \
  --memory-swap="2g" \
  -it --rm \
  compilador-llvm:latest \
  /bin/bash
```

---

# 📚 Referências

- LLVM LangRef
- Clang User Manual
- LLVM Documentation
- Trivy Documentation
- GitHub Actions Documentation
- Docker Documentation
- LLVM: A Compilation Framework for Lifelong Program Analysis & Transformation

---

# 👥 Autor

| Nome | Papel |
|---|---|
| Gustavo Damas | Desenvolvedor |

---

## 🎓 Instituição - FUMEC

**Curso:** Ciência da Computação  
**Disciplina:** Compiladores  
**Data:** Maio/2026
