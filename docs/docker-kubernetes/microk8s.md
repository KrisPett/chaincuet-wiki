#### Kubernetes Dashboard

```
microk8s enable dashboard
```

```
microk8s kubectl create token default
```

```
microk8s kubectl port-forward --address 0.0.0.0 -n kube-system service/kubernetes-dashboard 10443:443
```

- https://000.000.000.000:10443

#### Create ymls

```
microk8s kubectl apply -f ...
```

#### List all

```
microk8s kubectl get all
```

### Gitlab-authentication in k8s

```
microk8s kubectl create secret docker-registry gitlab-registry \
  --docker-server=registry.gitlab.com \
  --docker-username=your-username \
  --docker-password=your-token
```


