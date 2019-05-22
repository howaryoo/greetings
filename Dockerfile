FROM phusion/baseimage:0.11

ARG PROJECT=greetings

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        tmux \
        vim \
        wget \
    && rm -rf /var/lib/apt/lists/*


ARG MY_UID=1000
ARG MY_GID=1000

RUN echo "developer:x:$MY_UID:$MY_GID:Developer,,,:/home/developer:/bin/bash"
RUN echo "developer:x:$MY_GID:"

RUN mkdir -p /home/developer && \
    echo "developer:x:$MY_UID:$MY_GID:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:$MY_GID:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer


USER developer
ENV HOME /home/developer
WORKDIR /home/developer

ENV PATH /home/developer/bin:$PATH

# Install miniconda
ENV PATH /home/developer/miniconda/bin:${PATH}
RUN curl -LO https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -p /home/developer/miniconda -b && \
    rm Miniconda3-latest-Linux-x86_64.sh


RUN /home/developer/miniconda/bin/conda create --name ${PROJECT} python=3.7

ENV PATH /home/developer/.conda/envs/${PROJECT}/bin:$PATH
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=developer:developer . /home/developer/${PROJECT}/

WORKDIR /home/developer/${PROJECT}
ENV PYTHONPATH /home/developer/${PROJECT}

ENTRYPOINT ["python3"]
CMD ["./greetings/server_api.py"]
