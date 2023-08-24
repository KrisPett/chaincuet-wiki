### Git Setup

#### Git New Repository

```
git init --initial-branch=main
git remote add origin git@github.com:KQT3/<..>.git
git add .
git commit -m "Initial commit"
git push -u origin main
```

#### Git Commit and Push

```
git add . && git commit -m "Initial commit" && git push -u origin master
git add . && git commit -m "Initial commit" && git push -u origin main
```

#### Remove a directory from git

```
git rm -rf .idea/
```

#### Install latest version of git

```
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git
git --version
```

#### Setup Stuff

```
git config --global push.autoSetupRemote true
git config --global push.default upstream
```

#### Uncommit changes when accident commit

**Go to correct directory**

```
git reset --soft HEAD^
git reset --soft HEAD~1
```

#### Clone a folder from github using svn

**Example**

```
sudo apt install subversion
svn ls https://github.com/marcel-dempers/docker-development-youtube-series/
svn export https://github.com/marcel-dempers/docker-development-youtube-series/trunk/hashicorp/vault-2022/
```

### Github

#### Github Settings

```

```

### Gitlab

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
