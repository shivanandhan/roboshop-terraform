provider "vault" {
  address = "https://172.31.32.24:8200"
  token = var.vault_token
  skip_tls_verify = true
}

variable "vault_token"{}

data "vault_kv_secret_v2" "example" {

  name  = "my_credentials"
  mount = "test"
}