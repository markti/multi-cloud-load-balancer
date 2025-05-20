resource "random_string" "random_string" {
  length  = 8
  upper   = false
  special = false
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}
