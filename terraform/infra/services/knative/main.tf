resource "null_resource" "deploy_operator_yaml" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/yaml/operator.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete --ignore-not-found -f ${path.module}/yaml/operator.yaml"
  }

  triggers = {
    hash = filemd5("${path.module}/yaml/operator.yaml")
  }
}

resource "null_resource" "deploy_yaml" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/yaml/main.yaml"
  }

  triggers = {
    hash = filemd5("${path.module}/yaml/main.yaml")
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete --ignore-not-found  -f ${path.module}/yaml/main.yaml"
  }

  depends_on = [ null_resource.deploy_operator_yaml ]
}