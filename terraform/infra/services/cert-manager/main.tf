# https://artifacthub.io/packages/helm/cert-manager/cert-manager/1.14.4
resource "helm_release" "certmanager" {
  name       = "cert-manager"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "1.14.4"

  values = [data.template_file.values.rendered]
}