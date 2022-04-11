# Internal Helm Release module

Internal Terraform module which creates a Helm release.

## Usage

```hcl
module "_helm_release" {
  source = "./modules/_helm-release"

}
```

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
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.5 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config"></a> [config](#input\_config) | Wrapper variable around Helm release configuration values to allow upstream use of module to define only one variable per release | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects all resources) | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_version"></a> [app\_version](#output\_app\_version) | The version number of the application being deployed |
| <a name="output_chart"></a> [chart](#output\_chart) | The name of the chart |
| <a name="output_name"></a> [name](#output\_name) | Name is the name of the release |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Namespace is the kubernetes namespace of the release |
| <a name="output_revision"></a> [revision](#output\_revision) | Version is an int32 which represents the version of the release |
| <a name="output_values"></a> [values](#output\_values) | The compounded values from `values` and `set*` attributes |
| <a name="output_version"></a> [version](#output\_version) | A SemVer 2 conformant version string of the chart |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-eks-addons/blob/main/LICENSE).
