output "azure_ip_address" {
  value = module.azure_stack.public_ip_address
}
output "aws_ip_address" {
  value = module.aws_stack.public_ip_address
}
output "gcp_ip_address" {
  value = module.gcp_stack.public_ip_address
  #value = ""
}
output "private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
output "private_key_openssh" {
  value     = tls_private_key.ssh_key.private_key_openssh
  sensitive = true
}
