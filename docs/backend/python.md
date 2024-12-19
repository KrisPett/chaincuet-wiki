# Python

#### Pip

Is a package manager for Python packages, or modules if you like.

- pip install package (install package)
- pip install <package_name>==<version> (install specific version)
- pip list (list packages)
- pip install -r requirements.txt (install packages from requirements.txt)
- pip uninstall -r requirements.txt -y

#### Conda

Is a package manager, environment manager, and Python distribution that was created for scientific computing.

- conda create --name myenv (create environment)
- conda activate myenv (activate environment)
- conda list (list packages)
- conda env list (list environments)
- conda remove --name myenv --all (remove environment)

#### Django

In Django the controllers are called views.py. 

- django-admin startproject django_test
- django-admin startapp quickstart
- pip install djangorestframework
- python manage.py migrate
- python manage.py runserver
- python manage.py createsuperuser --username admin --email admin@example.com

#### Libraries

- **os** -> The os library in Python is a built-in module that provides a way to interact with the operating system. It
  offers various functions for working with files and directories, managing processes, accessing environment variables,
  and more. The os module serves as a bridge between Python and the underlying operating system, allowing you to perform
  system-related tasks.
- **shutil** -> 'shell utilities' is a Python module for file and directory operations. It provides functions for tasks
  like copying, moving, and removing files and directories. It simplifies common file system operations in Python.
- **string** -> The string library in Python is a built-in module that provides various utility functions and constants
  for working with strings. It offers a collection of helpful tools for string manipulation, formatting, and processing.
- **re** -> Is a built-in module in Python that provides support for regular expressions (regex).
- **numpy** -> NumPy (Numerical Python) is a powerful library in Python that provides support for large,
  multi-dimensional
  arrays and matrices, along with a collection of mathematical functions to operate on these arrays efficiently. It is
  one of the fundamental packages for scientific computing in Python.
- **pandas** -> Pandas supports reading and writing data in various formats commonly used in machine learning, including
  CSV (Comma
  Separated Values), Excel spreadsheets, SQL databases, and more. This versatility allows data scientists to easily load
  data from different sources, perform data analysis and preprocessing using Pandas, and then save the processed data
  back into the desired format for further use in machine learning pipelines.
- **pprint** -> stands for "pretty print," and it is a Python module that provides a way to format and display data
  structures in a more readable and visually appealing manner. It is part of the standard library in Python.
- **matplotlib** -> Matplotlib is a widely used data visualization library for Python. It provides a comprehensive set
  of functions and classes for creating high-quality static, animated, and interactive visualizations in Python.
  Matplotlib allows you to create a wide range of plots, charts, and graphs, making it a versatile tool for data
  exploration and communication.
- **seaborn** -> Seaborn is a powerful data visualization library in Python built on top of Matplotlib. It provides a
  high-level interface for creating visually appealing and informative statistical graphics. Seaborn is designed to work
  seamlessly with Pandas DataFrames and provides easy-to-use functions for exploring and visualizing data.
- **pillow** -> PIL stands for Python Imaging Library, which is a free and open-source additional library for the Python
  programming language. It adds support for opening, manipulating, and saving many different image file formats.
- **tqdm** -> taqaddum is a Python library for adding progress bars to loops and iterable objects, providing real-time
  feedback on the progress and estimated time remaining.
- **remotezip** -> remotezip is a Python library for working with remote zip files without downloading the entire
  archive, allowing extraction of specific files and retrieval of file information.
- **opencv-python** -> opencv-python is a Python library that provides computer vision and image processing capabilities
  through a Python interface for the OpenCV (Open Source Computer Vision) library. It allows performing various tasks
  such as image manipulation, object detection and tracking, facial recognition, image filtering, and more.
- **imageio** -> imageio is a Python library for reading and writing various image formats, allowing image I/O
  operations and manipulation. It provides a simple interface to handle tasks like reading images into numpy arrays,
  writing numpy arrays to image files, and extracting metadata.
