variable "project_name" {
  description = "Short project identifier used in resource names."
  type        = string
  default     = "portfolio"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "resource_group_name" {
  description = "Azure Resource Group name."
  type        = string
  default     = "rg-portfolio-appservice-dev"
}

variable "location" {
  description = "Azure region. VNet and App Service must be in the same region."
  type        = string
  default     = "westeurope"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = string
  default     = "10.20.0.0/16"
}

variable "integration_subnet_prefix" {
  description = "Dedicated App Service VNet Integration subnet. Use /26 or larger for scale headroom."
  type        = string
  default     = "10.20.1.0/26"
}

variable "web_app_name" {
  description = "Globally unique Linux Web App name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,60}$", var.web_app_name))
    error_message = "Use 2-60 lowercase letters, numbers, or hyphens."
  }
}

variable "app_service_sku" {
  description = "App Service Plan SKU. B1 supports VNet Integration and has a cost."
  type        = string
  default     = "B1"
}

variable "tags" {
  description = "Common Azure resource tags."
  type        = map(string)
  default = {
    environment = "dev"
    project     = "azure-appservice-vnet-nsg"
    managed_by  = "terraform"
    portfolio   = "true"
  }
}
