# Tensorflow

Tensorflow is a framework for deep learning. It is developed by Google and is open source. It is used for both research
and production at Google.

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

Is a set of algorithms that are designed to recognize patterns. It is inspired by the human brain. It is composed of a
large number of highly interconnected processing elements (neurons) working in unison to solve specific problems.
It is a form of machine learning algorithm that is designed to recognize patterns and learn from data.

In a neural network, the neurons are typically organized into layers, with each layer receiving input from the previous
layer and producing output for the next layer. The first layer is usually the input layer, which receives the input
data, and the last layer is the output layer, which produces the final result. In between the input and output layers,
there can be one or more hidden layers, each consisting of multiple neurons

```jsx
model = keras.Sequential([
    keras.layers.Flatten(input_shape = (28, 28)),
    keras.layers.Dense(128, activation = 'relu'),
    keras.layers.Dense(10, activation = 'softmax')
])
```

**The first Dense layer has 128 neurons, and the second Dense layer has 10 neurons. The number
of neurons in each layer can be specified as an argument to the Dense layer constructor.**

The first Dense layer has 128 neurons, and the input shape is automatically inferred from the output shape of the
previous layer (which is the output of the Flatten layer).
The second Dense layer has 10 neurons, which corresponds to the number of classes that the model can classify.
Note that the number of neurons in each layer can be adjusted based on the problem you are trying to solve and the
complexity of the input data.

**Hidden Neuron**

The hidden layer is the Dense layer with 128 neurons and the relu activation function:

The first Dense layer with 128 neurons is the hidden layer because it is located between the input layer (the Flatten
layer) and the output layer (the Dense layer with 10 neurons). The relu activation function is applied to the output of
the hidden layer.

### Tensor

Tensor is a multi-dimensional array of values that can represent complex data structures. Tensors
can be used to encode multi-dimensional data, such as images, which typically have three dimensions (width, height, and
color depth). Tensors can range from zero-dimensional (scalars) to one-dimensional (vectors),
two-dimensional (matrices), and higher-dimensional structures.

```jsx
tensor_3_d = tf.constant([[[1, 2], [3, 4]], [[5, 6], [7, 8]]], dtype=tf.float32)

one_d_list = [1, 2, 3, 4, 5]
two_d_list = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
three_d_list = [[[1, 2, 3], [4, 5, 6], [7, 8, 9]],[[10, 11, 12], [13, 14, 15], [16, 17, 18]]]
```

### MNIST

MNIST (Modified National Institute of Standards and Technology) is a popular dataset commonly used for training and
evaluating machine learning models, particularly for image classification tasks.

### Keras

Keras is a high-level neural networks API, written in Python and capable of running on top of TensorFlow. It is designed
to enable fast experimentation with deep neural networks.

### TensorFlow Hub

TensorFlow Hub is a library and platform within TensorFlow, an open-source machine learning framework. It provides a
repository of pre-trained machine learning models, called modules, that can be reused and incorporated into new
projects. 
