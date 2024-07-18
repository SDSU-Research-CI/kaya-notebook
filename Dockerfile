FROM gitlab-registry.nrp-nautilus.io/prp/jupyter-stack/prp:v1.3

# Install latest rclone
USER root
RUN curl https://rclone.org/install.sh | bash

# Make sure to run as notebook user for conda installs
USER $NB_USER
WORKDIR /home/${NB_USER}

# Add Conda Kernels for additional conda env kernels
RUN conda install -y -c conda-forge nb_conda_kernels -n base

COPY environment_amr.yml ./environment.yml

RUN conda env create -y -f environment.yml

# Remove the conda file and activate torch_amr by default
RUN rm environment.yml \
 && source activate torch_amr
