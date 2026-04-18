# Dockerfile to package the entire MLflow Project to make it portable for developers.
# Use the official Ubuntu 22.04 as base
FROM ubuntu:22.04

# Avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install ca-certificates curl -y && install -m 0755 -d /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && chmod a+r /etc/apt/keyrings/docker.asc

RUN tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

RUN apt update && apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin -y

# Install Python 3.10 and pip
RUN apt-get install -y \
  python3.10 \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

# (Optional) Set python3.10 as the default 'python' command
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1


RUN mkdir -p /mlflow/projects/code/
WORKDIR /mlflow/projects/code/

COPY . .

#RUN pip install mlflow
#RUN pip install kubernetes
RUN pip install --requirement requirements.txt
