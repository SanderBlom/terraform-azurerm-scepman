resource "azuread_application_registration" "this" {
  display_name                   = var.display_name
  description                    = var.description
  sign_in_audience               = var.sign_in_audience
  requested_access_token_version = 2

  implicit_access_token_issuance_enabled = var.implicit_access_token_issuance_enabled
  implicit_id_token_issuance_enabled     = var.implicit_id_token_issuance_enabled
  group_membership_claims                = var.group_membership_claims

  homepage_url          = var.urls.homepage
  logout_url            = var.urls.logout
  marketing_url         = var.urls.marketing
  privacy_statement_url = var.urls.privacy_statement
  support_url           = var.urls.support
  terms_of_service_url  = var.urls.terms_of_service
}

resource "random_uuid" "app_roles" {
  for_each = local.base_app_role_map
}

resource "azuread_application_app_role" "this" {
  for_each = local.base_app_role_map

  application_id = azuread_application_registration.this.id
  role_id        = random_uuid.app_roles[each.key].id

  allowed_member_types = each.value.allowed_member_types
  description          = each.value.description
  display_name         = each.value.display_name
  value                = each.value.value
}

resource "random_uuid" "oauth2_permission_scopes" {
  for_each = local.base_permission_scope_map
}

resource "azuread_application_permission_scope" "this" {
  for_each = local.base_permission_scope_map

  application_id = azuread_application_registration.this.id
  scope_id       = random_uuid.oauth2_permission_scopes[each.key].id
  value          = each.value.value
  type           = each.value.type


  admin_consent_description  = each.value.admin_consent_description
  admin_consent_display_name = each.value.admin_consent_display_name
  user_consent_description   = each.value.user_consent_description
  user_consent_display_name  = each.value.user_consent_display_name
}

resource "azuread_application_identifier_uri" "example" {
  application_id = azuread_application_registration.this.id
  identifier_uri = "api://${azuread_application_registration.this.client_id}"
}

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}
