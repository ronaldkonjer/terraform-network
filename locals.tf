/*
 * network local variables
 */

locals {
  vpc_cidr_elements        = [split("/", var.vpc_cidr)]
  vpc_cidr_prefix          = split("/", var.vpc_cidr)[1]
  az_count                  = 3
#  az_count                 = length(var.availability_zones)
  min_prefix               = local.az_count == 1 ? 1 : local.az_count == 2 ? 2 : local.az_count <= 4 ? 3 : local.az_count <= 8 ? 4 : 5 + local.vpc_cidr_prefix
  public_cidr_prefix       = var.public_cidr_prefix == -1 ? local.min_prefix : var.public_cidr_prefix
  private_cidr_prefix      = var.private_cidr_prefix == -1 ? local.min_prefix : var.private_cidr_prefix
  public_subnet_increment  = local.public_cidr_prefix - local.min_prefix //24 - 3 = 21
  private_subnet_increment = local.private_cidr_prefix - local.min_prefix //24 - 3 = 21
  private_subnet_offset    = local.private_cidr_prefix - local.vpc_cidr_prefix - 1 // 24 - 16 - 1 = 7
  private_key              = file(var.private_key_path)
  authorized_keys          = file(var.authorized_keys_path)
}

data "aws_eip" "bastion" {
  count = local.az_count
  id    = element(var.bastion_eip_ids, count.index)
  //id    = var.bastion_eip_ids[count.index]
}

