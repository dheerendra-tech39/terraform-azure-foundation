data "azurerm_subnet" "subnet" {
  for_each = var.vms

  name                 = each.value.nic_subnet_name
  virtual_network_name = each.value.nic_vnet_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_key_vault" "kv" {
  for_each = var.vms

  name                = each.value.Key_vault_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault_secret" "admin_password" {
    for_each =  var.vms
    name = each.value.secret_name   
    key_vault_id = data.azurerm_key_vault.kv[each.key].id
  
}