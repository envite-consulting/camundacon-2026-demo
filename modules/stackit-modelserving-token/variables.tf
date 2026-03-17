variable "project_id" {
  description = "STACKIT project ID under which the model serving token is created."
  type        = string
}

variable "name" {
  description = "Human-readable name of the STACKIT model serving token resource (e.g. 'camunda-prod')."
  type        = string
}

variable "rotation_days" {
  description = "Interval in days after which the model serving token is automatically rotated."
  type        = number
}

variable "secret_store_path" {
  description = "Name of the ESO ClusterSecretStore used to resolve ExternalSecret references within this module."
  type        = string
}
