resource "vault_kv_secret_v2" "modelserving_token" {
  mount = var.secret_store_path
  name  = local.token_secret

  data_json = jsonencode({
    token = stackit_modelserving_token.main.token
  })
}
