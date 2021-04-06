# Classic VSI with Loadbalancer Autoscale behaviour

## Introduction

This solution adresses autoscale of group servers/VSIs attached to a IBM Cloud loadbalancer based on the incoming traffic.
The classic infrastructure provides the feature of scaling up group of VM instances based on the CPU, MEMORY and NETWORK usage but not on the incoming traffic. To be able to achieve this, solution using the sysdig-monitoring cloudfunctions and schematics services of IBM Cloud. sysdig-monitor provides the rich set of metrics and notification tools, cloud functions manages the schematics workspace and schematics workspace controls the autoscaling behavior.

This terroform module deploys a set of VSIs on classic infrastructure with a load balancer attached and a cloud function action to handle the autoscaling of VSIs. The module configures the sysdig service with alerts and notifications for the autoscale feature. This module scale the VSIs based on the Loadbalancer's `Numer of active connections` metric.


![alt text](https://github.com/Cloud-Schematics/classic-vsi-autoscaling-solution/blob/autoscale_sol_initial/autoscale-solution-diagram.png)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |


## Providers

| Name | Version |
|------|---------|
| ibm | >= 1.21.0 |
| sysdig | >= 0.5.7 |

## Modules
| Name | Description | GIT Repo |
|------|-------------|----------|
| `vms_and_lb` | Module responisble for creation of VSIs and Loadbalancer | `module_vms_and_loadbalancer`|
| `cloud_function` | Module responisble for cloud function action creation and configuration | `module_cloudfunction_autoscale_action` |
| `sysdig_monitoring_config` | Module responsbile for sysdig monitoring configurations | `module_sysdig_config` |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| iaas\_classic\_username|IAAS Classic user name | `string` | n/a | yes |
| iaas\_classic\_api\_key | IAAS Classic user API Key | `string` | n/a | yes |
| ssh\_key | name of the ssh key in classic infrastructure | `string` | n/a | yes |
| datacenter | name of the Datacenter | `string` | n/a | yes |
| lbaas\_name | lbaas instance name" | `string` | n/a | yes |
| instance\_count | Number of VSIs to be provisoned | `number` | n/a | yes |
| minimum\_vm\_count | The minimum number of VSIs to be maintained all the time | `number` | `3` | no |
| namespace | Name space where cloud function is defined | `string` | n/a | yes |
| action\_name | Cloud function action name | `string` | `"autoscaleaction"` | no |
| api\_key | IAM API Key of the ibmcloud user to perform schematics actions | `string` | n/a | yes |
| vm\_count | Default value of VSI count for the autoscaling | `number` | `0` | no |
| resource\_group\_name | Resource group under which SYSDIG is provisioned. | `string` | n/a | yes |
| instance\_name | SYSDIG instance name | `string` | n/a | yes |
| location| SYSDIG instance location | `string` | n/a | yes |
| scale\_up\_alert\_name | Alert name for sclaing up the VSIs | `string` | `"lb-load-scale-up-alert"` | no |
| scale\_down\_alert\_name | Alert name for scaling down the VSIs | `string` | `"lb-load-scale-down-alert"` | no |
| scale\_up\_alerts\_config | A list of scale up alert configurations | `list(map(string))` | n/a | yes |
| scaledown\_upper\_threshold | Number of active connections upper threshold for the scale down alert | `number` | `5`  | no |
| scaledown\_lower\_threshold | Number of active connections lower threshold for the scale down alert | `number` | `0`  | no |



## Outputs

| Name | Description |
|------|-------------|
| web\_server\_private\_ips | List of the private IP Addresses of the web servers |
| lbaas\_subnet | Load balancer subnet |
| lbaas\_hostname | Load balancer host name |
| health\_monitors| Health Monitors of the loadbalcer |
| sysdig\_dashboard\_url | Custom sysdig dashborad URL |

## Operator Quick start Guide

This section of the document enables the operator to configure the solution and verify the same.
The following steps are performed to setup the solution:
1. Create schematics workspace with solution
    ![plot](./images/workspace.png?raw=true])
2. Update the workspace variables 
    ![plot](./images/variables.png?raw=true])
3. Workspace plan-apply to setup the solution outputs from the workspace provide the following details:
    1. Load balancer hostname
    2. sysdig dash board URL to see the alerts and notifications
    ![plot](./images/workspace_outputs.png?raw=true])

The following steps are performed to verify the setup:
1. Open the custom sysdig dashboard created for the solution depecting the load balancer connection rate, active connection and cloud function activations as shown
    ![plot](./images/sysdig_dashboard.png?raw=true])
2. verify the cloud function creation
    ![plot](./images/cloudfunction.png?raw=true])

The following steps are performed to verify the functionality of the setup:
1. Increase the number of requests using soapUI or any other test tool
2. Observe the increase in the number of active connections and connection rate
    ![plot](./images/dashboard_connection_increase.png?raw=true])
3. Once the first threashold is reached, there will be a notification sent by sysdig alert to cloud function to increase the number of VMs
    ![plot](./images/cloudfunction_activation.png?raw=true])
4. Cloud function calls schematics API to modifiy workspace's vms count resulting in addition of VM isnstance attached to the loadbalancer

## Developer Quick starrt Guide

This section of the document enables the developers to enhance the solution.
Sysdig alerts configuration:
    Terraform provider for sysdig enables to add alerts configuration capabilities. See the documentaion here - [sysdig-docs](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/sysdig_monitor_alert_metric)

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.


