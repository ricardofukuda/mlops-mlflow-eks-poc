data "aws_eks_cluster" "eks" {
  name = "eks-${var.env}"
}

data "aws_eks_cluster_auth" "eks_auth" {
  name =  data.aws_eks_cluster.eks.name
}

data "template_file" "values" {
  template = file("config/values.yml")
  vars = {
    ecr_repo = "${aws_ecr_repository.airflow.repository_url}"
    docker_tag = local.docker_tag
  }
}

data "aws_route53_zone" "public" {
  name = var.domain
  private_zone = false
}

data "kubernetes_service" "ingress" {
  metadata {
    name      = "istio-ingressgateway"
    namespace = "istio-system"
  }
}

data "aws_ecr_authorization_token" "token" {}