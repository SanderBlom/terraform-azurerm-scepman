output "scepman_url" {
  value       = format("https://%s", local.default_hostname_primary)
  description = "SCEPman Url"
}

output "scepman_certificate_master_url" {
  value       = format("https://%s", local.default_hostname_cm)
  description = "SCEPman Certificate Master Url"
}

output "storage_account_id" {
  value       = azurerm_storage_account.storage.id
  description = "ID of the storage account used by the deployment."
}

output "storage_account_identity_principal_id" {
  value       = try(azurerm_storage_account.storage.identity[0].principal_id, null)
  description = "Principal ID of the storage account system-assigned managed identity when enabled."
}

output "storage_account_identity_tenant_id" {
  value       = try(azurerm_storage_account.storage.identity[0].tenant_id, null)
  description = "Tenant ID of the storage account system-assigned managed identity when enabled."
}
