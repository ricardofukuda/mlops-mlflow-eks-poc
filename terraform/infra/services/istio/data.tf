data "aws_eks_cluster" "eks" {
  name = "eks-${var.env}"
}

data "aws_eks_cluster_auth" "eks_auth" {
  name =  data.aws_eks_cluster.eks.name
}

data "template_file" "values" {
  template = file("config/values.yml")
  vars = {
  }
}

data "template_file" "values_ingressgateway" {
  template = file("config/values_ingressgateway.yml")
  vars = {
    certificate_arn = data.aws_acm_certificate.certificate.arn
    cidr_range = "${chomp(data.http.icanhazip.body)}/32" # TEST ONLY
  }
}

data "template_file" "values_base" {
  template = file("config/values_base.yml")
  vars = {
  }
}

data "aws_acm_certificate" "certificate" {
  domain      = var.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "http" "icanhazip" { # get my current public ip
   url = "http://icanhazip.com"
}