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

output "scepman_application" {
  value = {
    azuread_application = {
      id        = one(module.appreg_scepman[*].id)
      object_id = one(module.appreg_scepman[*].object_id)
      client_id = one(module.appreg_scepman[*].client_id)
      api_scope = local.scepman_api_scope
    }
    service_principal = {
      id           = one(azuread_service_principal.scepman[*].id)
      display_name = one(azuread_service_principal.scepman[*].display_name)
      object_id    = one(azuread_service_principal.scepman[*].object_id)
    }
  }
  description = "Information about the Application and Service Principal for the SCEPman API"
}
