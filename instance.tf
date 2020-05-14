/*
 * bastion
 */

resource "aws_instance" "bastion" {
  count         = 1
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type
  vpc_security_group_ids = [
    aws_security_group.bastion.id,
    aws_security_group.internal.id,
  ]
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags = {
    Name = "${var.name}-bastion${format("%02d", count.index + 1)}"
  }
}

resource "aws_eip_association" "bastion" {
  count         = 1
  allocation_id = element(var.bastion_eip_ids, count.index)
  instance_id   = element(aws_instance.bastion.*.id, count.index)
}

