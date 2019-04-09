provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.24.0"
}

data "azurerm_resource_group" "main" {
  name     = "test-resources"
}

data "azurerm_public_ip" {
  name                = "PublicIPForLB"
  location            = "West US"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  allocation_method   = "Static"
}

data "azurerm_lb" "main" {
  name                = "TestLoadBalancer"
  location            = "West US"
  resource_group_name = "${data.azurerm_resource_group.main.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${data.azurerm_public_ip.main.id}"
  }
}
resource "azurerm_lb_rule" "test" {
  resource_group_name            = "${azurerm_resource_group.main.name}"
  loadbalancer_id                = "${azurerm_lb.main.id}"
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}
