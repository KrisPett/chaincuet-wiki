#### Gitlab login 

```
docker login registry.gitlab.com
docker login registry.gitlab.com -u <gitlab_user> -p <gitlab_token>
```

#### Search Repo

```
https://gitlab.com/projects/{project_id}
```

#### Private Repo

- Settings -> General -> Visibility -> Allow anyone to pull from Package Registry

#### Pipeline Gitlab Docker Push

```
image: docker:latest

stages:
  - maven_test_and_build
  - docker_build_and_push
  - docker_deploy

maven_test_and_build:
  image: maven:3-openjdk-17
  stage: maven_test_and_build
  script: "mvn package deploy -B -s ci_settings.xml"
  artifacts:
    paths:
      - target/*.jar

docker_build_and_push:
  stage: docker_build_and_push
  services:
    - docker:dind
  before_script:
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
  script:
    - docker build --pull -t "$CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG" .
    - docker push "$CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG"
```

**If repo is private you might have to provide distributionManagement**

```
<distributionManagement>
    <repository>
        <id>gitlab-repo</id>
        <!--suppress UnresolvedMavenProperty -->
        <url>${CI_API_V4_URL}/projects/${env.CI_PROJECT_ID}/packages/maven</url>
    </repository>
    <snapshotRepository>
        <id>gitlab-repo</id>
        <!--suppress UnresolvedMavenProperty -->
        <url>${CI_API_V4_URL}/projects/${env.CI_PROJECT_ID}/packages/maven</url>
    </snapshotRepository>
</distributionManagement>
```

#### Gitlab Runner using docker

- docker pull gitlab/gitlab-runner:latest
- docker run -it --name gitlab-runner --rm gitlab/gitlab-runner:latest bash
- sudo docker exec -it gitlab-runner bash
- gitlab-runner register

```
Enter the GitLab instance URL (for example, https://gitlab.com/):
https://gitlab.com/
Enter the registration token:
<TOKEN>
Enter a description for the runner:
[]: test-runner 
Enter tags for the runner (comma-separated):
java
Enter optional maintenance note for the runner:

Enter an executor: custom, docker, shell, docker-autoscaler, docker+machine, kubernetes, docker-windows, parallels, ssh, virtualbox, instance:
docker
Enter the default Docker image (for example, ruby:2.7):
docker:dind
```

- gitlab-runner verify

#### Gitlab Runner using Kubernetes

