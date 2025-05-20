resource "aws_resourcegroups_group" "main" {
  name = "${var.application_name}-${random_string.random_string.result}"

  resource_query {
    type = "TAG_FILTERS_1_0"
    query = jsonencode({
      ResourceTypeFilters = [
        "AWS::EC2::Instance"
      ]
      TagFilters = [
        {
          Key    = "Application"
          Values = [var.application_name]
        },
        {
          Key    = "Environment"
          Values = [random_string.random_string.result]
        }
      ]
    })
  }
}

data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.image_name}-${var.image_version}"]
  }

  owners = ["self"]
}

module "aws_stack" {
  source = "./modules/stack/aws"

  name            = "${var.application_name}-${random_string.random_string.result}"
  address_space   = "10.5.16.0/22"
  vm_image_id     = data.aws_ami.main.id
  vm_size         = "t2.micro"
  ssh_public_key  = tls_private_key.ssh_key.public_key_openssh
  ssh_private_key = tls_private_key.ssh_key.private_key_pem
  username        = var.username
  tags = {
    "ApplicationName" = var.application_name
    "Environment"     = random_string.random_string.result
  }

}
