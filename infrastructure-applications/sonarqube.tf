resource "helm_release" "sonarqube" {
  name             = "sonarqube"
  repository       = "https://sonarSource.github.io/helm-chart-sonarqube"
  chart            = "sonarqube"
  create_namespace = true
  namespace        = "tools"
  version          = "1.1"
  values = [
    "${file("sonarqube-value.yaml")}"
  ]
}