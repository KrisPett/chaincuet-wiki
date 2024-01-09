### Update version (NEW_VERSION=0.0.0) alternative solution

```
docker run -it --rm -e NEW_VERSION=1.163.0 -v ${PWD}:/workdir -w /workdir --network host node:18-alpine sh -c '\
sed -i "s/\"version\": \"[0-9]*\\.[0-9]*\\.[0-9]*\"/\"version\": \"$NEW_VERSION\"/g" package.json && \
npm run build'
```

```
npm login
```

```
npm publish
```

### gitlab-ci push to registry

```
stages:
  - deploy

publish-npm:
  stage: deploy
  tags:
    - shared-runner
  image: node:21.5.0
  services:
    - docker:24.0.5-dind
  variables:
    DOCKER_HOST: tcp://docker:2376
    DOCKER_TLS_CERTDIR: "/certs"
    DOCKER_TLS_VERIFY: 1
    DOCKER_CERT_PATH: "$DOCKER_TLS_CERTDIR/client"

  script:
    - echo "@sensera:registry=https://${CI_SERVER_HOST}/api/v4/projects/${CI_PROJECT_ID}/packages/npm/" > .npmrc
    - echo "//${CI_SERVER_HOST}/api/v4/projects/${CI_PROJECT_ID}/packages/npm/:_authToken=${CI_JOB_TOKEN}" >> .npmrc
    - npm version patch --no-git-tag-version
    - npm publish --registry=https://${CI_SERVER_HOST}/api/v4/projects/${CI_PROJECT_ID}/packages/npm/
```

### install from registry

- touch .npmrc
- gitlab_user_token = read_api permission

```
@example:registry=https://gitlab.com/api/v4/projects/<project_id>/packages/npm/
//gitlab.com/api/v4/projects/<project_id>/packages/npm/:_authToken=<gitlab_user_token>
```
