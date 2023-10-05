https://wiki.chaincuet.com/

#### Setup

```
pip install mkdocs-material
mkdocs serve
```

#### Development

```
Create new .md file in docs folder
Edit mkdocs.yml
```

#### Build

```
mkdocs build
```

#### specify IP address and port

```
docker run --rm -it -p 9000:9000 -v ${PWD}:/workdir -w /workdir python:3.12 bash -c "\
pip install mkdocs-material && \
mkdocs serve --dev-addr=0.0.0.0:9000"
```

