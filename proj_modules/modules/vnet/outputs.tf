#outputs to display
output vnet_id {
    value = azurerm_virtual_network.vnet.id
}

output public_subnet_id {
    value = azurerm_subnet.public_subnet.id
}

output web_nic_id {
    value = azurerm_network_interface.web-nic.id
}