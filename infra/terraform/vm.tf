# NIC Frontend
resource "azurerm_network_interface" "nic_frontend" {
  name                = "${var.project_name}-nic-frontend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.snet["frontend"].id
    private_ip_address_allocation = "Dynamic"
  }
}

# NIC Backend
resource "azurerm_network_interface" "nic_backend" {
  name                = "${var.project_name}-nic-backend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.snet["backend"].id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM Frontend
resource "azurerm_linux_virtual_machine" "vm_frontend" {
  name                  = "${var.project_name}-frontend"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_B2s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic_frontend.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub") 
  }
}

# VM Backend
resource "azurerm_linux_virtual_machine" "vm_backend" {
  name                  = "${var.project_name}-backend"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_B2s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic_backend.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

 admin_ssh_key {
  username   = var.admin_username
  public_key = var.ssh_public_key
 }
}
