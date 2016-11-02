.PHONY: build push

TAG=6

build:
	docker build -t willies/phantomjs:latest .
	docker tag willies/phantomjs:latest willies/phantomjs:$(TAG)

push: build
	docker push willies/phantomjs:latest
	docker push willies/phantomjs:$(TAG)
