### Minikube

```
minikube start
```

### Kubectl Commands

#### Create and run a config file

```
kubectl apply -f <>
```

#### List all Srevices

```
kubectl get all
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
create secret docker-registry gitlab-registry \
--docker-server=registry.gitlab.com \
--docker-username=<> \
--docker-password=<>
```

#### Delete all

```
kubectl delete all --all
```

####  Create a database inside k8s-postgres

```
kubectl exec -it postgres-backend-0 -- psql -U admin -d postgres -c "CREATE DATABASE \"backend-pqsl-db\";"

kubectl exec -it postgres-backend-0 -- /bin/bash
psql -U admin postgres
```
