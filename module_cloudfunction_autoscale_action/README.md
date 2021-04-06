# CF-Autoscale

This module deploys a web enabled IBM cloud function action. The Action is packaged with python code to interact with IBM-Cloud Schemtics workspace.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |


## Providers

| Name | Version |
|------|---------|
| ibm | >= 1.18.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| minimum\_vm\_count | The minimum number of VSIs to be maintained all the time | `number` | n/a | yes |
| namespace | Name space where cloud function is defined | `string` | n/a | yes |
| action\_name | Cloud function action name | `string` | n/a | yes |
| api\_key | IAM API Key of the ibmcloud user to perform schematics actions | `string` | n/a | yes |
| vm\_count | Default value of VSI count for the autoscaling | `number` | n/a | yes |
| workspace\_id | Target workspace ID | `string` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| cloud\_function\_target\_endpoint\_url | Cloud function action public target endpoint URL |

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

