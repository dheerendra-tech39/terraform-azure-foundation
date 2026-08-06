resource "azurerm_mssql_database" "sql_database" {
  for_each = var.sql_database

  name      = each.value.name
  server_id = var.sql_server_ids[each.value.sql_server_key]

  collation   = each.value.collation
  max_size_gb = each.value.max_size_gb
  sku_name    = each.value.sku_name

  dynamic "short_term_retention_policy" {
    for_each = each.value.short_term_retention_policy == null ? [] : [1]
    content {
      retention_days = each.value.short_term_retention_policy.retention_days
    }
  }
}