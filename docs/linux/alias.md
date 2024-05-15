#### Alias

##### timer

Normal
```
alias timer='function timer() { for i in $(seq $1 -1 1); do echo $i; sleep 1; done; echo "Timer expired!"; }; timer'
```

```
alias timer='seconds() { for ((i=$1; i>=0; i--)); do echo -ne "Time remaining: $i\033[0K\r"; sleep 1; done; echo -e "\nTime'\''s up!"; }; seconds'
```
Slower
```
alias timer='seconds() { for ((i=$1; i>0; i--)); do echo -ne "Time remaining: $i\033[0K\r"; sleep 2; done; echo -e "\nTimer expired!"; }; seconds'
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