- helm repo add gitlab https://charts.gitlab.io
- Get config file [values.yaml](https://gitlab.com/gitlab-org/charts/gitlab-runner/blob/main/values.yaml)
- Edit

```
  gitlabUrl: https://gitlab.com/
  runnerRegistrationToken: "GR1348941Eah-zgTLb7xBT33r1K9P"
rbac:
  create: true
  rules: []
   - resources: ["configmaps", "events", "pods", "pods/attach", "pods/exec", "secrets", "services"]
     verbs: ["get", "list", "watch", "create", "patch", "update", "delete"]
   - apiGroups: [""]
     resources: ["pods/exec"]
     verbs: ["create", "patch", "delete"]
     
# If docker in docker docker:dind
runners:
  config: |
    [[runners]]
      [runners.kubernetes]
        namespace = "{{.Release.Namespace}}"
        image = "ubuntu:22.04"
        privileged = true
      [[runners.kubernetes.volumes.empty_dir]]
        name = "docker-certs"
        mount_path = "/certs/client"
        medium = "Memory"

stages:
  - maven_test_and_build
  - docker_build_and_push

maven_test_and_build:
  stage: maven_test_and_build
  image: maven:3.8.5-openjdk-17
  script: "mvn package deploy -B -s ci_settings.xml"
  artifacts:
    paths:
      - target/*.jar

docker_build_and_push:
  stage: docker_build_and_push
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  variables:
    DOCKER_HOST: tcp://docker:2376
    DOCKER_TLS_CERTDIR: "/certs"
    DOCKER_TLS_VERIFY: 1
    DOCKER_CERT_PATH: "$DOCKER_TLS_CERTDIR/client"

  before_script:
    - docker info
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
  script:
    - docker build --pull -t "$CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG" .
    - docker push "$CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG"
```

- kubectl create namespace gitlab-runner
- helm install --namespace gitlab-runner gitlab-runner -f values.yaml gitlab/gitlab-runner
- helm upgrade gitlab-runner -n gitlab-runner -f values.yaml gitlab/gitlab-runner
- helm uninstall -n gitlab-runner gitlab-runner

#### Gitlab shared runners

- Go to project root -> Build -> Runners -> New group runner -> add tag shared-runner

```
deploy:
  stage: stage
  tags:
    - shared-runner
```

# Self host

## Docker

```
# sudo mkdir -p /srv/gitlab
# export GITLAB_HOME=/srv/gitlab
# export | grep GITLAB_HOME

# docker compose up

# docker exec -it gitlab bash -c "cat /etc/gitlab/initial_root_password"
# http://localhost:8082/dashboard/projects

version: '3.6'
services:
  gitlab:
    image: gitlab/gitlab-ce:16.7.6-ce.0
    container_name: gitlab
    hostname: 'gitlab.chaincuet.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://gitlab.chaincuet.com'
    ports:
      - '8082:80'
      - '4443:443'
      - '222:22'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    shm_size: '256m'
```

- http://localhost:8082/admin
- docker exec -it gitlab bash
- username = root, password = cat /etc/gitlab/initial_root_password
- Users -> Pending approval

### Create new root password

- docker exec -it gitlab gitlab-rake "gitlab:password:reset[root]"

## Kubernetes

```
# kubectl -f gitlab.yml apply
# kubectl exec -it deployment.apps/gitlab -n gitlab -- cat /etc/gitlab/initial_root_password

# kubectl delete namespace gitlab -n gitlab

apiVersion: v1
kind: Namespace
metadata:
  name: gitlab

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gitlab-config
  namespace: gitlab
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gitlab-logs
  namespace: gitlab
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gitlab-data
  namespace: gitlab
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gitlab
  namespace: gitlab
spec:
  replicas: 1 # this deploy only works with 1 replicas
  selector:
    matchLabels:
      app: gitlab
  template:
    metadata:
      labels:
        app: gitlab
    spec:
      containers:
        - name: gitlab
          image: gitlab/gitlab-ce:16.7.6-ce.0
          ports:
            - containerPort: 80
            - containerPort: 443
            - containerPort: 22
          volumeMounts:
            - name: gitlab-config
              mountPath: /etc/gitlab
            - name: gitlab-logs
              mountPath: /var/log/gitlab
            - name: gitlab-data
              mountPath: /var/opt/gitlab
          env:
            - name: GITLAB_OMNIBUS_CONFIG
              value: |
                external_url 'http://gitlab.chaincue.com'
      volumes:
        - name: gitlab-config
          persistentVolumeClaim:
            claimName: gitlab-config
        - name: gitlab-logs
          persistentVolumeClaim:
            claimName: gitlab-logs
        - name: gitlab-data
          persistentVolumeClaim:
            claimName: gitlab-data
---
apiVersion: v1
kind: Service
metadata:
  name: gitlab
  namespace: gitlab
spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      targetPort: 80
      nodePort: 30080
    - name: https
      port: 443
      targetPort: 443
      nodePort: 30443
    - name: ssh
      port: 22
      targetPort: 22
      nodePort: 30222
  selector:
    app: gitlab
```

- minikube addons enable ingress
- minikube ip -> sudo nano /etc/hosts -> "minikube_ip" gitlab.chaincue.com

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: gitlab-ingress
  namespace: gitlab
spec:
  rules:
    - host: gitlab.chaincue.com
      http:
        paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: gitlab
                port:
                  number: 80
```
