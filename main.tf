provider "azurerm" {
  version = "~> 2.28.0"
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
}

resource "azurerm_linux_virtual_machine" "ansible" {
  name                            = "${var.prefix}-vm"
  location                        = azurerm_resource_group.ansible.location
  resource_group_name             = azurerm_resource_group.ansible.name
  network_interface_ids           = [azurerm_network_interface.ansible.id]
  size                            = "Standard_D1_v2"
  disable_password_authentication = true
  admin_username                  = var.admin_username

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_key)
  }
}

resource "azurerm_virtual_machine_extension" "ansible" {
  name                 = "install_ansible"
  virtual_machine_id   = azurerm_linux_virtual_machine.ansible.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "${filebase64("custom_script.sh")}"
    }
SETTINGS
}
