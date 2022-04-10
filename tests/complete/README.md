# Complete AWS EKS Addons Test

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.5 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_addons"></a> [eks\_addons](#module\_eks\_addons) | ../.. | n/a |
| <a name="module_eks_addons_disabled"></a> [eks\_addons\_disabled](#module\_eks\_addons\_disabled) | ../.. | n/a |
| <a name="module_eks_blueprint"></a> [eks\_blueprint](#module\_eks\_blueprint) | github.com/clowdhaus/terraform-aws-eks-blueprint | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agones_helm_release"></a> [agones\_helm\_release](#output\_agones\_helm\_release) | Agones helm chart release attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-eks-blueprint/blob/main/LICENSE).
