# Tensorflow

Tensorflow is a framework for deep learning. It is developed by Google and is open source. It is used for both research and production at Google.

## Installation

```bash
nvcc --version
sudo apt install nvidia-cuda-toolkit
pip install tensorflow
```

## Docker

```
docker run -it --rm -p 1337:1337 --name tensorflow --network host -v ${PWD}:/workdir -w /workdir tensorflow/tensorflow:latest-gpu bash
```
