
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

### Install example-voting-app
Now we can install the example-voting-app components:
```
helm install --name postgres charts/example-voting-app/charts/postgres
helm install --name redis charts/example-voting-app/charts/redis
helm install --name worker charts/example-voting-app/charts/worker
helm install --name voting-app charts/example-voting-app/charts/voting-app --set nodePort=30050
helm install --name result-app charts/example-voting-app/charts/result-app --set nodePort=30051
```
Did everything went well? Check with `helm ls` and `minikube service list`.
Now you should be able to access the app at ports 30050 and 30051!

### Install gitlab
Let's install gitlab but let's check the values in `charts/gitlab/values.yaml` first
```
helm install --namespace=infra -n gitlab charts/gitlab
```
After a while you can access gitlab at `http://$(minikube ip):30080`. Default user/pass is root/passw0rd.

Got to `http://$(minikube ip):30080/admin/runners` and copy the registration token. Then register the gitlab-runner manually, because that's just the way it is for now:
```
kubectl run --namespace=infra -i -t gitlab-runner --image=gitlab/gitlab-runner:alpine-v1.7.1 --restart=Never --command bash
bash-4.3# gitlab-runner register -n --executor kubernetes -u http://gitlab/ -r C5HaFvoVkqJULxaskWu8
bash-4.3# grep token /etc/gitlab-runner/config.toml
  token = "33231c882cf2545e3124a823dee982"
```
See also notes at [1]

Paste the token in `charts/gitlab-runner/values.yaml` and install the (long-running) gitlab-runner:
```
helm install --namespace=infra -n gitlab-runner charts/gitlab-runner
```
The runner should now be active at `http://$(minikube ip):30080/admin/runners`

Now we can create a project in the webinterface and push this repo!
```
git remote add local http://$(minikube ip):30080/root/taw16.git
git push -u local master
```

## Notes
[1] A better way would be to run `kubectl run --namespace=infra gitlab-runner --image=gitlab/gitlab-runner:alpine-v1.7.1 --restart=Never -- register -n --executor kubernetes -u http://gitlab/ -r C5HaFvoVkqJULxaskWu8` but unfortunately that doesn't print the runtime token we need, you have to go to the gitlab webinterface to get it

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

## provision uat
```
helm install --namespace=uat --name postgres-uat charts/example-voting-app/charts/postgres
helm install --namespace=uat --name redis-uat charts/example-voting-app/charts/redis
helm install --namespace=uat --name worker-uat charts/example-voting-app/charts/worker
helm install --namespace=uat --name voting-app-uat charts/example-voting-app/charts/voting-app --set nodePort=30060
helm install --namespace=uat --name result-app-uat charts/example-voting-app/charts/result-app --set nodePort=30061
```
