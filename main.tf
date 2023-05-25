# Build VNET



resource "azurerm_virtual_network" "vnetbuild" {
	name                	= var.vnet_name
	location            	= var.location
	resource_group_name 	= var.resource_group_name
	address_space       	= var.address_space
	dns_servers         	= var.dns_servers
	tags		        = var.tags
		
	subnet {
		name           		= var.sub_name[0]
		address_prefix 		= var.address_prefix[0]
#		security_group 		= var.security_group[3]
	}
	
	subnet {
		name           		= var.sub_name[1]
		address_prefix 		= var.address_prefix[1]
#		security_group 		= var.security_group[3]
	}
	
	subnet {
		name           		= var.sub_name[2]
		address_prefix 		= var.address_prefix[2]
#		security_group 		= var.security_group[3]
	}
	
	subnet {
		name           		= var.sub_name[3]
		address_prefix 		= var.address_prefix[3]
#		security_group 		= var.security_group[2]
	}
	
	subnet {
		name           		= var.sub_name[4]
		address_prefix 		= var.address_prefix[4]
#		security_group 		= var.security_group[0]
	}
	
	subnet {
		name           		= var.sub_name[5]
		address_prefix 		= var.address_prefix[5]
#		security_group 		= var.security_group[1]
	}

#	subnet {
#                name                    = var.sub_name[6]
#                address_prefix          = var.address_prefix[6]
#                security_group          = var.security_group[2]
#        }
}

# Builds Service Endpoints OLD CODE LEAVE COMMENT OUT

#resource "azurerm_subnet" "add_serv_ep1" {
#	depends_on 								= [null_resource.delay]
#	name                 							= var.name[1]
#	resource_group_name  							= var.resource_group_name
#	virtual_network_name 							= var.name[0]
#	address_prefix       							= var.address_prefix[0]
#	network_security_group_id 						= var.security_group[0]
#	route_table_id								= azurerm_route_table.routetable-vnetbuild.id
#	service_endpoints 							= var.service_endpoints
#}
