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

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-eks-addons/blob/main/LICENSE).
