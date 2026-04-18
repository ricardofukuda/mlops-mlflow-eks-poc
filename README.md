# MLOPS MLFlow POC using AWS EKS Cluster
Deploys MLFlow inside Kubernetes cluster. Contains instructions to train and deploy machine learning models using MLFlow and Kubernetes.
This terraform deploys a basic eks cluster for testing pourposes.

## Terraform Modules Reference
https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/19.13.1

https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/4.0.1

## Deploys
- MLFlow;
- KServe/KNative;
- CertManager;
- Istio;
- Apache Airflow;

## Kubectl config
```
aws eks update-kubeconfig --region us-east-1 --name eks-infra --kubeconfig ~/.kube/eks-infra
export KUBECONFIG=~/.kube/eks-infra
```

## Local Port Forward
```
# Airflow
kubectl port-forward service/apache-airflow-webserver -n apache-airflow 8080:8080
http://localhost:8080
```

```
export AWS_PROFILE=admin
aws eks update-kubeconfig --region us-east-1 --name eks-infra
```


## Run MLFlow Project inside Kubernetes
docker login:
```
export AWS_PROFILE=session
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 127923327338.dkr.ecr.us-east-1.amazonaws.com
```

Build the BASE docker image which contains the environment/dependencies for the MLFlow Project execution:
```
cd mlflow/
docker build --tag mlflow-demo-iris-base:latest .
```

Build the MLFlow Project as a docker image, push it to ECR, then runs the training Job inside kubernetes:
```
aws ecr create-repository --region us-east-1 --repository-name mlflow-demo-iris
  
export MLFLOW_TRACKING_URI=https://mlflow.ricardoxyz.website
export MLFLOW_EXPERIMENT_NAME=iris
mlflow run . --backend kubernetes --backend-config ./kubernetes_backend.json --build-image
```

## Run MLFlow Inference inside Kubernetes
### Build inference docker image
You must specify the mlflow run id.
```
aws ecr create-repository --region us-east-1 --repository-name mlflow-demo-iris-inference
export MLFLOW_TRACKING_URI=https://mlflow.ricardoxyz.xyz
mlflow models build-docker -m runs:/<MLFLOW RUN ID>/model -n 127923327338.dkr.ecr.us-east-1.amazonaws.com/mlflow-demo-iris-inference --enable-mlserver
docker push 127923327338.dkr.ecr.us-east-1.amazonaws.com/mlflow-demo-iris-inference:latest
```

### Deploy the InferenceService
It's going to deploy inside kubernetes:
```
kubectl apply -f mlflow/kubernetes_inference.yaml
```

### Test inference
Send an inference request to your deployed model:
```
cat <<EOF > "./iris-input.json"
{
  "instances": [
    [6.8,  2.8,  4.8,  1.4],
    [6.0,  3.4,  4.5,  1.6]
  ]
}
EOF
curl -v -H "Content-Type: application/json"  -H "Host: mlflow-demo-iris-predictor.mlflow-inference.<DOMAIN>" <LOAD BALANCER>/invocations -d @./iris-input.json
```

# Dependency/Requirements
```
- mlflow:
   -Kserve:
      - knative serverless:
         - istio
      - cert-manager
```



