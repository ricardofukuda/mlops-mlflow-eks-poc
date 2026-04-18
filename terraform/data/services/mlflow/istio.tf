
resource "kubernetes_manifest" "istio_gateway" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1alpha3"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "mlflow"
      "namespace" = "mlflow"
    }
    "spec" = {
      "selector" = {
        "istio" = "ingressgateway"
      }
      "servers" = [
        {
          "hosts" = [
            "mlflow.${var.domain}",
          ]
          "port" = {
            "name"     = "http"
            "number"   = 80
            "protocol" = "HTTP"
          }
          "tls" = {
            "httpsRedirect" = true
          }
        },
        {
          "hosts" = [
            "mlflow.${var.domain}",
          ]
          "port" = {
            "name"     = "https"
            "number"   = 443
            "protocol" = "HTTP"
          }
        },
      ]
    }
  }


  depends_on = [kubernetes_namespace.namespace2]

}

resource "kubernetes_manifest" "istio_virtual_service" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1alpha3"
    "kind"       = "VirtualService"
    "metadata" = {
      "name"      = "mlflow"
      "namespace" = "mlflow"
    }
    "spec" = {
      "gateways" = [
        "mlflow"
      ]
      "hosts" = [
        "mlflow.${var.domain}",
      ]
      "http" = [
        {
          "match" = [
            {
              "uri" = {
                "prefix" = "/"
              }
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "mlflow"
                "port" = {
                  "number" = 80
                }
              }
            },
          ]
        },
      ]
    }
  }

  depends_on = [kubernetes_namespace.namespace2]
}
