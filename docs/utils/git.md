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

```
git reset --soft HEAD^
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

#### Private Repo

- Settings -> General -> Visibility -> Allow anyone to pull from Package Registry

