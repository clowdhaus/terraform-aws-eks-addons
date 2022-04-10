################################################################################
# Agones
################################################################################

module "agones" {
  source = "./modules/_helm-release"

  create = var.create && var.enable_agones

  config = {
    name        = try(var.agones_config.name, "agones")
    description = try(var.agones_config.description, "Agones Gaming Server Helm Chart deployment configuration")
    namespace   = try(var.agones_config.namespace, "agones-system")
    chart       = try(var.agones_config.chart, "agones")
    repository  = try(var.agones_config.repository, "https://agones.dev/chart/stable")
    values      = try(var.agones_config.values, [file("${path.module}/values/agones.yaml")])
  }
}

resource "aws_security_group_rule" "agones_sg_ingress_rule" {
  count = var.enable_agones ? 1 : 0

  type              = "ingress"
  from_port         = 7000
  to_port           = 8000
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"] # TODO
  ipv6_cidr_blocks  = ["::/0"]      # TODO
  security_group_id = var.node_security_group_id
}
