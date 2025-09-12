#azure resource group
resource "azurerm_resource_group" "login-rg" {
  name = var.rg_name
  location = var.rg_location
}

#vnet
resource "azurerm_virtual_network" "login-vnet" {
  name = var.vnet_name
  location = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
  address_space = var.vnet_address_space
}

#Public subnets
resource "azurerm_subnet" "public_subnets" {
  for_each = var.public_subnets_addresses
  name = each.key
  resource_group_name = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes = [each.value]
}

#private subnets
resource "azurerm_subnet" "private_subnets" {
  for_each = var.private_subnets_addresses
  name = each.key
  resource_group_name = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes = [each.value]
}

#public ip names
resource "azurerm_public_ip" "public_ip_names" {
  for_each = var.public_ip_names
  name = "${each.key}-public_ip"
  resource_group_name = azurerm_resource_group.login-rg.name
  location = azurerm_resource_group.login-rg.location
  allocation_method = "Static"
  sku = "Standard"

  tags = {
    environment = each.value
  }
}

#network security groups
resource "azurerm_network_security_group" "network_security_groups" {
  for_each = var.network_security_groups
  name = "${each.key}-nsg"
  location = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name

  tags = {
    Name = each.value
  }
}

#nsg rules
resource "azurerm_network_security_rule" "rules" {
  for_each = {
    for rule in var.nsg_rules :
    "${rule.nsg_key}-${rule.rule_name}" => rule
  }

  name = "login-${each.value.nsg_key}-${each.value.rule_name}"
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.port
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.network_security_groups[each.value.nsg_key].name
}

#network interfaces  
resource "azurerm_network_interface" "nic" {
  for_each = {
    for nic in var.nics : nic.name => nic
  }
 
  name                = each.value.name
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name

   # Attach NSG to NIC
  network_security_group_id = azurerm_network_security_group.network_security_groups[each.value.nsg_key].id

  ip_configuration {
    name                          = "internal"

    # Select the subnet based on whether the key is in public or private subnet map
    subnet_id = contains(keys(var.public_subnets_addresses), each.value.subnet_key) ? azurerm_subnet.public_subnets[each.value.subnet_key].id : azurerm_subnet.private_subnets[each.value.subnet_key].id

    private_ip_address_allocation = "Dynamic"

    # Only assign public IP if key is provided (non-empty string)
    public_ip_address_id =(
      each.value.public_ip_key != "" ?
      azurerm_public_ip.public_ip_names[each.value.public_ip_key].id :
      null
    )
  }
}




 


