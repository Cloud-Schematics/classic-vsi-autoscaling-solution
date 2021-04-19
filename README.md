# Autoscale the Classic virtual servers VSI on IBM Cloud based on spike in user load

You can use a simple terraform template (or module) - to provision a group of Virtual Servers (VSI or VM instance) on the IBM Cloud classic infrastructure, with a Load Balancer that can route the incoming traffic to the VM. And, run your application on these VMs.

![plot](./images/classic-vsi.png?raw=true])

Currently, IBM Cloud classic infrastructure supports the auto-scale feature that can automatically scale the virtual servers up or down, based on business demands. Where, the business demands are defined using a schedule-based policy and/or resource-based policy on the VM usage metrics. The resource-based policy is defined based on the VM usage metrics (such as, average inbound traffic, average CPU usage, average memory usage, etc.).

However, if you wish to auto-scale the VMs based on the Application usage metrics, that can be monitored at the Load Balancer (instead of the VM metrics) – then you have to extend the terraform template using the auto-scale solution components; as described in this document.

## Introduction

This solution extends the simple terraform template - used to provision a group of Virtual Servers and a Load Balancer on the IBM Cloud classic infrastructure. The extension implements the following monitor-analyze-plan-actuate feedback loop, to auto-scale the VM groups based on application usage metrics:

- Monitor – using the IBM Cloud Monitoring service, based on Sysdig, that collects the VM &amp; Load Balancer metrics; defines up/down alerts based on the thresholds in the application or load-balancer metrics.
- Analyse/plan – using the IBM Cloud Function services, based on OpenWhisk, used to react to the up/down alerts from the Monitoring service; analyze the current state of the VM auto-scale group; and initiates the scale-up or scale-down action for the VM group.
- Actuator – using the IBM Cloud Schematics, based on Terraform, to provision/de-provision/re-configure the VMs in the VM group – to effect the change in the IBM Cloud Infrastructure.

This monitor-analyze-plan-actuate feedback loop is run in an autonomous mode, with simple tuning parameters.

As illustrated in the following figure, the auto-scale solution can be described in two parts:

- Part 1: Initialization – using the auto-scale solution template (in this repository)

1. Provision the VM/VSI &amp; Load Balancer with an initial workspace configuration settings
2. Provision the Cloud Function services, configure it with the Trigger and Action that will analyze the current state of the VM auto-scale group to initiates the scale-up or scale-down of the VM group.
3. Provision the Monitoring service (or Sysdig), configure it with threshold-based alerts for the Load Balancer metrics, use a channel to send the up/down alert to Cloud Function

- Part 2: Steady-state operations

1. The Monitoring service (Sysdig), monitors the Load Balancer metrics [eg. Number of Active Connection] , and raise the threshold-based alerts
2. The Monitoring service, raise an up/down alert, which is received by the Cloud Function trigger, to run the Action (a python code)
3. The Cloud Function action, reads the current state of the VM group, analyses the alerts to refine the workspace configuration settings in Schematics - to scale-up or scale-down the VM group
4. The Schematics uses the refined workspace configuration setting to actuate the change in the VM group (provision / deprovision VMs).

![plot](./images/autoscale-solution-diagram.png?raw=true])


### Requirements

| **Name** | **Version** |
| --- | --- |
| terraform |  >= 0.13 |

### Providers

| **Name** | **Version** |
| --- | --- |
| ibm |  >= 1.21.0 |
| sysdig |  >= 0.5.7 |

### Modules

| **Name** | **Description** | **GIT Repo** |
| --- | --- | --- |
| vms\_and\_lb | Module used to create the VMs and Loadbalancer | module\_vms\_and\_loadbalancer |
| cloud\_function | Module used to provision cloud function action| module\_cloudfunction\_autoscale\_action |
| sysdig\_monitoring\_config | Module used to provision monitoring service | module\_sysdig\_config |

### Inputs

