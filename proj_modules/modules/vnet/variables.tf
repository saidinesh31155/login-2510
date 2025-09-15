#variables for vnet components
variable rg_name {
  description = "please input resource group name"
}

#rg location
variable rg_location {
  description = "please input resource group location"
}

#vnet name
variable vnet_name {
  description = "please input vnet name"
}

#vnet address space
variable vnet_address_space {
  type = list(string)
  description ="please input vnet address space"
  default     = ["10.0.0.0/16"]
}