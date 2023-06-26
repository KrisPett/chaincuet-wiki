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

### Gradients

Gradients represent the rate of change of a loss function with respect to the parameters of a model. They provide
information on how the parameters should be adjusted to minimize the loss, and optimizers utilize this information to
update the model's parameters during training.

### CrossEntropy

Cross-entropy quantifies how well a model's predictions match the true labels. By minimizing cross-entropy, the model
gets better at making accurate predictions. Cross-entropy is primarily used as a loss function in machine learning

## Models

#### BERT

BERT (Bidirectional Encoder Representations from Transformers) is a pre-trained transformer-based model for natural
language processing (NLP) tasks. It captures bidirectional context by considering both preceding and following words,
leading to a deep understanding of language semantics. BERT achieves state-of-the-art results by fine-tuning its
pre-trained representations on specific NLP tasks.

## API

#### Layers

##### Sequential

```
  model = tf.keras.Sequential([])
```

Build a neural network model by stacking layers sequentially

###### CategoryEncoding

- **tf.keras.layers.CategoryEncoding**
- CategoryEncoding class is a preprocessing layer that encodes integer features into a categorical encoding. It is
  used to represent discrete or categorical data in a format that can be fed into a machine learning model.

###### Conv2D

- **tf.keras.layers.Conv2D()**
- Conv2D layer is used to perform 2D convolution on input tensors. Convolutional layers are commonly used in computer
  vision tasks to extract relevant features from images or spatial data.

###### Concatenate

- **tf.keras.layers.Concatenate()**
- Concatenate class is used to concatenate multiple input tensors along a specified axis. It takes a list of tensors
  as input and returns a single tensor that is the concatenation of all the input tensors along the specified axis.

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

###### Dropout

- **tf.keras.layers.Dropout()**
- Dropout is a regularization technique that helps prevent overfitting in neural networks by randomly setting a fraction
  of input units (neuron) to 0 at each update during training.

###### Embedding

- **tf.keras.layers.Embedding()**
- Embedding is a layer that is used for embedding categorical or discrete input data into a continuous vector
  representation. It is commonly used in **natural language processing (NLP)** tasks, where words or tokens are
  transformed into dense, low-dimensional vectors that capture semantic relationships.

###### Flatten

- **tf.keras.layers.Flatten()**
- Flatten is a layer that reshapes the input tensor into a 1-dimensional array. It is typically used as the first layer
  in a neural network model to convert multi-dimensional input data, such as images, into a flat vector.

###### GlobalAveragePooling3D

- **tf.keras.layers.GlobalAveragePooling3D()**
- Global average pooling is a technique used to summarize the spatial and temporal information present in a 3D tensor,
  such as video data.
- When applied in the context of video classification or 3D object recognition, global average pooling helps to capture
  the most important features in a concise manner. the model can effectively summarize the spatial and temporal
  information across the 3D tensor, capturing the most important features in a concise manner. This can be beneficial
  for tasks such as video classification or 3D object recognition.

###### GlobalAveragePooling1D

- **tf.keras.layers.GlobalAveragePooling1D()**
- GlobalAveragePooling1D layer is commonly used in sequence-based models, such as text classification or sentiment
  analysis, where the length of the input sequence may vary. It provides a way to summarize the temporal information in
  a fixed-length representation by capturing the average value of each feature across all timesteps.

###### IntegerLookup

- **tf.keras.layers.IntegerLookup()**
- IntegerLookup is a preprocessing layer in TensorFlow that maps integer features to contiguous ranges. It can be used
  to convert integer inputs into integer outputs using a table-based lookup. The layer also provides options for
  handling out-of-vocabulary (OOV) tokens.

###### MaxPooling2D

- **tf.keras.layers.MaxPooling2D()**
- The MaxPooling2D() layer helps in reducing the spatial dimensions of the feature maps, which can reduce the
  computational complexity and control overfitting by promoting spatial invariance. It is commonly used after
  convolutional layers to progressively downsample the feature maps while retaining the most important features.
- MaxPooling2D layer is a key component in CNN architectures for extracting relevant features and spatial
  information while reducing the spatial dimensions of the feature maps.

###### Normalization

- **tf.keras.layers.Normalization()**
- Normalization is used to normalize the activations of the previous layer for each example in a batch independently. It
  applies a transformation that maintains the mean activation within each example close to 0 and the activation standard
  deviation close to 1.

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

###### StringLookup

- **tf.keras.layers.StringLookup**
- StringLookup class is a preprocessing layer that maps string features to integer indices. It is often used in
  natural language processing tasks to convert textual data into a numerical representation that can be fed into a
  machine learning model.

###### TimeDistributed

- **tf.keras.layers.TimeDistributed(net)**
- TimeDistributed is a wrapper layer in TensorFlow's Keras API that applies a layer to every temporal slice of an input
  tensor independently. It is useful when working with sequential or time-series data, where the input data has a
  temporal dimension.
- If working with video data, where each video is a sequence of frames, the TimeDistributed layer can be used to process
  the video frames at each time step. This allows the model to learn and capture temporal dependencies and patterns
  present in the video sequence.

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

##### Optimizers

Optimizers are classes that implement various optimization algorithms used to update the parameters of a
machine learning model during the training process. The goal of an optimizer is to minimize the loss or error of the
model by iteratively adjusting the model's parameters based on the gradients of the loss function.

###### Adam

- **tf.keras.optimizers.Adam(learning_rate=0.001)**
- **Adam** stands for **Adaptive Moment Estimation**
- It is a variant of the stochastic gradient descent (SGD) algorithm that adapts the learning rate for each parameter in
  the neural network.
- The Adam optimizer combines two main ideas: adaptive learning rates and momentum. The adaptive
  learning rate means that the algorithm automatically adjusts the learning rate for each parameter based on their past
  gradients. This allows the algorithm to converge faster and more efficiently compared to using a fixed learning rate.

##### Loss

A loss function takes both the predicted values and the true values as input and computes a scalar value that quantifies
the discrepancy between them. It helps guide the optimization process during training by evaluating the model's
performance and guiding it towards minimizing the error.

###### BinaryCrossentropy

- **tf.keras.losses.BinaryCrossentropy**
- BinaryCrossentropy is a loss function specifically designed for binary classification problems. It is commonly used
  when the task involves predicting binary outcomes, where each sample can belong to one of two classes.

###### SparseCategoricalCrossentropy

- **tf.keras.losses.SparseCategoricalCrossentropy**
- SparseCategoricalCrossentropy is a loss function commonly used for multi-class classification problems where the true
  labels are integers representing the class labels.

###### MeanSquaredError

- **tf.keras.losses.MeanSquaredError**
- MeanSquaredError is a loss function in TensorFlow's Keras API that calculates the mean squared error (MSE) between the
  predicted and target values of a regression problem. MSE is a commonly used loss function for regression tasks.
- The formula for calculating MSE is: **MSE = (1/n) * Σ(y_true - y_pred)^2**

##### Metrics

Metrics are used to evaluate the performance of machine learning models during training and evaluation.

###### Accuracy

- **metrics=["accuracy"]**
- Is a metric used to measure the accuracy of a classification model during training and evaluation.

###### MeanAbsoluteError

- **metrics=['mae']**
- Is a metric used to measure the mean absolute error between the predicted outputs and the true values during training
  and evaluation.

###### BinaryCrossentropy

- **metrics=[tf.keras.metrics.BinaryCrossentropy(from_logits=True, name='binary_crossentropy'),'accuracy'])**
- The binary cross-entropy loss measures the discrepancy between the predicted probabilities and the true binary labels,
  while the accuracy metric provides a measure of the model's classification accuracy.