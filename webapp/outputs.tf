output "webapp_url" {
  value = azurerm_app_service.sanwebapp.default_site_hostname
}

output "webapp_ips" {
  value = azurerm_app_service.sanwebapp.outbound_ip_address_list

}
output "sqlserver_id" {
    value = azurerm_sql_server.sqldb.id
  
}