FROM python:3.6-slim-buster


WORKDIR /data

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    curl \
    wget \
    gpg

# pip config
RUN mkdir ~/.pip/ && \
    touch ~/.pip/pip.conf && \
    echo [global] >> ~/.pip/pip.conf && \
    echo extra-index-url = https://pip.repos.neuron.amazonaws.com >> ~/.pip/pip.conf && \
    cat ~/.pip/pip.conf

# git
RUN apt-get install -y git

# zenml
RUN pip install zenml

# jupyter
RUN pip install jupyterlab

# setting workdir repo
RUN git clone https://github.com/bonacciog/zenml_practise.git /data/app
WORKDIR /data/app

# zenml init
RUN zenml init --analytics_opt_in yes

ENV NB_PREFIX /

CMD ["sh","-c", "jupyter notebook --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]