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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_agones"></a> [agones](#module\_agones) | ./modules/_helm-release | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group_rule.agones_sg_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agones_config"></a> [agones\_config](#input\_agones\_config) | Agones wrapper variable around Helm release configuration values | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects all resources) | `bool` | `true` | no |
| <a name="input_enable_agones"></a> [enable\_agones](#input\_enable\_agones) | Controls if Agones addon should be created | `bool` | `false` | no |
| <a name="input_node_security_group_id"></a> [node\_security\_group\_id](#input\_node\_security\_group\_id) | The node group security group ID. Used to provided addtional security group rules when required by addon enabled | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agones_helm_release"></a> [agones\_helm\_release](#output\_agones\_helm\_release) | Agones helm chart release attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-eks-addons/blob/main/LICENSE).
