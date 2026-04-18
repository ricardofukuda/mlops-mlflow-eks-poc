# Dockerfile to package the entire MLflow Project to make it portable for developers.
FROM python:3.10

RUN mkdir -p /mlflow/projects/code/
WORKDIR /mlflow/projects/code/

COPY . .

RUN pip install --requirement requirements.txt
