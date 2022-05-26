# resource group creation for aks
resource "azurerm_resource_group" "rsg_name" {
  name = var.rsg_name
  location = var.location
  
}

# cretig the data source to fetch the ssh key and client secrets 

data "azurerm_key_vault" "key_vault"{
  name                  = var.key_vault_name
  resource_group_name   = var.key_vault_rsg_name
}

data "azurerm_key_vault_secret" "ssh_key"{
  name         = var.ssh_key
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "client_id" {
  name         = var.client_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "client_secret" {
  name         = var.client_secret 
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

# creating the network security group for aks
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.rsg_name.name
}

# AKS cluster creation 

locals {
  tags = {
    env = "dev"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                  = var.aks_name
  location              = azurerm_resource_group.rsg_name.location
  resource_group_name   = azurerm_resource_group.rsg_name.name
  dns_prefix            = var.dnsPrefix

  linux_profile {
    admin_username = "epam_aks"
    ssh_key {
      key_data = data.azurerm_key_vault_secret.ssh_key.value
    }
  }
  
  default_node_pool {
    name = "default"
    node_count = var.node_count
    vm_size = var.vm_size
  }

  service_principal {
    client_id     = data.azurerm_key_vault_secret.client_id.value
    client_secret = data.azurerm_key_vault_secret.client_secret.value
    }
/*
  identity {
    type = "SystemAssigned"
  }
*/
  network_profile {
        load_balancer_sku = "standard"
        network_plugin = "azure"
    }

  tags = local.tags
}

/*
resource "azurerm_kubernetes_cluster_node_pool" "pool1" {
  name                  = "userpool1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = "Standard_D2_v2"
  node_count            = 1
  enable_auto_scaling   = true
  os_disk_size_gb       = 30
  max_count             = var.max_nodes
  min_count             = var.min_nodes
  tags                  = local.tags
}
*/

# intigrating the ACR with AKS
data "azuread_service_principal" "aks_principal" {
  application_id = data.azurerm_key_vault_secret.client_id.value
}
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = "Global"
}
resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azuread_service_principal.aks_principal.id
  skip_service_principal_aad_check = true
}
