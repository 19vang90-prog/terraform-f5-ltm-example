# Sanitized portfolio example - fake IPs/names only
terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
    }
  }
}

# Provider config - use lab endpoint and env vars for secrets
provider "bigip" {
  address  = var.bigip_address
  username = var.bigip_username
  password = var.bigip_password
}

# Health monitor - equivalent to healthcheck
resource "bigip_ltm_monitor" "app_http" {
  name     = "/Common/example_app_http"
  parent   = "/Common/http"
  interval = 10
  timeout  = 31
  send     = "GET /health \r\n"
}

# Pool for backend app servers
resource "bigip_ltm_pool" "app_pool" {
  name                = "/Common/example_app_pool"
  load_balancing_mode = "round-robin"
  monitors            = [bigip_ltm_monitor.app_http.name]
}

# Pool member - sanitized example node
resource "bigip_ltm_pool_attachment" "app_nodes" {
  pool = bigip_ltm_pool.app_pool.name
  node = "10.0.0.11:443"
}

# Virtual server / VIP for traffic distribution
resource "bigip_ltm_virtual_server" "app_vip" {
  name                       = "/Common/example_app_vs"
  destination                = "10.0.0.100"
  port                       = 443
  ip_protocol                = "tcp"
  pool                       = bigip_ltm_pool.app_pool.name
  source_address_translation = "automap"
}
