provider "aws" {
  region = local.region
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprint.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprint.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks_blueprint.cluster_id]
    }
  }
}

provider "kubernetes" {
  host                   = module.eks_blueprint.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprint.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_blueprint.cluster_id]
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

  node_security_group_id = module.eks_blueprint.node_security_group_id

  enable_agones = false # 1.22 support issue https://github.com/googleforgames/agones/issues/2494

}

################################################################################
# Supporting Resources
################################################################################

module "eks_blueprint" {
  # tflint-ignore: terraform_module_pinned_source
  source = "git@github.com:clowdhaus/terraform-aws-eks-blueprint.git"

  name = local.name

  cluster_version                 = "1.22"
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

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

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "enabled"
      }
    }
  }

  # Disable managed service for Prometheus and Grafana for now
  create_prometheus = false
  create_grafana    = false

  tags = local.tags
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
  map_public_ip_on_launch = false

  tags = local.tags
}
