provider "aws" {
  region = local.region
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

locals {
  region = "us-east-1"
  name   = "eks-addons-test-${replace(basename(path.cwd), "_", "-")}"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/clowdhaus/terraform-aws-eks-addons"
  }
}

################################################################################
# EKS Addons Module
################################################################################

module "eks_addons_disabled" {
  source = "../.."

  create = false
}

module "eks_addons" {
  source = "../.."

  cluster_id                = module.eks.cluster_id
  cluster_endpoint          = module.eks.cluster_endpoint
  cluster_oidc_provider_arn = module.eks.oidc_provider_arn

  # Agones
  enable_agones = false # 1.22 support issue https://github.com/googleforgames/agones/issues/2494

  # Karpenter
  enable_karpenter = true
  karpenter = {
    node_iam_role_arns = [module.eks.eks_managed_node_groups["bottlerocket"].iam_role_arn]
    node_iam_role_name = module.eks.eks_managed_node_groups["bottlerocket"].iam_role_name
  }
}

################################################################################
# Supporting Resources
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name                    = local.name
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  node_security_group_additional_rules = {
    # Control plane invoke Karpenter webhook
    ingress_karpenter_webhook_tcp = {
      description                   = "Control plane invoke Karpenter webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_group_defaults = {
    instance_types        = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
    create_security_group = false
  }

  eks_managed_node_groups = {
    bottlerocket = {
      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      min_size     = 1
      max_size     = 7
      desired_size = 1

      update_config = {
        max_unavailable_percentage = 75
      }

      iam_role_additional_policies = [
        # Required by Karpenter
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
  }

  tags = merge(local.tags, {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = local.name
  })
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = "10.99.0.0/18"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets  = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  private_subnets = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]

  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = false

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = local.name
  }

  tags = local.tags
}


################################################################################
# Karpenter Provisioner test

# 1) Scale up
# kubectl scale deployment inflate --replicas 5
# kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter -c controller

# 2) Scale down
# kubectl delete deployment inflate
################################################################################

resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
  apiVersion: karpenter.sh/v1alpha5
  kind: Provisioner
  metadata:
    name: default
  spec:
    requirements:
      - key: karpenter.sh/capacity-type
        operator: In
        values: ["spot"]
    limits:
      resources:
        cpu: 1000
    provider:
      subnetSelector:
        karpenter.sh/discovery: ${local.name}
      securityGroupSelector:
        karpenter.sh/discovery: ${local.name}
      tags:
        karpenter.sh/discovery: ${local.name}
    ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [
    module.eks_addons
  ]
}

resource "kubectl_manifest" "karpenter_example_deployment" {
  yaml_body = <<-YAML
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: inflate
  spec:
    replicas: 0
    selector:
      matchLabels:
        app: inflate
    template:
      metadata:
        labels:
          app: inflate
      spec:
        terminationGracePeriodSeconds: 0
        containers:
          - name: inflate
            image: public.ecr.aws/eks-distro/kubernetes/pause:3.2
            resources:
              requests:
                cpu: 1
  YAML

  depends_on = [
    module.eks_addons
  ]
}
