# Créer un groupe de ressources
resource "azurerm_resource_group" "resource_group_1" {
  name     = "resource-group-1"
  location = "West Europe"
}
