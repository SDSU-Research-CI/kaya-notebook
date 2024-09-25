ARG BASE_IMAGE=quay.io/jupyter/pytorch-notebook:cuda12-2024-07-29
FROM ${BASE_IMAGE}

USER root

# Install latest rclone
RUN curl https://rclone.org/install.sh | bash

# Install Code Server (VS Code)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Make sure to run as notebook user for conda installs
USER $NB_USER
WORKDIR /home/${NB_USER}

# Add Conda Kernels for additional conda env kernels and jupyter proxy extension
RUN mamba install -y -c conda-forge nb_conda_kernels jupyter-server-proxy -n base

# Install code server proxy
RUN pip install jupyter-codeserver-proxy

# Install torch_amr environment
COPY environment_amr.yml ./environment.yml
RUN mamba env create -y -f environment.yml

# Remove the conda file and activate torch_amr by default
RUN rm environment.yml \
 && source activate torch_amr
