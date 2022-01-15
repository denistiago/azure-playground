resource "azurerm_kubernetes_cluster" "aks-lab" {
  name                = "aks-lab"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-lab"
  
  default_node_pool {
    name       = "agentpool"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
    enable_auto_scaling = false
    # vnet_subnet_id = azurerm_virtual_network.base-network-vnet.subnet.*.id[0]
  }

  addon_profile {
    azure_keyvault_secrets_provider {
      enabled = true
    }
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_key_vault_access_policy" "aks-key-vault-access-policy" {
  key_vault_id = azurerm_key_vault.aks-key-vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_kubernetes_cluster.aks-lab.addon_profile[0].azure_keyvault_secrets_provider[0].secret_identity[0].object_id

  key_permissions = [
    "create",
    "get",
    "purge",
    "recover"
  ]

  secret_permissions = [
    "set",
    "get",
    "get",
    "list"
  ]
}
