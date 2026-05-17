# AAI-Compiladores

> Atividade Auto Instrucional - Disciplina de Compiladores - Ciência da Computação

# Compilador LLVM - Demonstração Acadêmica

## 🎯 Objetivo

Demonstrar as etapas de um compilador moderno usando LLVM, desde a análise até a geração de código, containerização e segurança automatizada.

[![CI/CD Pipeline](https://github.com/gustavodcdamas/AAI-Compiladores/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/gustavodcdamas/AAI-Compiladores/actions/workflows/docker-publish.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Arquitetura do Pipeline](#arquitetura-do-pipeline)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e Execução](#instalação-e-execução)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Demonstração Prática](#demonstração-prática)
- [Pipeline CI/CD](#pipeline-cicd)
- [Segurança e Scans](#segurança-e-scans)
- [Troubleshooting](#troubleshooting)
- [Referências](#referências)

---

## 🎯 Visão Geral

Este projeto demonstra, de forma educacional, as etapas de um compilador moderno usando a infraestrutura **LLVM (Low Level Virtual Machine)**. O foco está na etapa de **Geração de Código Intermediário (IR)**.

### Objetivos Acadêmicos

| Etapa do Compilador | Ferramenta Utilizada | Demonstração |
|---------------------|----------------------|--------------|
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

┌─────────────────────────────────────────────────────────────────┐
│ CÓDIGO FONTE (C)                                                │
│ src/exemplo.c                                                   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ FRONT-END: CLANG (-emit-llvm)                                   │
│ • Análise léxica, sintática e semântica                         │
│ • Geração do LLVM IR (Static Single Assignment)                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ MIDDLE-END: OPTIMIZER (opt -O2)                                 │
│ • Constant Folding • Dead Code Elimination                      │
│ • Function Inlining • Loop Unrolling                            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ BACK-END: LLC (llc)                                             │
│ • Seleção de instruções (Pattern Matching)                      │
│ • Alocação de registradores (Greedy Register Allocation)        │
│ • Geração de Assembly x86_64                                    │
└─────────────────────────────────────────────────────────────────┘

## 📦 Pré-requisitos

### Para Execução Local

| Ferramenta | Versão Mínima | Instalação |
|------------|---------------|-------------|
| Docker | 24.0+ | [docker.com](https://docs.docker.com/get-docker/) |
| Docker Compose | 2.20+ | [docs.docker.com](https://docs.docker.com/compose/install/) |
| Git | 2.40+ | [git-scm.com](https://git-scm.com/) |

### Para Desenvolvimento (Opcional - sem Docker)

```bash
sudo apt update
sudo apt install clang-14 llvm-14 lld-14 graphviz make

### Clone o repositório

```bash
git clone https://github.com/gustavodcdamas/AAI-Compiladores.git
cd AAI-Compiladores

### Execute com Docker

```bash
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

### Comandos disponíveis no shell

```bash
# Dentro do container, execute:
./scripts/build.sh          # Gera IR, assembly e executável
./scripts/generate-cfg.sh   # Gera gráficos de fluxo
lli output/exemplo.ll       # Executa o IR diretamente

### Build e testa em um único comando

```bash
# Build e testa em um único comando
docker build -t compilador-llvm:test . && \
docker run --rm compilador-llvm:test /bin/bash -c " \
  echo '=== TESTANDO COMPILADOR ===' && \
  clang --version && \
  echo '--- Teste 1: Código simples ---' && \
  echo 'int main(){return 42;}' | clang -x c - -S -emit-llvm -o - && \
  echo '--- Teste 2: Executando demo ---' && \
  /usr/local/bin/demo.sh \
"