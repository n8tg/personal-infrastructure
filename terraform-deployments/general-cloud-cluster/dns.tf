data "aws_route53_zone" "nategramer" {
  name         = "nategramer.com."
}

data "kubernetes_service" "ingress" {
  depends_on = [module.base_apps]
  metadata {
    name = "istio-ingressgateway"
    namespace = "istio-ingressgateway"
  }
}

resource "aws_route53_record" "gke" {
  depends_on = [module.base_apps]
  zone_id = data.aws_route53_zone.nategramer.zone_id
  name    = "*.gke.nategramer.com"
  type    = "A"
  ttl     = 300
  records = [data.kubernetes_service.ingress.status[0].load_balancer[0].ingress[0].ip]
}

resource "aws_route53_record" "gke_root" {
  depends_on = [module.base_apps]
  zone_id = data.aws_route53_zone.nategramer.zone_id
  name    = "gke.nategramer.com"
  type    = "A"
  ttl     = 300
  records = [data.kubernetes_service.ingress.status[0].load_balancer[0].ingress[0].ip]
}