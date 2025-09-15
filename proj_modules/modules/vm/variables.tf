#variables for vnet components
variable "vm_name" {
  description = "please input vm name"
}

variable "rg_name" {
  description = "please input resource group name"
}

variable "rg_location" {
  description = "please input resource group location"
}


variable "vm_size" {
  description = "please input vm size"
  default     = "Standard_F2"
}

variable "admin_username" {
  description = "please input admin_username"
  default     = "ubuntu"
}

variable "custom_data_path" {
  description = "Path to custom data script"
}

variable "ssh_public_key" {
  type        = string
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "network_interface_id" {
  type        = string
  description = "ID of the network interface"
}

variable "os_disk_type" {
  type        = string
  default     = "Standard_LRS"
}

variable "image_publisher" {
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  type        = string
  default     = "22_04-lts"
}

variable "image_version" {
  type        = string
  default     = "latest"
}
