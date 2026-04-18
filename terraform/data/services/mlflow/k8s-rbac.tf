resource "kubernetes_cluster_role" "github_actions" {
  metadata {
    name = "github-actions-mlflow"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_role" "github_actions" {
  metadata {
    name      = "github-actions-mlflow"
    namespace = "mlflow"
  }

  rule {
    api_groups = [
      ""
    ]
    resources = [
      "configmaps",
      "services",
      "secrets"
    ]
    verbs = [
      "get",
      "create",
      "delete",
      "patch",
      "update",
      "list"
    ]
  }
  rule {
    api_groups = [
      "apps"
    ]
    resources = [
      "deployments",
      "deployments/rollback",
      "deployments/scale",
      "statefulsets",
      "statefulsets/scale"
    ]
    verbs = [
      "get",
      "create",
      "delete",
      "patch",
      "update"
    ]
  }
}

resource "kubernetes_cluster_role_binding" "github_actions" {
  metadata {
    name = "github-actions-mlflow"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "github-actions-mlflow"
  }

  subject {
    kind      = "Group"
    name      = "github-actions-mlflow"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role_binding" "github_actions" {
  metadata {
    name      = "github-actions-mlflow"
    namespace = "mlflow"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "github-actions-mlflow"
  }

  subject {
    kind      = "Group"
    name      = "github-actions-mlflow"
    api_group = "rbac.authorization.k8s.io"
  }
}
