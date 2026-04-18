resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "mlflow-inference"

    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "kubernetes_namespace" "namespace2" {
  metadata {
    name = "mlflow"

    labels = {
      "istio-injection" = "enabled"
    }
  }
}

# https://artifacthub.io/packages/helm/community-charts/mlflow
resource "helm_release" "mlflow" {
  name             = "mlflow"
  create_namespace = false

  repository = "https://community-charts.github.io/helm-charts"
  chart      = "mlflow"
  namespace  = "mlflow"
  version    = "1.8.1"

  values = [data.template_file.values.rendered]

  depends_on = [kubernetes_namespace.namespace2]
}
