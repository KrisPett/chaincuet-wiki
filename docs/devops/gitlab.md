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

## docker

```
# docker compose up
# docker exec -it gitlab bash
# cat /etc/gitlab/initial_root_password
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

## Kubernetes

```
helm install gitlab gitlab/gitlab  \
  --set global.hosts.domain=gitlab.chaincuet.com \
  --set certmanager-issuer.email=...
```

- kubectl port-forward svc/gitlab-nginx-ingress-controller 8080:80
- helm delete gitlab
