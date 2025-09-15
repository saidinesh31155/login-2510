#azure resource group
resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.rg_location
}

#vnet
resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = ["10.0.0.0/16"]
}

#Public subnet
resource "azurerm_subnet" "public_subnet" {
  name = "${var.vnet_name}-public-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.1.0/24"]
}

#public ip name
resource "azurerm_public_ip" "public_ip_name" {
  name = "${var.vnet_name}-public_ip"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  sku = "Standard"

  tags = {
    environment = "${var.vnet_name}-public_ip" 
  }
}

#network security group
resource "azurerm_network_security_group" "web-nsg" {
  name = "web-nsg"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    Name = "${var.vnet_name}-fe-nsg"
  }
}

#frontend-ssh
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
  resource_group_name         = azurerm_resource_group.rg.name
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
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web-nsg.name
}

#web nic
resource "azurerm_network_interface" "web-nic" {
  name                = "login-web-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_name.id
  }
}

#web nic nsg asc
resource "azurerm_network_interface_security_group_association" "login-web-nic-nsg-asc" {
  network_interface_id      = azurerm_network_interface.web-nic.id
  network_security_group_id = azurerm_network_security_group.web-nsg.id
}