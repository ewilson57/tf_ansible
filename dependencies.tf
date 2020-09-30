resource "azurerm_resource_group" "ansible" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "ansible" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.1.0.0/24"]
  location            = azurerm_resource_group.ansible.location
  resource_group_name = azurerm_resource_group.ansible.name
}

resource "azurerm_network_security_group" "ansible" {
  name                = "linux_base"
  location            = azurerm_resource_group.ansible.location
  resource_group_name = azurerm_resource_group.ansible.name

  security_rule {
    name              = "ssh"
    priority          = 100
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "TCP"
    source_port_range = "*"
    destination_port_ranges = [
      "22"
    ]
    source_address_prefix      = var.router_wan_ip
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Test"
  }
}

resource "azurerm_subnet" "ansible" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.ansible.name
  virtual_network_name = azurerm_virtual_network.ansible.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "ansible" {
  subnet_id                 = azurerm_subnet.ansible.id
  network_security_group_id = azurerm_network_security_group.ansible.id
}

resource "azurerm_public_ip" "ansible" {
  name                = "${var.prefix}-publicip"
  resource_group_name = azurerm_resource_group.ansible.name
  location            = azurerm_resource_group.ansible.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ansible" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.ansible.location
  resource_group_name = azurerm_resource_group.ansible.name

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = azurerm_subnet.ansible.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ansible.id
  }
}
