#### Install

**Might update .bashrc**

- eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
- sudo apt-get install build-essential curl file git
- /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
- echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.profile
- eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
- brew --version
- brew install derailed/k9s/k9s

**No Password**

- NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

**Create .kube/config and point it to the cluster**

touch /home/ubuntu/.kube/config

Example config

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: <...>
    server: https://127.0.0.1:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: <...>
```
