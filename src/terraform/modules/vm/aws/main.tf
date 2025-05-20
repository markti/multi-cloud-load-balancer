resource "aws_eip" "main" {
  instance = aws_instance.main.id
  tags     = var.tags
}

resource "aws_key_pair" "main" {
  key_name   = "${var.name}-ssh-key"
  public_key = var.ssh_public_key

  tags = var.tags
}

resource "aws_instance" "main" {
  ami                         = var.vm_image_id
  instance_type               = var.vm_size
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = var.tags
}
