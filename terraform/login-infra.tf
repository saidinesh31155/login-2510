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

#api-nsg
resource "azurerm_network_security_group" "api-nsg" {
  name                = "login-api-nsg"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
}

#db-nsg
resource "azurerm_network_security_group" "db-nsg" {
  name                = "login-db-nsg"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
}

#web ssh
resource "azurerm_network_security_rule" "web-ssh" {
  name                        = "login-web-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.web-nsg.name
}

#web http
resource "azurerm_network_security_rule" "web-http" {
  name                        = "login-web-http"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.web-nsg.name
}

#api ssh
resource "azurerm_network_security_rule" "api-ssh" {
  name                        = "login-api-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.api-nsg.name
}

#api http
resource "azurerm_network_security_rule" "api-http" {
  name                        = "login-api-http"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.api-nsg.name
}

#db ssh
resource "azurerm_network_security_rule" "db-ssh" {
  name                        = "login-db-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.db-nsg.name
}

#db postgres
resource "azurerm_network_security_rule" "db-postgres" {
  name                        = "login-db-postgres"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.db-nsg.name
}

#web nic
resource "azurerm_network_interface" "web-nic" {
  name                = "login-web-nic"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-pip.id
  }
}

#web nic nsg asc
resource "azurerm_network_interface_security_group_association" "login-web-nic-nsg-asc" {
  network_interface_id      = azurerm_network_interface.web-nic.id
  network_security_group_id = azurerm_network_security_group.web-nsg.id
}

#api nic
resource "azurerm_network_interface" "api-nic" {
  name                = "login-api-nic"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.api-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.api-pip.id
  }
}

#api nic nsg asc
resource "azurerm_network_interface_security_group_association" "login-api-nic-nsg-asc" {
  network_interface_id      = azurerm_network_interface.api-nic.id
  network_security_group_id = azurerm_network_security_group.api-nsg.id
}

#db nic
resource "azurerm_network_interface" "db-nic" {
  name                = "login-db-nic"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db-sn.id
    private_ip_address_allocation = "Dynamic"
  }
}

#db nic nsg asc
resource "azurerm_network_interface_security_group_association" "login-db-nic-nsg-asc" {
  network_interface_id      = azurerm_network_interface.db-nic.id
  network_security_group_id = azurerm_network_security_group.db-nsg.id
}





