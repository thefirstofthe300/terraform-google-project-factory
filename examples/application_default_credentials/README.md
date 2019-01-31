# Application Default Credentials

This example illustrates how to use the Project Factory with [Application
Default Credentials]. Application default credentials can be provided by
setting the `APPLICATION_DEFAULT_CREDENTIALS` environment variable to the path
of a service account JSON file, or by running Terraform on a GCE instance with
a service account attached.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| billing\_account | The ID of the billing account to associate this project with | string | - | yes |
| organization\_id | The organization id for the associated services | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| domain | The organization's domain |
| project\_id | The ID of the created project |

[^]: (autogen_docs_end)

[Application Default Credentials]: https://cloud.google.com/docs/authentication/production