# Makefile for VPC Gateway Endpoints Terraform Module

.PHONY: help init plan apply destroy validate fmt lint test clean

# Default target
help:
	@echo "Available targets:"
	@echo "  init     - Initialize Terraform"
	@echo "  plan     - Show Terraform plan"
	@echo "  apply    - Apply Terraform configuration"
	@echo "  destroy  - Destroy Terraform resources"
	@echo "  validate - Validate Terraform configuration"
	@echo "  fmt      - Format Terraform code"
	@echo "  lint     - Lint Terraform code with tflint"
	@echo "  test     - Run tests"
	@echo "  clean    - Clean up temporary files"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init

# Show Terraform plan
plan: init
	@echo "Planning Terraform configuration..."
	terraform plan

# Apply Terraform configuration
apply: init
	@echo "Applying Terraform configuration..."
	terraform apply

# Destroy Terraform resources
destroy: init
	@echo "Destroying Terraform resources..."
	terraform destroy

# Validate Terraform configuration
validate:
	@echo "Validating Terraform configuration..."
	terraform validate

# Format Terraform code
fmt:
	@echo "Formatting Terraform code..."
	terraform fmt -recursive

# Lint Terraform code (requires tflint)
lint:
	@echo "Linting Terraform code..."
	@if command -v tflint >/dev/null 2>&1; then \
		tflint; \
	else \
		echo "tflint not found. Install with: go install github.com/terraform-linters/tflint/cmd/tflint@latest"; \
		exit 1; \
	fi

# Run tests (requires terratest)
test:
	@echo "Running tests..."
	@if command -v go >/dev/null 2>&1; then \
		cd test && go test -v -timeout 30m; \
	else \
		echo "Go not found. Install Go to run tests."; \
		exit 1; \
	fi

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup
	rm -rf .terraform.tfstate.lock.info

# Check prerequisites
check-prereqs:
	@echo "Checking prerequisites..."
	@if ! command -v terraform >/dev/null 2>&1; then \
		echo "Terraform not found. Please install Terraform."; \
		exit 1; \
	fi
	@echo "Prerequisites check passed."

# Install development tools
install-tools:
	@echo "Installing development tools..."
	@if command -v go >/dev/null 2>&1; then \
		go install github.com/terraform-linters/tflint/cmd/tflint@latest; \
		go install github.com/gruntwork-io/terratest/modules/terraform-aws-tester@latest; \
	else \
		echo "Go not found. Please install Go to install development tools."; \
		exit 1; \
	fi

# Pre-commit checks
pre-commit: fmt validate lint
	@echo "Pre-commit checks completed successfully."

# Documentation
docs:
	@echo "Generating documentation..."
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown . > README.md.tmp && mv README.md.tmp README.md; \
	else \
		echo "terraform-docs not found. Install with: go install github.com/terraform-docs/terraform-docs/cmd/terraform-docs@latest"; \
	fi 