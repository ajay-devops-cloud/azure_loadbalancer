data "azurerm_subnet" "bsubnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_public_ip" "publicip" {
  name                = var.publicip_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.bsubnet.id
    public_ip_address_id = data.azurerm_public_ip.publicip.id
  }
}