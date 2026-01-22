NAME = servicebus_exporter
IMAGE = quay.io/agronod/ghcr.io/agronod/servicebus_exporter

.PHONY: test
test:
	go test ./... -v

.PHONY: build
build: test
	go mod vendor && docker build . -t ${IMAGE}:${TAG}

.PHONY: build-local
build-local:
	go build -o ${NAME}

.PHONY: run
run: build
	docker run -p 9580:9580 ${IMAGE}:${TAG}

.PHONY: run-local
run-local: build-local
	./${NAME}

.PHONY: push
push: build
	docker push ${IMAGE}:${TAG}

.PHONY: tag
tag:
	git tag -a ${TAG} && git push --follow-tags

.PHONY: clean
clean:
	rm -f ${NAME}
	rm -rf vendor/
