locals {
  istio_version = "1.21.0"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "istio-ingressgateway"

    labels = {
      "istio-injection" = "enabled"
    }
  }
}

# https://artifacthub.io/packages/helm/istio-official/base/1.21.0
resource "helm_release" "istio_base" {
  name             = "istio-base"
  create_namespace = true

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  version    = local.istio_version

  values = [data.template_file.values_base.rendered]

  #depends_on = [ kubernetes_namespace.namespace ]
}

# https://artifacthub.io/packages/helm/istio-official/istiod/1.21.0
resource "helm_release" "istiod" {
  name             = "istiod"
  create_namespace = true

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  version    = local.istio_version

  values = [data.template_file.values.rendered]

  depends_on = [helm_release.istio_base]
}

# https://artifacthub.io/packages/helm/istio-official/gateway/1.21.1
resource "helm_release" "istio-ingressgateway" {
  name             = "istio-ingressgateway"
  create_namespace = false

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "istio-system"
  version    = local.istio_version

  values = [data.template_file.values_ingressgateway.rendered]

  depends_on = [kubernetes_namespace.namespace, helm_release.istiod]
}
