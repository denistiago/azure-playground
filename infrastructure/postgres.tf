locals {
  admin_key_vault_access = azurerm_key_vault_access_policy.aks-user-admin-vault-access-policy
}

resource "random_password" "sql_db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_postgresql_server" "sql_db" {
  name                = "sql-db-dev-env-my-company"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku_name = "GP_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "sql_db_admin"
  administrator_login_password = random_password.sql_db_password.result
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "sql_db" {
  name                = "sql_db_database"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.sql_db.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
  depends_on = [
    local.admin_key_vault_access,
  ]
}

resource "azurerm_key_vault_secret" "sql_db_password" {
  name         = "sql-db-password"
  value        = random_password.sql_db_password.result
  key_vault_id = azurerm_key_vault.aks-key-vault.id
  depends_on = [
    local.admin_key_vault_access,
  ]
}

resource "azurerm_key_vault_secret" "sql_db_host" {
  name         = "sql-db-host"
  value        = "${azurerm_postgresql_server.sql_db.name}.postgres.database.azure.com"
  key_vault_id = azurerm_key_vault.aks-key-vault.id
  depends_on = [
    local.admin_key_vault_access,
  ]
}

resource "azurerm_key_vault_secret" "sql_db_username" {
  name         = "sql-db-username"
  value        = "${azurerm_postgresql_server.sql_db.administrator_login}"
  key_vault_id = azurerm_key_vault.aks-key-vault.id
  depends_on = [
    local.admin_key_vault_access,
  ]
}

resource "azurerm_key_vault_secret" "sql_db_database" {
  name         = "sql-db-database"
  value        = "${azurerm_postgresql_database.sql_db.name}"
  key_vault_id = azurerm_key_vault.aks-key-vault.id
  depends_on = [
    local.admin_key_vault_access,
  ]
}