output "bastion_ids" {
  value = {
    for k, v in azurerm_bastion_host.bastion : k => v.id
  }
}

output "bastion_names" {
  value = {
    for k, v in azurerm_bastion_host.bastion : k => v.name
  }
}