#rg name
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
  description ="please input vnet address space"
}

#vnet public subnets
variable public_subnets_addresses {
  description = "Please Input subnets Details"
  type = map(string)
  default = {
    frontend = "10.0.1.0/24"
    backend = "10.0.2.0/24"
    loadbalancer = "10.0.3.0/24"
  }
}

#vnet private subnets
variable private_subnets_addresses {
  description = "Please Input subnets Details"
  type = map(string)
  default = {
    database = "10.0.4.0/24"
    cache = "10.0.5.0/24"
  }
}

#public ip names
variable public_ip_names {
  type = map(string)
  default = {
    frontend = "frontend-public-ip"
    backend  = "backend-public-ip"
  }
}

#network security groups
variable network_security_groups {
  type = map(string)
  default = {
    frontend = "frontend-nsg"
    backend  = "backend-nsg"
    database = "database-nsg"
  }
}

#nsg rules 
variable nsg_rules {
  type = list(object({
    nsg_key   = string      # <-- must match the key in `network_security_groups`
    rule_name = string
    priority  = number
    port      = string
  }))

  default = [
    { nsg_key = "frontend", rule_name = "ssh",  priority = 100, port = "22"   },
    { nsg_key = "frontend", rule_name = "http", priority = 110, port = "80"   },
    { nsg_key = "backend",  rule_name = "ssh",  priority = 100, port = "22"   },
    { nsg_key = "backend",  rule_name = "http", priority = 110, port = "8080" },
    { nsg_key = "database", rule_name = "ssh",  priority = 100, port = "22"   },
    { nsg_key = "database", rule_name = "db",   priority = 110, port = "5432" }
  ]
}

#network interfaces
variable "nics" {
  type = list(object({
    name         = string
    subnet_key   = string     # must match a key in public_subnets or private_subnets
    public_ip_key = string    # must match a key in public_ip_names
    nsg_key      = string     # must match a key in network_security_groups
  }))

  default = [
  {
    name          = "web-nic"
    subnet_key    = "web-subnet"
    public_ip_key = "web"
    nsg_key       = "frontend"
  },
  {
    name          = "api-nic"
    subnet_key    = "api-subnet"
    public_ip_key = "api"
    nsg_key       = "backend"
  },
  {
    name          = "db-nic"
    subnet_key    = "db-subnet"
    public_ip_key = "db"
    nsg_key       = "database"
  }
]
}

