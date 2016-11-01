.PHONY: build push

TAG=1

build:
	docker build -t willies/helm:latest .
	docker tag willies/helm:latest willies/helm:2.0.0-beta.2-$(TAG)

push: build
	docker push willies/helm:latest
	docker push willies/helm:2.0.0-beta.2-$(TAG)
