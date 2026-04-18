locals {
  secrets = jsondecode(file("${path.module}/secrets/secrets.json"))
}
