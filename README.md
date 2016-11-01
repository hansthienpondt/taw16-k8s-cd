
## requirements
- minikube
- kubectl

## Get started
Start minikube

```
minikube start --memory=4096 --vm-driver=xhyve
```
After a while you should be able to visit the dashboard. Check with `minikube service list`

Initialize helm, the swiss knife of kubernetes application deployment
```
helm init
```
Helm installs `tiller` in the cluster, its server-side component. Check with `kubectl get pods --all-namespaces` and `helm version`

Now we can install gitlab but let's check the values in `charts/gitlab/values.yaml` first
```
helm install --namespace=infra -n gitlab charts/gitlab
```
I suggest adding an entry in `/etc/hosts` with the minikube ip output, e.g. `192.168.64.4  gitlab.infra.svc.cluster.local`. After a while you can access the dashboard at `$(minikube ip):30080` or `gitlab.infra.svc.cluster.local:30080`. Default user/pass is `root/passw0rd`

Got to `http://$(minikube ip):30080/admin/runners` and copy the registration token. Then register the gitlab-runner manually, because that's just the way it is for now:
```
kubectl run -i -t gitlab-runner --image=gitlab/gitlab-runner:alpine-v1.7.1 --restart=Never --command bash
bash-4.3# gitlab-runner register -n --executor kubernetes -u http://gitlab.infra.svc.cluster.local:30080/ -r C5HaFvoVkqJULxaskWu8
bash-4.3# grep token /etc/gitlab-runner/config.toml
  token = "33231c882cf2545e3124a823dee982"
```
See also notes at [1]

put the token in `charts/gitlab-runner/values.yaml` and install the (long-running) gitlab-runner:
```
helm install --namespace=infra -n gitlab-runner charts/gitlab-runner
```
The runner should now be active at

Now we can push this repo!
```
git remote add local http://gitlab.default.svc.cluster.local:30080/root/taw16.git
git push -u local master
```

```
helm install --name postgres charts/example-voting-app/charts/postgres
helm install --name redis charts/example-voting-app/charts/redis
helm install --name worker charts/example-voting-app/charts/worker
helm install --name result-app charts/example-voting-app/charts/result-app
helm install --name voting-app charts/example-voting-app/charts/voting-app
```

kubectl delete pod -l app=result-app

## Notes
[1] A better way would be to run `kubectl run gitlab-runner --image=gitlab/gitlab-runner:alpine-v1.7.1 --restart=Never -- register -n --executor kubernetes -u http://gitlab.infra.svc.cluster.local:30080/ -r C5HaFvoVkqJULxaskWu8` but unfortunately that doesn't print the runtime token we need

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
