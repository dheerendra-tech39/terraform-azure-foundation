resource "azurerm_public_ip" "pip" {

  for_each = var.load_balancers

  name                = each.value.pip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

}

resource "azurerm_lb" "lb" {

  for_each = var.load_balancers

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku

  frontend_ip_configuration {

    name                 = each.value.frontend_ip_name
    public_ip_address_id = azurerm_public_ip.pip[each.key].id

  }

}

resource "azurerm_lb_backend_address_pool" "backend_pool" {

  for_each = var.load_balancers

  name            = each.value.backend_pool_name
  loadbalancer_id = azurerm_lb.lb[each.key].id

}

resource "azurerm_lb_probe" "probe" {

  for_each = var.load_balancers

  name            = each.value.probe_name
  loadbalancer_id = azurerm_lb.lb[each.key].id

  protocol = each.value.protocol
  port     = each.value.probe_port

}

resource "azurerm_lb_rule" "rule" {

  for_each = var.load_balancers

  name                           = each.value.rule_name
  loadbalancer_id                = azurerm_lb.lb[each.key].id
  protocol                       = each.value.protocol

  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port

  frontend_ip_configuration_name = each.value.frontend_ip_name

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.backend_pool[each.key].id
  ]

  probe_id = azurerm_lb_probe.probe[each.key].id

}