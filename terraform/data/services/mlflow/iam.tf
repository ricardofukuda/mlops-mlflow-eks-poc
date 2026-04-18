module "github_actions_policy" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-policy?ref=v5.18.0"

  name   = lower("github_actions_policy_mlflow")
  path   = "/"
  policy = data.template_file.iam.rendered
}

module "iam_github_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "5.60.0"

  name = "github-actions-mlflow"

  # This should be updated to suit your organization, repository, references/branches, etc.
  subjects = ["repo:ricardofukuda/mlops-mlflow-eks-poc:*"]

  policies = {
    github_actions_policy = module.github_actions_policy.arn
  }
}

resource "aws_eks_access_entry" "access" { # Basically, it is going to make the aws role assume this k8s RBAC group inside k8s
  cluster_name      = data.aws_eks_cluster.eks.name
  principal_arn     = module.iam_github_oidc_role.arn
  kubernetes_groups = ["github-actions-mlflow"]
  type              = "STANDARD"
}
