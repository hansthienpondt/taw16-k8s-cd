FROM alpine:3.4

# ADD https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/linux/amd64/kubectl /usr/bin/kubectl
ADD bin/kubectl-1.4.5 /usr/bin/kubectl
RUN chmod a+x /usr/bin/kubectl

RUN apk update && \
apk add --no-cache bash git


ENTRYPOINT ["/usr/bin/kubectl"]
