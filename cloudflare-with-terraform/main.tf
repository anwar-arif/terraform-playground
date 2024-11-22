terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_workers_kv_namespace" "main" {
  account_id = var.cloudflare_account_id
  title = "MY_KV_NAMESPACE"
}

resource "cloudflare_workers_script" "main" {
  account_id = var.cloudflare_account_id
  name       = var.worker_name
  content    = file("${path.module}/worker.js")

  kv_namespace_binding {
    name         = "MY_KV_NAMESPACE"
    namespace_id = cloudflare_workers_kv_namespace.main.id
  }
}
