resource "azurerm_network_security_group" "nsg1" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "nsg1" {

    for_each                   = local.nsgrules
	name                       = each.key
    priority                   = each.value.priority
    direction                  = each.value.direction
    access                     = each.value.access
    protocol                   = each.value.protocol
    source_port_range          = each.value.source_port_range
    destination_port_range     = each.value.destination_port_range
    source_address_prefix      = each.value.source_address_prefix
    destination_address_prefix = each.value.destination_address_prefix
	resource_group_name        = var.resource_group_name
	security_group_name        = var.security_group_name
	depends_on =[
		azurerm_network_security_group.nsg1
	]
}