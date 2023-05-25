#output Variables

output "network" {
   value = tomap({"name" = "azurerm_virtual_network.vnetbuild.name",
                  "id" = "azurerm_virtual_network.vnetbuild.id",
                  "resource_group" = "azurerm_virtual_network.vnetbuild.resource_group_name",
                  "address_space" = "azurerm_virtual_network.vnetbuild.address_space[0]"})
}

output "id" {
    value = azurerm_virtual_network.vnetbuild.id
	description = "VNET ID value "
}

output "name" {
    value = azurerm_virtual_network.vnetbuild.name
	description = "VNET Name value "
}

output "subnet1name" {
	value = var.sub_name[0]
	description = "VNET-subnet1 name value "
}

output "subnet2name" {
	value = var.sub_name[1]
	description = "VNET-subnet2 name value "
}

output "subnet3name" {
	value = var.sub_name[2]
	description = "VNET-subnet3 name value "
}

output "subnet4name" {
	value = var.sub_name[3]
	description = "VNET-subnet4 name value "
}

output "subnet5name" {
	value = var.sub_name[4]
	description = "VNET-subnet5 name value "
}

output "subnet6name" {
	value = var.sub_name[5]
	description = "VNET-subnet6 name value "
}

# output "subnet7name" {
#        value = var.sub_name[6]
#        description = "VNET-subnet7 name value "
#}

