# Configure the Terraform runtime requirements.
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.3"
    }
  }
}

# Define providers and their configuration parameters
provider "azurerm" {
  subscription_id = ""
  features {}
}

provider "cloudinit" {
  # Configuration options
}

# Define the Azure Resource Group
resource "azurerm_resource_group" "example" {
  name     = "marc0430-rg"
  location = "canadacentral"
}

# Define the Azure Kubernetes Cluster
resource "azurerm_kubernetes_cluster" "example" {
  name                = "marc0430-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_B2s"
    auto_scaling_enabled = true
    min_count           = 1
    max_count           = 3
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

# Output the Kubernetes config
output "kube_config" {
  value     = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}
