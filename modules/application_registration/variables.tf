variable "display_name" {
  type        = string
  description = "DisplayName of the AppReg"
}

variable "description" {
  type        = string
  description = "Description of the AppReg"
  default     = null
}


variable "sign_in_audience" {
  type        = string
  description = "SignIn Audience of the AppReg"
  default     = "AzureADMyOrg"
  validation {
    condition     = contains(["AzureADMyOrg", "AzureADMultipleOrgs", "AzureADandPersonalMicrosoftAccount", "PersonalMicrosoftAccount"], var.sign_in_audience)
    error_message = "The SignIn Audience must be one of `AzureADMyOrg`, `AzureADMultipleOrgs`, `AzureADandPersonalMicrosoftAccount`, `PersonalMicrosoftAccount`"
  }
}

variable "urls" {
  type = object({
    homepage          = optional(string)
    logout            = optional(string)
    marketing         = optional(string)
    privacy_statement = optional(string)
    support           = optional(string)
    terms_of_service  = optional(string)
  })
  description = "URLs for the AppReg"
  default = {
  }
}

variable "implicit_access_token_issuance_enabled" {
  type        = bool
  description = "Whether this web application can request an access token using OAuth implicit flow."
  default     = null
}

variable "implicit_id_token_issuance_enabled" {
  type        = bool
  description = "Whether this web application can request an ID token using OAuth implicit flow."
  default     = null
}

variable "group_membership_claims" {
  type        = set(string)
  description = "Configures the groups claim issued in a user or OAuth access token that the app expects."
  default     = ["ApplicationGroup"]
}


######

variable "app_roles" {
  type = set(object({
    allowed_member_types = optional(set(string), ["Application"])
    description          = string
    display_name         = string
    value                = string
  }))
  default     = []
  description = "Set of AppRoles to create for the application."
}

variable "permission_scopes" {
  type = set(object({
    value                      = string
    type                       = optional(string, "Admin")
    admin_consent_description  = string
    admin_consent_display_name = string
    user_consent_description   = optional(string, null)
    user_consent_display_name  = optional(string, null)
  }))
  default     = []
  description = "Set of Oauth2 PermissionsScopes provided by the App. If user_consent is not set it will default to the admin_consent values."
}
