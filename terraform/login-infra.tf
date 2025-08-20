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

#api subnet
resource "azurerm_subnet" "api-sn" {
  name                 = "api-subnet"
  resource_group_name  = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
} 

#db subnet
resource "azurerm_subnet" "db-sn" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
} 

#web public ip
resource "azurerm_public_ip" "web-pip" {
  name                = "login-web-pip"
  resource_group_name = azurerm_resource_group.login-rg.name
  location            = azurerm_resource_group.login-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "web"
  }
}

#api public ip
resource "azurerm_public_ip" "api-pip" {
  name                = "login-api-pip"
  resource_group_name = azurerm_resource_group.login-rg.name
  location            = azurerm_resource_group.login-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "api"
  }
}

#web-nsg
resource "azurerm_network_security_group" "web-nsg" {
  name                = "login-web-nsg"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
}

#web-nsg-ssh
resource "azurerm_network_security_rule" "web-nsg-ssh" {
  name                        = "login-web-ssh"
  priority                    = 100
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.login-web-nsg.name
}

#web-nsg-http
resource "azurerm_network_security_rule" "web-nsg-http" {
  name                        = "login-web-http"
  priority                    = 110
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.login-web-nsg.name
}

#api-nsg
resource "azurerm_network_security_group" "api-nsg" {
  name                = "login-api-nsg"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
}

#api-nsg-ssh
resource "azurerm_network_security_rule" "api-nsg-ssh" {
  name                        = "login-api-ssh"
  priority                    = 100
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.login-api-nsg.name
}

#api-nsg-http
resource "azurerm_network_security_rule" "api-nsg-http" {
  name                        = "login-api-http"
  priority                    = 110
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.login-api-nsg.name
}

#db-nsg
resource "azurerm_network_security_group" "db-nsg" {
  name                = "login-db-nsg"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
}

#db-nsg-ssh
resource "azurerm_network_security_rule" "db-nsg-ssh" {
  name                        = "login-db-ssh"
  priority                    = 100
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.login-db-nsg.name
}

#db-nsg-http
resource "azurerm_network_security_rule" "db-nsg-http" {
  name                        = "login-db-http"
  priority                    = 110
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.login-db-nsg.name
}

