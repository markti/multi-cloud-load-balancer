variable "azure_region" {
  type    = string
  default = "westus3"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "gcp_region" {
  type    = string
  default = "us-central1"
}
variable "gcp_organization" {
  type = string
}
variable "application_name" {
  type    = string
  default = "mcr"
}
variable "image_name" {
  type = string
}
variable "image_version" {
  type = string
}
variable "username" {
  type = string
}
