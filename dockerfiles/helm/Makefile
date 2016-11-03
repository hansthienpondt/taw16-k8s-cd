.PHONY: build push

TAG=2.0.0-rc.1

build:
	docker build -t willies/helm:latest .
	docker tag willies/helm:latest willies/helm:$(TAG)

push: build
	docker push willies/helm:latest
	docker push willies/helm:$(TAG)
