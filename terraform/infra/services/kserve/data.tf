data "aws_eks_cluster" "eks" {
  name = "eks-${var.env}"
}

data "aws_eks_cluster_auth" "eks_auth" {
  name =  data.aws_eks_cluster.eks.name
}

data "template_file" "values" {
  template = file("yaml/values.yaml")
  vars = {
  }
}

data "template_file" "values_crd" {
  template = file("yaml/values_crd.yaml")
  vars = {
  }
}
