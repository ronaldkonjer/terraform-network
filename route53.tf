/*
 * network route53 resources
 */

resource "aws_route53_zone" "dns" {
  name = var.dns_domain
  vpc {
    vpc_id = aws_vpc.vpc.id
  }
  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_record" "bastion" {
  count   = 1
  zone_id = aws_route53_zone.dns.*.zone_id[0]
  name    = aws_instance.bastion[count.index].tags["Name"]
  type    = "A"
  ttl     = var.dns_ttl
  records = [
    element(aws_instance.bastion.*.private_ip, count.index)
  ]
}

