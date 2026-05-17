.PHONY: build demo clean shell help test test-unit test-integration test-regression test-all build-and-test test-coverage quick

help:
	@echo "Comandos disponíveis:"
	@echo "  make build  - Constrói o container Docker"
	@echo "  make demo   - Executa a demonstração completa"
	@echo "  make shell  - Abre shell interativo no container"
	@echo "  make clean  - Remove container e arquivos gerados"

build:
	docker-compose build

demo:
	docker-compose run --rm compilador-llvm /usr/local/bin/demo.sh

shell:
	docker-compose run --rm compilador-llvm /bin/bash

clean:
	docker-compose down -v
	rm -rf output/
	rm -f .*.dot

# Testes
test-unit:
	@echo "🧪 Executando testes unitários..."
	@docker run --rm -v $(PWD)/tests:/workspace/tests $(IMAGE_NAME) \
		/bin/bash -c "cd /workspace && ./scripts/run-tests.sh --unit"

test-integration:
	@echo "🔗 Executando testes de integração..."
	@docker run --rm -v $(PWD)/tests:/workspace/tests $(IMAGE_NAME) \
		/bin/bash -c "cd /workspace && ./scripts/run-tests.sh --integration"

test-regression:
	@echo "🔄 Executando testes de regressão..."
	@docker run --rm -v $(PWD)/tests:/workspace/tests $(IMAGE_NAME) \
		/bin/bash -c "cd /workspace && ./scripts/run-tests.sh --regression"

test-all:
	@echo "🚀 Executando todos os testes..."
	@docker run --rm -v $(PWD)/tests:/workspace/tests $(IMAGE_NAME) \
		/bin/bash -c "cd /workspace && ./scripts/run-tests.sh"

# Build + Test
build-and-test: build test-all

# Test coverage (com llvm-cov)
test-coverage:
	@echo "📊 Gerando relatório de cobertura..."
	@docker run --rm -v $(PWD):/workspace $(IMAGE_NAME) \
		/bin/bash -c "cd /workspace && \
			clang -fprofile-instr-generate -fcoverage-mapping tests/*.c -o test && \
			LLVM_PROFILE_FILE=\"test.profraw\" ./test && \
			llvm-profdata merge -sparse test.profraw -o test.profdata && \
			llvm-cov show ./test -instr-profile=test.profdata"

# Para desenvolvimento rápido
quick: build demo