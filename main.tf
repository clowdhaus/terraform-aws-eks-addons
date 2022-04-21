################################################################################
# Agones
################################################################################

module "agones" {
  source = "./modules/_helm-release"

  # TODO - this addon creates a lot of networking resources which could cause lifecycle conflicts.
  # 1. Should it be supported here or as a 3rd party addon thats external
  # 2. If supported here, do we need to depend on VPC to ensure correct ordering?

  create = var.create && var.enable_agones

  release = {
    name        = try(var.agones.name, "agones")
    description = try(var.agones.description, "Agones Gaming Server Helm Chart deployment configuration")
    namespace   = try(var.agones.namespace, "agones-system")
    chart       = try(var.agones.chart, "agones")
    repository  = try(var.agones.repository, "https://agones.dev/chart/stable")
    values      = try(var.agones.values, [file("${path.module}/values/agones.yaml")])
  }
}

################################################################################
# Karpenter
################################################################################

locals {
  karpenter_namespace       = try(var.karpenter.release.namespace, "karpenter")
  karpenter_service_account = try(var.karpenter.release.service_account, "karpenter")
}

module "karpenter" {
  source = "./modules/_helm-release"

  create = var.create && var.enable_karpenter

  release = {
    name        = try(var.karpenter.name, "karpenter")
    description = try(var.karpenter.description, "Karpenter, an open-source node provisioning project")
    namespace   = local.karpenter_namespace
    chart       = try(var.karpenter.chart, "karpenter")
    repository  = try(var.karpenter.repository, "https://charts.karpenter.sh")
    set = concat([
      {
        name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
        value = try(var.karpenter.irsa_iam_role_arn, module.karpenter_irsa.iam_role_arn)
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
        value = try(var.karpenter.iam_instance_profile, aws_iam_instance_profile.karpenter[0].name, "")
      }
    ], try(var.karpenter.release.set, []))
  }
}

module "karpenter_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "4.15.1"

  create_role = var.create && var.enable_karpenter && try(var.karpenter.create_irsa_role, true)

  role_name                          = try(var.karpenter.irsa_role_name, "karpenter-controller-${var.cluster_id}")
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_id         = var.cluster_id
  karpenter_controller_node_iam_role_arns = try(var.karpenter.node_iam_role_arns, [])

  oidc_providers = {
    ex = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = ["${local.karpenter_namespace}:${local.karpenter_service_account}"]
    }
  }
}

resource "aws_iam_instance_profile" "karpenter" {
  count = var.create && var.enable_karpenter && try(var.karpenter.create_instance_profile, true) ? 1 : 0

  name = try(var.karpenter.instance_profile_name, "KarpenterNodeInstanceProfile-${var.cluster_id}")
  role = var.karpenter.node_iam_role_name
}
