resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "mlflow"
  type    = "CNAME"
  ttl     = 300
  records = [data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.hostname]
}
