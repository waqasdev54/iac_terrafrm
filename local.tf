local {
nsgrules = {
    AZMGMT_IN_Allow3000={
 
    name                       = "AZMGMT_IN_Allow3000"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.202.1.0/24"
    destination_address_prefix = "*"

    }

    AZMGMT_IN_Allow3010={
 
    name                       = "AZMGMT_IN_Allow3010"
    priority                   = 3010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.202.1.0/24 , 10.202.5.0/24"
    destination_address_prefix = "*"

    }
    }
}
