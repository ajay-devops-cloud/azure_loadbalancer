data "azurerm_key_vault" "keyvault" {
  name         = "secret-tizori"
  resource_group_name = "rg-it"
}

data "azurerm_key_vault_secret" "username" {
  name         = "dbusername"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "password" {
  name         = "dbpassword"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}


resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.username.value
  administrator_login_password = data.azurerm_key_vault_secret.password.value

}
resource "azurerm_mssql_database" "database" {
 name         = var.sql_database_name
  server_id = azurerm_mssql_server.sqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"
}