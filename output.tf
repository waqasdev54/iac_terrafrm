#output Variables

output "NSG" {
   value = tomap({"name" = "azurerm_network_security_group.nsg1.name",
                  "id" = "azurerm_network_security_group.nsg1.id",
                  "resource_group" = "azurerm_network_security_group.nsg1.resource_group_name"})
}

output "id" {
    value = azurerm_network_security_group.nsg1.id
	description = "NSG ID value "
}

output "name" {
    value = azurerm_network_security_group.nsg1.name
	description = "NSG Name value "
}
