locals {
  base_app_role_map = {
    for r in var.app_roles : r.value => {
      allowed_member_types = try(r.allowed_member_types, ["Application"])
      description          = r.description
      display_name         = r.display_name
      value                = r.value
    }
  }

  base_permission_scope_map = {
    for r in var.permission_scopes : r.value => {
      admin_consent_description  = r.admin_consent_description
      admin_consent_display_name = r.admin_consent_display_name
      user_consent_display_name  = try(r.user_consent_description, r.admin_consent_display_name)
      user_consent_description   = try(r.user_consent_display_name, r.admin_consent_description)
      type                       = try(r.type, "Admin")
      value                      = r.value
    }
  }
}
