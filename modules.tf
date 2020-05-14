/*
 * network modules
 */

module "bastion-hostname" {
  source           = "github.com/ronaldkonjer/terraform-hostname.git"
  hcount            = local.az_count
  fqdns            = aws_route53_record.bastion.*.fqdn
  addresses        = data.aws_eip.bastion.*.public_ip
  user             = var.bastion_user
  private_key_path = var.private_key_path
}

