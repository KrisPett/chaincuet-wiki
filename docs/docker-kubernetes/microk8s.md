#### Kubernetes Dashboard

- microk8s enable dashboard
- microk8s kubectl create token default

```
microk8s kubectl port-forward --address 0.0.0.0 -n kube-system service/kubernetes-dashboard 10443:443
```

- https://000.000.000.000:10443
