module "rg" {
  source = "../../module/azurerm_resource_group"
  resource_group_name = "app-dev-rg"
  location = "central india"
}
module "vnet" {
    depends_on = [ module.rg ]
  source = "../../module/azurerm_vnet"
  virtual_network_name = "appvnet"
  address_space = ["10.0.0.0/16"]
  location = "central india"
  resource_group_name = "app-dev-rg"
}
module "subnet" {
    depends_on = [ module.vnet ]
  source = "../../module/azurerm_subnet"
  subnet_name = "appsubnet"
  resource_group_name = "app-dev-rg"
  virtual_network_name = "appvnet"
  address_prefixes = ["10.0.0.0/24"]
}
module "bsubnet" {
    depends_on = [ module.vnet ]
  source = "../../module/azurerm_subnet"
  subnet_name = "AzureBastionSubnet"
  resource_group_name = "app-dev-rg"
  virtual_network_name = "appvnet"
  address_prefixes = ["10.0.1.0/26"]
}
module "pip" {
   depends_on = [ module.rg ]
source = "../../module/azurerm_publicip"
publicip_name = "mypublicip"
resource_group_name = "app-dev-rg"
location = "central india"
}
module "pip1" {
   depends_on = [ module.rg ]
source = "../../module/azurerm_publicip"
publicip_name = "mypublicip1"
resource_group_name = "app-dev-rg"
location = "central india"
}

module "virtualmachene" {
    depends_on = [ module.subnet ]
    source = "../../module/azurerm_virtual_machene"
  nic_name = "mynic"
  location = "central india"
  resource_group_name = "app-dev-rg"
  virtual_machene_name = "dev1vm"
  subnet_name = "appsubnet"
  virtual_network_name = "appvnet"
  admin_username = "devops123"
  admin_password = "Devops@1234"
  publisher = "Canonical"
   offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    image_version = "latest"
}
module "virtualmachene1" {
    depends_on = [ module.subnet ]
    source = "../../module/azurerm_virtual_machene"
  nic_name = "mynic1"
  location = "central india"
  resource_group_name = "app-dev-rg"
  virtual_machene_name = "dev2vm"
  subnet_name = "appsubnet"
  virtual_network_name = "appvnet"
  admin_username = "devops123"
  admin_password = "Devops@1234"
  publisher = "Canonical"
   offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    image_version = "latest"
}
module "bastion" {
  depends_on = [ module.bsubnet, module.pip1]
  source = "../../module/azurerm_bastion"
  bastion_name = "appbasion"
  location = "central india"
  resource_group_name = "app-dev-rg"
  virtual_network_name = "appvnet"
  subnet_name = "AzureBastionSubnet"
  publicip_name = "mypublicip1"
  
}
module "lb" {
  depends_on = [ module.rg, module.pip ]
  source = "../../module/azurerm_loadbalancer"
  lb-name = "appdevlb"
  resource_group_name = "app-dev-rg"
  location = "central india"
  publicip_name = "mypublicip"
  lbprobe_name = "appdevlbprobe"
  lbrule_name = "appdevlbrules"
  backend_address_pool_name = "appdevbap"
}
module "nsg" {
  depends_on = [ module.virtualmachene ]
  source = "../../module/azurerm_nsg"
  nsg_name = "appdevnsg"
  nic_name = "mynic"
  resource_group_name = "app-dev-rg"
  location = "central india"
}
module "nsg1" {
  depends_on = [ module.virtualmachene1 ]
  source = "../../module/azurerm_nsg"
  nsg_name = "appdevnsg1"
  nic_name = "mynic1"
  resource_group_name = "app-dev-rg"
  location = "central india"
}
module "lbassociation" {
  depends_on = [ module.lb, module.virtualmachene]
  source = "../../module/azurerm_lb_nic_association"
  nic_name = "mynic"
  resource_group_name = "app-dev-rg"
  lb_name = "appdevlb"
  backend_address_pool_name = "appdevbap"
}
module "lbassociation1" {
  depends_on = [ module.lb, module.virtualmachene1 ]
  source = "../../module/azurerm_lb_nic_association"
  nic_name = "mynic1"
  resource_group_name = "app-dev-rg"
  lb_name = "appdevlb"
  backend_address_pool_name = "appdevbap"
}