| **Name** | **Description** | **Type** | **Default** | **Required** |
| --- | --- | --- | --- | --- |
| iaas\_classic\_username | IAAS Classic user name | string | n/a | yes |
| iaas\_classic\_api\_key | IAAS Classic user API Key | string | n/a | yes |
| ssh\_key | Name of the ssh key in classic infrastructure | string | n/a | yes |
| datacenter | Name of the datacenter to provision the VMs | string | n/a | yes |
| lbaas\_name | Name of the Load Balancer | string | n/a | yes |
| instance\_count | Number of VMs instances | number | n/a | yes |
| minimum\_vm\_count | The minimum number of VMs to be maintained all the time | number | 3 | no |
| namespace | Cloud Function namespace | string | n/a | yes |
| action\_name | Cloud Function action name | string | &quot;autoscaleaction&quot; | no |
| api\_key | IAM API Key of the ibmcloud user to perform schematics actions | string | n/a | yes |
| vm\_count | VM count for the autoscaling | number | 0 | no |
| resource\_group\_name | Sysdig resource group name. | string | n/a | yes |
| instance\_name | Sysdig instance name | string | n/a | yes |
| location | Sysdig instance location | string | n/a | yes |
| scale\_up\_alert\_name | Alert name for scaling up the VMs | string | lb-load-scale-up-alert | no |
| scale\_down\_alert\_name | Alert name for scaling down the VMs | string |lb-load-scale-down-alert | no |
| scale\_up\_alerts\_config | A list of scale up alert configurations | list(map(string)) | n/a | yes |
| scaledown\_upper\_threshold | Number of active connections upper threshold for the scale down alert | number | 5 | no |
| scaledown\_lower\_threshold | Number of active connections lower threshold for the scale down alert | number | 0 | no |

### Outputs

| **Name** | **Description** |
| --- | --- |
| web\_server\_private\_ips | List of the private IP Addresses of the web servers |
| lbaas\_subnet | Load balancer subnet |
| lbaas\_hostname | Load balancer host name |
| health\_monitors | Health Monitors of the loadbalcer |
| sysdig\_dashboard\_url | Custom sysdig dashborad URL |

## Operator Quick start Guide

This section of the document enables the operator to configure the solution and verify the same. The following steps are performed to setup the solution:

1. Create schematics workspace with solution.
    ![plot](./images/workspace.png?raw=true])

2. Update the workspace variables.
    ![plot](./images/variables.png?raw=true])

3. Workspace plan-apply to setup the solution outputs from the workspace provide the following details:
  1. Load balancer hostname
  2. sysdig dash board URL to see the alerts and notifications
  ![plot](./images/workspace_outputs.png?raw=true])

The following steps are performed to verify the setup:

1. Open the custom sysdig dashboard created for the solution depectingdepicting the load balancer connection rate, active connection and cloud function activations as shown
    ![plot](./images/sysdig_dashboard.png?raw=true])
2. verify the cloud function creation
    ![plot](./images/cloudfunction.png?raw=true])

The following steps are performed to verify the functionality of the setup:

1. Increase the number of requests using soap UI or any other test tool
2. Observe the increase in the number of active connections and connection rate
    ![plot](./images/dashboard_connection_increase.png?raw=true])
3. Once the first threasholdthreshold is reached, there will be a notification sent by sysdig alert to cloud function to increase the number of VMs
    ![plot](./images/cloudfunction_activation.png?raw=true])
4. Cloud function calls schematics API to modifiymodify workspace&#39;s VMvms count resulting in addition of VM isnstanceinstance attached to the load balancer

## Developer Quick starrt Guide

This section of the document enables the developers to enhance the solution. Sysdig alerts configuration: Terraform provider for sysdig enables to add alerts configuration capabilities. See the documentaiondocumentation here - [sysdig-docs](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/sysdig_monitor_alert_metric)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/Cloud-Schematics/classic-vsi-autoscaling-solution/blob/master/LICENSE) for full details.