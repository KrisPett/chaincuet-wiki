#### Alias

```
alias timer='function timer() { for i in $(seq $1 -1 1); do echo $i; sleep 1; done; echo "Timer expired!"; }; timer'
```

#### Kubectl
```
alias k='kubectl'
alias ka='kubectl get all'
alias kd='kubectl describe'
alias kf='kubectl port-forward'
alias ks='kubectl get services'
```

#### Docker
```
alias d='docker'
alias dall='docker kill $(docker ps -q)'
alias dpi='docker images'
alias dps='docker ps -a'
```