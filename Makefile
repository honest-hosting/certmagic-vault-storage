SHELL := /bin/bash

default: help
.PHONY: default

help: ## Display this help screen (default)
	@grep -h "##" $(MAKEFILE_LIST) | grep -vE '^#|grep' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort
.PHONY: help

lint: ## Run linter against codebase
	@golangci-lint -v run
.PHONY: lint

fmt: ## Run go-fmt against codebase
	@go fmt ./...
.PHONY: fmt

mod-download: ## Download go modules
	@go mod download
.PHONY: mod-download

mod-tidy: ## Make sure go modules are tidy
	@go mod tidy
.PHONY: mod-tidy

mod-update:
	@if [[ -n "${MODULE}" ]] && [[ -n "${MODULE_VERSION}" ]]; then          \
		echo "Running 'go list -m ${MODULE}@${MODULE_VERSION}' ...";        \
		GOPROXY=proxy.golang.org go list -m "${MODULE}@${MODULE_VERSION}";  \
	else                                                                    \
		echo "ERROR: Missing 'MODULE'/'MODULE_VERSION', cannot continue";   \
		exit 1;                                                             \
	fi
.PHONY: mod-update

release: export MODULE         ?= github.com/honest-hosting/certmagic-vault-storage
release: export MODULE_VERSION ?=
release: mod-update ## Run release step(s) for module version: MODULE_VERSION=v0.1.1 make release
.PHONY: release
