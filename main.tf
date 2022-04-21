################################################################################
# Agones
################################################################################

module "agones" {
  source = "./modules/_helm-release"

  # TODO - this addon creates a lot of networking resources which could cause lifecycle conflicts.
  # 1. Should it be supported here or as a 3rd party addon thats external
  # 2. If supported here, do we need to depend on VPC to ensure correct ordering?

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

################################################################################
# Karpenter
################################################################################

locals {
  karpenter_namespace       = try(var.karpenter_config.namespace.name, "karpenter")
  karpenter_service_account = try(var.karpenter_config.service_account.name, "karpenter")
}

module "karpenter" {
  source = "./modules/_helm-release"

  create = var.create && var.enable_karpenter

  config = {
    name        = try(var.karpenter_config.name, "karpenter")
    description = try(var.karpenter_config.description, "Karpenter, an open-source node provisioning project")
    namespace = try(var.karpenter_config.namespace, {
      name = local.karpenter_namespace
    })
    chart      = try(var.karpenter_config.chart, "karpenter")
    repository = try(var.karpenter_config.repository, "https://charts.karpenter.sh")
    set = try(var.karpenter_config.set, [
      {
        name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
        value = module.karpenter_irsa.iam_role_arn
      },
      {
        name  = "clusterName"
        value = var.cluster_id
      },
      {
        name  = "clusterEndpoint"
        value = var.cluster_endpoint
      },
      {
        name  = "aws.defaultInstanceProfile"
        value = aws_iam_instance_profile.karpenter[0].name
      }
    ], [])
  }
}

module "karpenter_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "4.15.1"

  create_role = var.create && var.enable_karpenter && try(var.karpenter_config.create_irsa_role, true)

  role_name                          = try(var.karpenter_config.irsa_role_name, "karpenter-controller-${var.cluster_id}")
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_id         = var.cluster_id
  karpenter_controller_node_iam_role_arns = try(var.karpenter_config.node_iam_role_arns, [])

  oidc_providers = {
    ex = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = ["${local.karpenter_namespace}:${local.karpenter_service_account}"]
    }
  }
}

resource "aws_iam_instance_profile" "karpenter" {
  count = var.create && var.enable_karpenter && try(var.karpenter_config.create_instance_profile, true) ? 1 : 0

  name = try(var.karpenter_config.instance_profile_name, "KarpenterNodeInstanceProfile-${var.cluster_id}")
  role = var.karpenter_config.node_iam_role_name
}
