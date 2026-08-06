output "application_gateway_ids" {

  value = {

    for k, v in azurerm_application_gateway.appgw :

    k => v.id

  }

}

output "application_gateway_names" {

  value = {

    for k, v in azurerm_application_gateway.appgw :

    k => v.name

  }

}