help:
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

format: ## Format code
	@echo "Formatting code..."
	@dart format lib/ test/ example/

analyze: ## Analyze code with linter
	@echo "Analyzing code..."
	@dart analyze lib/ test/ example/

test: ## Run tests
	@echo "Running tests..."
	@dart test
