# sysdig-conf

This module configures the sysdig-monitoring with alerts creation and notifiaction channel creation for loadbalancer metrics.


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |


## Providers

| Name | Version |
|------|---------|
| sysdig | >= 0.5.7 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource\_group\_name | Resource group under which SYSDIG is provisioned. | `string` | n/a | yes |
| instance\_name | SYSDIG instance name | `string` | n/a | yes |
| location| SYSDIG instanc location | `string` | n/a | yes |
| scale\_up\_alert\_name | Alert name for sclaing up the VSIs | `string` | n/a | yes |
| scale\_down\_alert\_name | Alert name for scaling down the VSIs | `string` | n/a | yes |
| scaledown\_upper\_threshold | Number of active connections upper threshold for the scale down alert | `number` | n/a | yes |
| scaledown\_lower\_threshold | Number of active connections lower threshold for the scale down alert | `number` | n/a | yes |
|notification\_channel\_webhook\_url | Notification channel URL | `string` | n/a | yes |
|scale\_up\_alerts\_config | A list of scale up alert configurations | `list(map(string))` | n/a | yes |

## Outputs
| Name | Description|
|------|------------|
|sysdig\_dashboard\_url| Custom SYSDIG dashboard URL created for autoscale feature |


## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.