### Kubectl Commands

#### Create and run a config file

```
kubectl apply -f <>
```

#### List all resources

- Need to specify namespaces

```
kubectl get all
kubectl get all -A
kubectl get pods -n ingress-nginx
```

```
kubectl port-forward
```

#### Information about service

```
kubectl describe
```

#### Port Forward

```
kubectl port-forward <service> <port>
```

#### Scale

```
kubectl scale <deployment.apps/> --replicas=2
```

#### Create Secret

```
kubectl get secrets
kubectl delete secret gitlab-registry

kubectl create secret docker-registry gitlab-registry \
--docker-server=registry.gitlab.com \
--docker-username=<> \
--docker-password=<>
```

#### Delete all

```
kubectl delete all --all
```

#### Create a database inside k8s-postgres

```
kubectl exec -it postgres-backend-0 -- psql -U admin -d postgres -c "CREATE DATABASE \"backend-pqsl-db\";"

kubectl exec -it postgres-backend-0 -- /bin/bash
psql -U admin postgres
```

#### Check resources

```
kubectl get pods --all-namespaces | grep metrics-server
kubectl top pod
kubectl top node
microk8s kubectl top pod <pod_name>
```

#### Restart Pod

```
kubectl delete pod my-pod
kubectl rollout restart deployment my-deployment
```

### Helm

#### Setup

```
sudo snap install helm --classic
```

#### Add repo

```
helm repo add gitlab https://charts.gitlab.io
```

#### List repo

```
helm repo list
```

#### Search repo

```
helm search repo gitlab
```

#### Install a helm chart

```
helm install --namespace gitlab-runner gitlab-runner -f values.yaml gitlab/gitlab-runner
helm install
```

#### Uninstall helm

```
helm uninstall -n gitlab-runner gitlab-runner
```

### Minikube

#### Setup

```
minikube start
```

#### Kubernetes dashboard

```
minikube addons list
minikube enable dashboard
minikube dashboard
```

#### Minicube Ip

**E.g http://192.192.00.00:30000/**

```
minikube ip
```

#### Ingress Controller

```
minikube addons enable ingress
```

#### Ingress

- When tesing ingress locally

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout backend.minikube.key -out backend.minikube.crt -subj "/CN=backend.minikube/O=backend"
kubectl create secret tls backend-tls-secret --key backend.minikube.key --cert backend.minikube.crt
echo "$(minikube ip) backend.minikube" | sudo tee -a /etc/hosts
```

#### Metrics

```
minikube addons enable metrics-server
```

#### Remove minikube

```
minikube delete
rm -rf ~/.minikube
```
