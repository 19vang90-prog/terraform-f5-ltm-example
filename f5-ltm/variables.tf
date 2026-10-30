# Input variables - no secret defaults
variable "bigip_address" {
  description = "Management IP/hostname for BIG-IP - lab only"
  type        = string
}

variable "bigip_username" {
  description = "BIG-IP username"
  type        = string
}

variable "bigip_password" {
  description = "BIG-IP password - pass via TF_VAR_ env var"
  type        = string
  sensitive   = true
}