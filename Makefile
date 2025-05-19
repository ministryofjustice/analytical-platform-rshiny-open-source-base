.PHONY: build scan test run

IMAGE_NAME ?= ghcr.io/ministryofjustice/analytical-platform-cloud-development-environment-base
IMAGE_TAG  ?= local

TRIVY_DB_REPOSITORY ?= public.ecr.aws/aquasecurity/trivy-db:2
TRIVY_JAVA_DB_REPOSITORY ?= public.ecr.aws/aquasecurity/trivy-java-db:1

run: build
	docker run --rm -it $(IMAGE_NAME):$(IMAGE_TAG)

test: build
	container-structure-test test --platform linux/amd64 --config test/container-structure-test.yml --image $(IMAGE_NAME):$(IMAGE_TAG)

scan: build
	trivy image --platform linux/amd64 --severity HIGH,CRITICAL $(IMAGE_NAME):$(IMAGE_TAG)

build:
	@ARCH=`uname --machine`; \
	case $$ARCH in \
	aarch64 | arm64) \
		echo "Building on $$ARCH architecture"; \
		docker build --platform linux/amd64 --file Dockerfile --tag $(IMAGE_NAME):$(IMAGE_TAG) . ;; \
	*) \
		echo "Building on $$ARCH architecture"; \
		docker build --file Dockerfile --tag $(IMAGE_NAME):$(IMAGE_TAG) . ;; \
	esac
