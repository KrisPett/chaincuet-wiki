# Node

#### Install latest version of nodejs

**Specify setup_20**

```
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

# Npm

#### Create npm library

- npm link (test project without having to build and publish)
- npm config get prefix -> /usr/lib/node_modules -> sudo npm link /usr/lib/node_modules/npm-library
- npm login
- npm publish

