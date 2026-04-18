resource "aws_ecr_repository" "airflow" {
  name                 = "airflow"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "docker_image" "airflow" {
  name = "${aws_ecr_repository.airflow.repository_url}:${local.docker_tag}"

  build {
    context = "${path.module}/files"
  }
}

resource "docker_registry_image" "airflow" {
  name = docker_image.airflow.name
}