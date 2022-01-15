resource "azurerm_network_security_group" "base-network-sg" {
  name                = "base-network-sg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "base-network-vnet" {
  depends_on = [
    azurerm_network_security_group.base-network-sg
  ]
  name                = "base-network-vnet"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["12.0.0.0/16"]
  dns_servers         = ["12.0.0.4", "12.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "12.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "12.0.2.0/24"
    security_group = azurerm_network_security_group.base-network-sg.id
  }

  tags = {
    environment = "Production"
  }
}