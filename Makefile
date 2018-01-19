SHELL = bash

APP := $(shell basename $(PWD) | tr '[:upper:]' '[:lower:]')
VERSION := $(shell git describe --tags 2>/dev/null || echo v0.0.1)
TRAVIS_BUILD_NUMBER ?= 1
BUILD_NUMBER ?= $(TRAVIS_BUILD_NUMBER)
BUILD_VERSION := $(VERSION)-$(BUILD_NUMBER)
GIT_COMMIT_HASH ?= $(TRAVIS_COMMIT)

DOCKER_REPO ?= dan9186
DOCKER_IMAGE_NAME ?= $(APP)
DOCKER_IMAGE_LABEL ?= latest


.PHONY: all
all: dockerize

.PHONY: ci_setup
ci_setup:  ## Setup the CI environment
	@echo "Unshallowing repo"
	#git fetch --unshallow
	#git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
	git fetch origin
	@echo "Logging into Docker Hub"
	@if [[ -z "$$DOCKER_USER" || -z "$$DOCKER_PASSWORD" ]]; then \
		echo "Docker credentials missing, cannot proceed"; \
		exit 1; \
	fi
	@docker login -u "$$DOCKER_USER" -p "$$DOCKER_PASSWORD"

.PHONY: deploy
deploy: push_image  ## Deploys the service

.PHONY: dockerize
dockerize:  ## Create a docker image of the project
	docker build \
		--build-arg VERSION=$(BUILD_VERSION) \
		--build-arg GIT_COMMIT_HASH=$(GIT_COMMIT_HASH) \
		-t $(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_LABEL) \
		.

.PHONY: push_image
push_image:  ## Push the latest docker image to the repo
	docker push $(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_LABEL)

.PHONY: help
help:  ## Show This Help
	@for line in $$(cat Makefile | grep "##" | grep -v "grep" | sed  "s/:.*##/:/g" | sed "s/\ /!/g"); do verb=$$(echo $$line | cut -d ":" -f 1); desc=$$(echo $$line | cut -d ":" -f 2 | sed "s/!/\ /g"); printf "%-30s--%s\n" "$$verb" "$$desc"; done
