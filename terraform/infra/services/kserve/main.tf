resource "helm_release" "kserve" {
  name             = "kserve"
  create_namespace = true

  chart     = "https://github.com/kserve/kserve/releases/download/v0.16.0/helm-chart-kserve-v0.16.0.tgz"
  namespace = "kserve"

  values = [data.template_file.values.rendered]

  depends_on = [helm_release.kserve_crd]
}

resource "helm_release" "kserve_crd" {
  name = "kserve-crd"

  chart = "https://github.com/kserve/kserve/releases/download/v0.16.0/helm-chart-kserve-crd-v0.16.0.tgz"

  values = [data.template_file.values_crd.rendered]
}
