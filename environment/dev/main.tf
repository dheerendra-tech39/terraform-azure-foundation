module "rgs" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs

}

module "vnets" {
  depends_on = [module.rgs]
  source     = "../../modules/azurerm_virtual_network"
  vnets      = var.vnets

}

module "subnets" {
  depends_on = [module.vnets]
  source     = "../../modules/azurerm_subnet"
  subnets    = var.subnets
}

module "pip" {
  depends_on = [var.vnets, var.subnets]
  source     = "../../modules/azurerm_public_ip"
  pip        = var.pip

}

module "kv" {
  depends_on = [module.rgs]
  source     = "../../modules/azurerm_key_vault"
  key_vaults = var.key_vaults
}


module "vms" {
  depends_on = [module.subnets, module.kv]
  source     = "../../modules/azurerm_virtual_machine"
  vms        = var.vms

}

module "sql_server" {
  depends_on = [module.rgs]
  source     = "../../modules/azurerm_sql_server"
  sql_server = var.sql_server
}

locals {
  sql_server_ids = {
    for k, v in module.sql_server.id :
    k => v
  }
}


module "sql_database" {
  depends_on = [module.sql_server]

  source = "../../modules/azurerm_sql_database"

  sql_database   = var.sql_database
  sql_server_ids = local.sql_server_ids
}

module "bastions" {
  depends_on = [module.subnets]

  source = "../../modules/azurerm_bastion"

  bastions = var.bastions

}

module "application_gateway" {
  depends_on = [module.subnets]

  source = "../../modules/azurerm_application_gateway"

  application_gateways = var.application_gateways

}

module "load_balancer" {
  depends_on = [module.rgs]

  source = "../../modules/azurerm_load_balancer"

  load_balancers = var.load_balancers

}