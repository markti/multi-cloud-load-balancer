variable "name" {
  type = string
}
variable "address_space" {
  type = string
}
variable "vm_image_id" {
  type = string
}
variable "vm_size" {
  type = string
}
variable "ssh_public_key" {
  type = string
}
variable "ssh_private_key" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "username" {
  type = string
}
