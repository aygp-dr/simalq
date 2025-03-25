# Simalq Makefile

.PHONY: help install run test test-single clean lint install-dev

help:
	@echo "Simalq Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  help        - Show this help message"
	@echo "  install     - Install the package"
	@echo "  install-dev - Install the package in development mode"
	@echo "  run         - Run the game"
	@echo "  run-tutorial- Run the Tutorial Quest"
	@echo "  test        - Run all tests"
	@echo "  test-single - Run a single test (usage: make test-single TEST=test_file.hy::test_function_name)"
	@echo "  lint        - Run linting checks"
	@echo "  clean       - Clean build artifacts"

install:
	pip install .

install-dev:
	pip install -e .

run:
	python3 -m simalq

run-tutorial:
	python3 -m simalq Tutorial_Quest

test:
	pytest

test-single:
	@if [ -z "$(TEST)" ]; then \
		echo "Please specify a test: make test-single TEST=test_file.hy::test_function_name"; \
		exit 1; \
	fi
	pytest tests/$(TEST)

lint:
	@echo "Checking for syntax errors in Hy files..."
	@find . -name "*.hy" -type f -print0 | xargs -0 -n1 hy -c "import hy, sys; code = open(sys.argv[1]).read(); hy.read(code)" 2>/dev/null || \
		{ echo "Syntax errors found in Hy files"; exit 1; }
	@echo "Syntax check complete."

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf __pycache__/
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete