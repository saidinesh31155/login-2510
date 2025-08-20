#azure resource group
resource "azurerm_resource_group" "login-rg" {
  name     = "login-rg"
  location = "East US"
}

#vnet 
resource "azurerm_virtual_network" "login-vnet" {
  name                = "login-vnet"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
  address_space       = ["10.0.0.0/16"]
}

#web subnet
resource "azurerm_subnet" "web-sn" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
} 

