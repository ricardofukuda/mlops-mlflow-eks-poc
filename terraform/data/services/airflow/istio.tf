
resource "kubernetes_manifest" "istio_gateway" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1alpha3"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "airflow"
      "namespace" = "apache-airflow"
    }
    "spec" = {
      "selector" = {
        "istio" = "ingressgateway"
      }
      "servers" = [
        {
          "hosts" = [
            "airflow.${var.domain}",
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
            "airflow.${var.domain}",
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

}

resource "kubernetes_manifest" "istio_virtual_service" {
  manifest = {
    "apiVersion" = "networking.istio.io/v1alpha3"
    "kind"       = "VirtualService"
    "metadata" = {
      "name"      = "airflow"
      "namespace" = "apache-airflow"
    }
    "spec" = {
      "gateways" = [
        "airflow"
      ]
      "hosts" = [
        "airflow.${var.domain}",
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
                "host" = "apache-airflow-webserver"
                "port" = {
                  "number" = 8080
                }
              }
            },
          ]
        },
      ]
    }
  }
}