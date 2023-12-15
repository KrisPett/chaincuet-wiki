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

#### Rollback to a specif commit

```
git checkout -b reintegrate-deny-approve origin/main
git cherry-pick b7f7513c57bf416bd674040680480584d054530b
Handle merge conflicts manually
```


#### Clone a folder from github using svn

**Example**

```
sudo apt install subversion
svn ls https://github.com/marcel-dempers/docker-development-youtube-series/
svn export https://github.com/marcel-dempers/docker-development-youtube-series/trunk/hashicorp/vault-2022/
```
