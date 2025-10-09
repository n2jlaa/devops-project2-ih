output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = {
    for k, s in azurerm_subnet.snet : k => s.id
  }
}

output "subnet_prefixes" {
  value = {
    for k, s in azurerm_subnet.snet : k => s.address_prefixes
  }
}
