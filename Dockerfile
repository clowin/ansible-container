FROM alpine:3.7
MAINTAINER zentavr <zentavr@hello.world>

ENV ANSIBLE_CONTAINER=1
ENV ANSIBLE_CONTAINER_VERSION=0.9.3rc0

# How to build the conductor-image: http://docs.ansible.com/ansible-container/conductor.html#baking-your-own-conductor-base


# openssh is necessary until this is fixed: https://github.com/ansible/ansible/issues/24705
RUN apk add --no-cache -U \
    python-dev \
    py2-pip \
    make \
    git \
    curl \
    rsync \
    libffi \
    libffi-dev \
    openssl \
    openssl-dev \
    gcc \
    musl-dev \
    tar \
    openssh \
    docker \
    docker-py && rm -f /var/cache/apk/*

RUN mkdir -p /etc/ansible/roles /_ansible/src

# The COPY here will break cache if the version of Ansible Container changed
COPY / /_ansible/container


RUN cd /_ansible && \
    pip install --no-cache-dir -r container/conductor-requirements.txt && \
    pip install --no-cache-dir -e container[docker,openshift] && \
    ansible-galaxy install -p /etc/ansible/roles -r container/conductor-requirements.yml
