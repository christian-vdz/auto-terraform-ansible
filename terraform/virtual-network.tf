# Créer un réseau virtuel
resource "azurerm_virtual_network" "virtual_network_1" {
  name                = "vnet-1"
  resource_group_name = azurerm_resource_group.resource_group_1.name
  location            = azurerm_resource_group.resource_group_1.location
  address_space       = ["10.0.0.0/16", "fd00:db8:deca::/48"]
}

# Créer un sous réseau dans le réseau virtuel
resource "azurerm_subnet" "subnet_1" {
  name                 = "vnet-1_internal"
  resource_group_name  = azurerm_resource_group.resource_group_1.name
  virtual_network_name = azurerm_virtual_network.virtual_network_1.name
  address_prefixes     = ["10.0.1.0/24", "fd00:db8:deca:daed::/64"]
}
