output "credentials_kv_secret" {
  description = "Name of the KV secret for the Modelserving Token credentials"
  value       = vault_kv_secret_v2.modelserving_token.name
}
