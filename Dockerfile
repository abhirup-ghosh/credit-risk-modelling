# Using an official Python3.7 runtime as a parent image
FROM python:3.7

# Copying the current directory contents into the container
COPY . /home/project

# Seting the working directory
WORKDIR /home/project

# Installing dependencies for matplotlib
RUN apt-get update && apt-get install -y libxft-dev libfreetype6 libfreetype6-dev

# Installing any needed packages specified in opt/requirements.txt
RUN pip install --ignore-installed certifi -r opt/requirements.txt

# Activate extentions for the jupyter notebook
RUN jupyter contrib nbextension install --user
