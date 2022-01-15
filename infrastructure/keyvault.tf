data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "aks-key-vault" {
  name                        = "keyvaultdevenvmycmpb1"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "aks-user-admin-vault-access-policy" {
      key_vault_id = azurerm_key_vault.aks-key-vault.id
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id

      key_permissions = [
        "create",
        "get",
        "purge",
        "recover"
      ]

      secret_permissions = [
        "set",
        "get",
        "list"
      ]

 } 
