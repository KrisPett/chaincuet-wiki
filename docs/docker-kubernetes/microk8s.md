#### Install

- sudo snap install microk8s --classic
- alias kubectl='microk8s kubectl'
- sudo usermod -a -G microk8s ubuntu
- sudo chown -R ubuntu ~/.kube (mkdir .kube)
- newgrp microk8s

#### List addons

```
microk8s status
addons:
  enabled:
    dashboard
    dns
    ha-cluster
    helm
    helm3
    host-access
    hostpath-storage
    ingress
    metrics-server
    storage
```

#### Kubernetes Dashboard

```
microk8s enable dashboard
```

```
microk8s kubectl create token default
```

(Enable access from 10443)

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

#### Setup k9s

```
microk8s.kubectl config view --raw > ~/.kube/config
```


