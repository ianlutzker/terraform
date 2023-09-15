resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
 name = "${random_pet.prefix.id}-rg"
 location = "Central US"

 tags = {
   Environment = "Demo"
 }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "systempool"
    node_count      = 1
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  tags = {
    Environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user-pool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.default.id
  vm_size               = "Standard_B2s"
  node_count            = 1
  os_type               = Linux
  os_disk_size_gb       = 30

  tags = {
    Environment = "Demo"
  }
}
