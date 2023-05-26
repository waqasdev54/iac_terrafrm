variable nsg_name {
    description = "Network Security Group Name"
    type        = string
    default = "NSG-properpay8-sandbox-scus"
}

variable location {
    description = "NSG location"
    type        = string
    default = "South Central US"
}

variable resource_group_name {
    description = "Resource Group Name"
    type        = string
    default = "rg-properpay8-sandbox-scus-network"
}
