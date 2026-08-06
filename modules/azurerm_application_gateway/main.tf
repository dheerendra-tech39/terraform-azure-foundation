data "azurerm_subnet" "subnet" {

  for_each = var.application_gateways

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name

}

resource "azurerm_public_ip" "pip" {

  for_each = var.application_gateways

  name                = each.value.pip_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

}

resource "azurerm_application_gateway" "appgw" {

  for_each = var.application_gateways

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  sku {

    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.capacity

  }

  gateway_ip_configuration {

    name      = "gateway-ip-config"
    subnet_id = data.azurerm_subnet.subnet[each.key].id

  }

  frontend_port {

    name = "frontend-port"
    port = each.value.frontend_port

  }

  frontend_ip_configuration {

    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.pip[each.key].id

  }

  backend_address_pool {

    name = each.value.backend_pool_name

  }

  backend_http_settings {

    name                  = "backend-http-setting"
    cookie_based_affinity = "Disabled"
    port                  = each.value.backend_port
    protocol              = each.value.protocol
    request_timeout       = 30

  }

  http_listener {

    name                           = "listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = each.value.protocol

  }

  request_routing_rule {

    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = each.value.backend_pool_name
    backend_http_settings_name = "backend-http-setting"
    priority                   = 100

  }

}