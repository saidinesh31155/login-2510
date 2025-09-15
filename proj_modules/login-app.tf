module "login_vnet" {
    source = "./modules/vnet"
    rg_name = "login-rg"
    rg_location = "west us"
    vnet_name = "login-vnet"
}

module "login_vm" {
    source = "./modules/vm"
    vm_name = "login-vm"
    rg_name = "login-rg"
    rg_location = "west us"
    vm_size = "Standard_F2"
    admin_username = "ubuntu"
    custom_data_path = filebase64(login-script.sh)
    network_interface_id = module.login_vnet.web_nic_id
    ssh_public_key_path = file("~/.ssh/id_rsa.pub")
    os_disk_type =  "Standard_LRS"
    image_publisher = "Canonical"
    image_offer = "0001-com-ubuntu-server-jammy"
    image_sku = "22_04-lts"
    image_version = "latest"
}