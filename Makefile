FLAVOR ?= dev
DEVICE ?=
DEVICE_ARG := $(if $(DEVICE),-d $(DEVICE),)
DEFINES = --dart-define-from-file=config/$(FLAVOR).json

.PHONY: help setup hooks platforms format lint analyze test cov check \
	run build-apk build-aab build-ipa integration clean doctor outdated

help:
	@grep -E '^[a-z-]+:.*?## .*$$' $(MAKEFILE_LIST) | sed 's/:.*## /\t/'

setup: hooks ## Install dependencies and git hooks
	flutter pub get

hooks: ## Point git at the versioned hooks in .githooks/
	./scripts/install-hooks.sh

platforms: ## Generate android/ and ios/ project folders (first run only)
	./scripts/ensure-platforms.sh

format: ## Format all Dart sources
	dart format .

lint: ## Verify formatting without writing
	dart format --output=none --set-exit-if-changed .

analyze: ## Static analysis, infos are failures
	flutter analyze --fatal-infos

test: ## Unit and widget tests
	flutter test

cov: ## Tests with coverage report at coverage/lcov.info
	flutter test --coverage

check: lint analyze test ## Run before finishing any task

integration: ## On-device integration tests
	flutter test integration_test $(DEVICE_ARG) $(DEFINES)

run: ## FLAVOR=dev|staging|prod make run
	flutter run --flavor $(FLAVOR) $(DEFINES) $(DEVICE_ARG)

build-apk:
	flutter build apk --release --flavor $(FLAVOR) $(DEFINES)

build-aab:
	flutter build appbundle --release --flavor $(FLAVOR) $(DEFINES)

build-ipa:
	flutter build ipa --release --flavor $(FLAVOR) $(DEFINES)

doctor:
	flutter doctor -v

outdated:
	flutter pub outdated

clean:
	flutter clean && flutter pub get
