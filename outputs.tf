output "web_app_url" {
  description = "HTTPS URL of the Linux Web App."
  value = "https://${azurerm_linux_web_app.this.default_hostname}"
}
output "integration_subnet_id" { description = "Subnet used for App Service outbound VNet Integration." value = azurerm_subnet.app_integration.id }
output "managed_identity_principal_id" { description = "System-assigned managed identity principal ID." value = azurerm_linux_web_app.this.identity[0].principal_id }
