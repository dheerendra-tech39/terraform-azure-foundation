output "id" {
  value = {
    for k, v in azurerm_mssql_server.mysql :
    k => v.id
  }
}

