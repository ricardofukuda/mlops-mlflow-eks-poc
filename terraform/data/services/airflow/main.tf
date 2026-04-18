
# https://artifacthub.io/packages/helm/apache-airflow/airflow/1.9.0
# ^ install airflow version 2.5.3
resource "helm_release" "apache_airflow" {
  name       = "apache-airflow"
  create_namespace = true

  repository = "https://airflow.apache.org/"
  chart      = "airflow"
  namespace  = "apache-airflow"
  version    = "1.13.1"

  force_update = true

  values = [ data.template_file.values.rendered]

  depends_on = [ docker_registry_image.airflow ]
}