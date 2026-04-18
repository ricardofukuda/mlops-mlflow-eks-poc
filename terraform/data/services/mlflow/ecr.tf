resource "aws_ecr_repository" "mlflow-demo-iris" {
  name                 = "mlflow-demo-iris"
  image_tag_mutability = "MUTABLE"

  force_delete = true
}

resource "aws_ecr_repository" "mlflow-demo-iris-inference" {
  name                 = "mlflow-demo-iris-inference"
  image_tag_mutability = "MUTABLE"

  force_delete = true
}

resource "aws_ecr_repository" "mlflow-demo-iris-base" {
  name                 = "mlflow-demo-iris-base"
  image_tag_mutability = "MUTABLE"

  force_delete = true
}
