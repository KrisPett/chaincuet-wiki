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
``` 

- kubectl create namespace gitlab-runner
- helm install --namespace gitlab-runner gitlab-runner -f values.yaml gitlab/gitlab-runner
