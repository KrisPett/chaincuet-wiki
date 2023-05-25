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
docker run -it --rm --name tensorflow --network host -p 1337:1337 -u $(id -u):$(id -g) -v ${PWD}:/workdir \
-w /workdir tensorflow/tensorflow:latest-gpu bash
```

## Key Concepts

### Neural Network

Is a set of algorithms that are designed to recognize patterns. It is inspired by the human brain. It is composed of a large number of highly interconnected processing elements (neurons) working in unison to solve specific problems.
It is a form of machine learning algorithm that is designed to recognize patterns and learn from data. 

### MNIST

MNIST (Modified National Institute of Standards and Technology) is a popular dataset commonly used for training and evaluating machine learning models, particularly for image classification tasks. 

### Keras

Keras is a high-level neural networks API, written in Python and capable of running on top of TensorFlow. It is designed to enable fast experimentation with deep neural networks.