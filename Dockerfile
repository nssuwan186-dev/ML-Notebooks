FROM jupyter/base-notebook:latest

# Copy the environment file
COPY environment.yml /tmp/

# Update the base environment with our specified packages
# Using 'update' on base is often safer in docker than creating a new env that might not be activated correctly
RUN conda env update -n base -f /tmp/environment.yml && \
    conda clean -afy

# Install ipykernel to ensure the kernel is registered
RUN python -m ipykernel install --user --name=python3 --display-name="Python (ML)"

# Copy project files
COPY . /home/jovyan/work

# Set permissions
RUN chown -R ${NB_UID}:${NB_GID} /home/jovyan/work