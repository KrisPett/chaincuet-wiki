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

### Binary Classification

Binary classification is a supervised learning task in machine learning where the goal is to classify input data into
one of two distinct classes or categories. The two classes are often referred to as the positive class and the negative
class. **It does not include scenarios with more than two classes.**

- Spam Email Classification: Predict whether it is spam (positive class) or not spam (negative class).
- Fraud Detection: Classify whether the transaction is fraudulent (positive class) or legitimate (negative class).
- Disease Diagnosis: Determine whether the patient has a specific disease or is healthy (positive/negative class).
- Sentiment Analysis: Classify whether the sentiment is positive (positive class) or negative (negative class).

### Multiclass Classification

In multiclass classification, the input data and associated labels are used to train a model that can make predictions
for all the different classes. The model learns to distinguish between multiple classes and assign the most appropriate
label to new, unseen instances.

### Convolutional Neural Network (CNN)

It is a type of deep neural network architecture that is particularly well-suited for tasks such as image
classification, object detection, and image segmentation. Their ability to learn spatial hierarchies and capture local
patterns makes them effective in understanding and interpreting visual data.

## API

#### Layers

##### Sequential

```
  model = tf.keras.Sequential([])
```

Build a neural network model by stacking layers sequentially

###### Dense

- **tf.keras.layers.Dense(units=64, activation='relu', input_shape=(784,))**
- In a neural network, a dense layer is a type of layer where each neuron in the layer is connected to every
  neuron in the previous layer. This means that each neuron in a dense layer receives inputs from all the neurons in the
  previous layer.
- By stacking multiple dense layers together, you can create deep neural network architectures capable of learning
  hierarchical representations of the input data. The choice of activation function depends on the problem at hand,
  and different activation functions have different properties and are suited for different tasks.
- **units** specifies the number of neurons in the dense layer, Each neuron in the layer receives input from all the
  neurons
  in the previous layer and produces a single output.
- **activation** functions introduce non-linearity into the network, enabling it to learn complex patterns

###### Rescaling

- **tf.keras.layers.Rescaling(scale=255)**
- The tf.keras.layers.Rescaling layer with scale=255 is used to rescale the input data by dividing it by 255.
- In the context of image data, pixel values are often represented as integers in the range [0, 255], where 0 represents
  black and 255 represents white (for grayscale images). By applying the Rescaling layer with scale=255, each pixel
  value
  in the input data will be divided by 255, resulting in rescaled pixel values in the range [0, 1]. This rescaling is
  commonly performed to normalize the pixel values to a range that is more suitable for the model's learning process.
- **E.g.** if a pixel value in the input data is 127, after applying the Rescaling layer, it will be rescaled to
  127/255 =
  0.498.

###### TimeDistributed

- **tf.keras.layers.TimeDistributed(net)**
- TimeDistributed is a wrapper layer in TensorFlow's Keras API that applies a layer to every temporal slice of an input
  tensor independently. It is useful when working with sequential or time-series data, where the input data has a
  temporal dimension.
- If working with video data, where each video is a sequence of frames, the TimeDistributed layer can be used to process
  the video frames at each time step. This allows the model to learn and capture temporal dependencies and patterns
  present in the video sequence.

###### GlobalAveragePooling3D

- **tf.keras.layers.GlobalAveragePooling3D()**
- Global average pooling is a technique used to summarize the spatial and temporal information present in a 3D tensor,
  such as video data.
- When applied in the context of video classification or 3D object recognition, global average pooling helps to capture
  the most important features in a concise manner. the model can effectively summarize the spatial and temporal
  information across the 3D tensor, capturing the most important features in a concise manner. This can be beneficial
  for tasks such as video classification or 3D object recognition.

##### activation

###### relu

- **tf.keras.activations.relu()**
- Rectified Linear Unit (ReLU)
- It returns the input value if it is positive or zero, and it returns zero for any negative input value.
- ```relu(x) = max(0, x)``` **e.g.** ```relu(20) = 20``` **or** ```relu(-20) = 0```
- By applying ReLU activation, neural networks can learn complex non-linear mappings and capture intricate patterns in
  the data, enabling them to solve a wide range of machine learning tasks, including image classification, object
  detection, and natural language processing.

###### sigmoid

- **tf.keras.activations.sigmoid**
- The sigmoid function squashes the input value to a range between 0 and 1.
- ```sigmoid(x) = 1 / (1 + exp(-x))```

#### Compile

```
model.compile(optimizer=, loss=, metrics= )
```

##### Optimizer

###### Adam

- adam

##### Loss

###### SparseCategoricalCrossentropy

##### Metrics

###### accuracy