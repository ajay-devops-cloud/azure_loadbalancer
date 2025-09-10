data "azurerm_public_ip" "pip" {
  name                = var.publicip_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_lb" "lb" {
  name                = var.lb-name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "internal"
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bap" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.backend_address_pool_name
}
 resource "azurerm_lb_probe" "lbprobe" {
    loadbalancer_id = azurerm_lb.lb.id
  name            = var.lbprobe_name
  port            = 80
}
 resource "azurerm_lb_rule" "lbrule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = var.lbrule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "internal"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.bap.id]
  probe_id = azurerm_lb_probe.lbprobe.id
}