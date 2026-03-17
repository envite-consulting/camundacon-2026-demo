locals {
  token_secret = "modelserving-token"
}

resource "time_rotating" "main" {
  rotation_days = var.rotation_days
}

resource "stackit_modelserving_token" "main" {
  project_id = var.project_id
  name       = var.name

  rotate_when_changed = {
    rotation = time_rotating.main.id
  }
}
