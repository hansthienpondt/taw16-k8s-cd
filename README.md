minikube start --memory=4096 --vm-driver=xhyve

helm init

helm install --namespace=infra -n gitlab gitlab

/usr/local/bin/gitlab-ci-multi-runner register -n --executor kubernetes -u http://192.168.64.4:30081/ -r C5HaFvoVkqJULxaskWu8
cat ~/.gitlab-runner/config.toml
# put token in gitlab-runner ConfigMap

git remote add local http://gitlab.default.svc.cluster.local:30080/root/taw16.git
git push -u local master

helm install --name postgres postgres
helm install --name redis redis
helm install --name worker worker
helm install --name result-app result-app
helm install --name voting-app voting-app

kubectl delete pod -l app=result-app

## build gitlab-runner
```
make build BUILD_PLATFORMS="-os=linux -arch=amd64"
```
or full
```
docker run --rm -it -v $(pwd)/:/go/src/gitlab.com/gitlab-org/gitlab-ci-multi-runner -w /go/src/gitlab.com/gitlab-org/gitlab-ci-multi-runner golang:1.7.1 make build_simple
cp out/binaries/gitlab-ci-multi-runner dockerfiles/alpine/gitlab-ci-multi-runner-linux-amd64
cd dockerfiles/alpine/
docker build -t willies/gitlab-runner:1.7.1_kube.3 .
docker push willies/gitlab-runner:1.7.1_kube.3
cd -
```

## build kubectl
```
docker build -t willies/kubectl:1.4.5-2 .
docker push willies/kubectl:1.4.5-2
```
