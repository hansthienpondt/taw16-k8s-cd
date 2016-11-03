.PHONY: build push

TAG=1.4.5-5

build:
	docker build -t willies/kubectl:latest .
	docker tag willies/kubectl:latest willies/kubectl:$(TAG)

push: build
	docker push willies/kubectl:latest
	docker push willies/kubectl:$(TAG)
