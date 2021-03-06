/*
 * network provisioners
 */

resource "null_resource" "setup-bastion" {
  count    = 1
  triggers = {
    bastion_id  = element(aws_instance.bastion.*.id, count.index)
    auth_keys   = md5(local.authorized_keys)
    hostname_id = md5(join(",", module.bastion-hostname.resource_ids))
  }
  connection {
    type        = "ssh"
    host        = element(data.aws_eip.bastion.*.public_ip, count.index)
    user        = var.bastion_user
    private_key = local.private_key
  }
  provisioner "file" {
    content     = local.authorized_keys
    destination = ".ssh/authorized_keys"
  }
}

