Original reference: https://knative.dev/docs/install/operator/knative-with-operators/

# Small knative test application
kubectl create namespace hello
kn service create hello --image ghcr.io/knative/helloworld-go:latest --port 8080 --env TARGET=World --namespace hello
curl -H "Host: hello.hello.mywebsite.xyz" <ELB endpoint> --verbose
kn service delete hello --namespace hello