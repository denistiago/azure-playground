# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

data "azurerm_kubernetes_cluster" "aks-lab" {
  name                = "aks-lab"
  resource_group_name = "1-8289e053-playground-sandbox"
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks-lab.kube_config.0.host
    username               = data.azurerm_kubernetes_cluster.aks-lab.kube_config.0.username
    password               = data.azurerm_kubernetes_cluster.aks-lab.kube_config.0.password
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks-lab.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks-lab.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks-lab.kube_config.0.cluster_ca_certificate)
  }
}