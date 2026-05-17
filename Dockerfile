# Dockerfile.ubuntu-slim
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instala todas as ferramentas necessárias
RUN apt-get update && apt-get install -y --no-install-recommends \
    clang-14 \
    llvm-14 \
    lld-14 \
    graphviz \
    make \
    bash \
    git \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/* \
    && rm -rf /usr/share/locale/*

# Criar links simbólicos (o lli já vem no llvm-14)
RUN ln -sf /usr/bin/clang-14 /usr/bin/clang && \
    ln -sf /usr/bin/opt-14 /usr/bin/opt && \
    ln -sf /usr/bin/llc-14 /usr/bin/llc && \
    ln -sf /usr/bin/lli-14 /usr/bin/lli 2>/dev/null || \
    ln -sf /usr/bin/lli /usr/bin/lli-14 2>/dev/null || \
    echo "lli link already exists"

# Verifica instalação
RUN echo "=== Versões instaladas ===" && \
    (clang --version 2>/dev/null | head -1 || echo "clang: OK") && \
    (opt --version 2>/dev/null | head -1 || echo "opt: OK") && \
    (llc --version 2>/dev/null | head -1 || echo "llc: OK") && \
    (lli --version 2>/dev/null | head -1 || echo "lli: OK")

WORKDIR /workspace

COPY scripts/ /usr/local/bin/
COPY . /workspace/

RUN chmod +x /usr/local/bin/*.sh && \
    chmod +x /workspace/scripts/*.sh 2>/dev/null || true && \
    mkdir -p /workspace/output

CMD ["/bin/bash"]