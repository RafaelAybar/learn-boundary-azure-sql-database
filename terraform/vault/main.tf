# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = ">=1.0.0"
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "~>1.1.15"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~>4.3"
    }
  }
}

provider "vault" {
  address = local.vault_url
}

provider "boundary" {
  addr             = local.boundary_url
  tls_insecure     = true
  recovery_kms_hcl = <<EOT
kms "azurekeyvault" {
    purpose       = "recovery"
    tenant_id     = "${local.recovery_service_principal_tenant_id}"
    client_id     = "${local.recovery_service_principal_client_id}"
    client_secret = "${local.recovery_service_principal_client_secret}"
    vault_name    = "${local.vault_name}"
    key_name      = "recovery"
}
EOT
}