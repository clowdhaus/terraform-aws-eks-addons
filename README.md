# AWS EKS Addons Terraform module

Terraform module which creates AWS EKS Addon resources.

## Usage

```hcl
module "eks_addons" {
  source = "clowdhaus/eks-addons/aws"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Examples

See [`eks-blueprint-examples`](https://github.com/clowdhaus/eks-blueprint-examples/tree/main/examples) for working examples to reference.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.5 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_agones"></a> [agones](#module\_agones) | ./modules/_helm-release | n/a |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | ./modules/_helm-release | n/a |
| <a name="module_karpenter_irsa"></a> [karpenter\_irsa](#module\_karpenter\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 4.15.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agones"></a> [agones](#input\_agones) | Agones wrapper variable around Helm release configuration values | `any` | `{}` | no |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | The EKS cluster endpoint | `string` | `""` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The EKS cluster ID | `string` | `""` | no |
| <a name="input_cluster_oidc_provider_arn"></a> [cluster\_oidc\_provider\_arn](#input\_cluster\_oidc\_provider\_arn) | The OIDC provider ARN | `string` | `""` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects all resources) | `bool` | `true` | no |
| <a name="input_enable_agones"></a> [enable\_agones](#input\_enable\_agones) | Controls if Agones addon is be created | `bool` | `false` | no |
| <a name="input_enable_karpenter"></a> [enable\_karpenter](#input\_enable\_karpenter) | Controls if Karpenter addon is be created | `bool` | `false` | no |
| <a name="input_karpenter"></a> [karpenter](#input\_karpenter) | Karpenter wrapper variable around Helm release configuration values | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agones_helm_release"></a> [agones\_helm\_release](#output\_agones\_helm\_release) | Agones helm chart release attributes |
| <a name="output_karpenter_helm_release"></a> [karpenter\_helm\_release](#output\_karpenter\_helm\_release) | Karpenter helm chart release attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-eks-addons/blob/main/LICENSE).
