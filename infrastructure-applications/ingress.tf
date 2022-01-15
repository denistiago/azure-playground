resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress-controller"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true
  namespace        = "ingress"
  version          = "4.0.13"
  set {
    name  = "controller.replicaCount"
    value = "2"
  }
}