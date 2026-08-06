output "load_balancer_ids" {

  value = {

    for k, v in azurerm_lb.lb :

    k => v.id

  }

}

output "backend_pool_ids" {

  value = {

    for k, v in azurerm_lb_backend_address_pool.backend_pool :

    k => v.id

  }

}