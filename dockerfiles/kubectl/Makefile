.PHONY: build push

TAG=4

build:
	docker build -t willies/kubectl:latest .
	docker tag willies/kubectl:latest willies/kubectl:1.4.5-$(TAG)

push: build
	docker push willies/kubectl:latest
	docker push willies/kubectl:1.4.5-$(TAG)
