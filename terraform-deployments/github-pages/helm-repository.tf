data "aws_route53_zone" "nategramer" {
  name         = "nategramer.com."
}

resource "aws_route53_record" "helm" {
  zone_id = data.aws_route53_zone.nategramer.zone_id
  name    = "helm.nategramer.com"
  type    = "CNAME"
  ttl     = 300
  records = ["n8tg.github.io"]
}