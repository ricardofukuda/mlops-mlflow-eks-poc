module "iam_github_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "5.60.0"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}
