//===========================================
// variables for Classic infra structure
//===========================================
variable "iaas_classic_username" {
  description = "Classic IaaS username."
  type        = string
}

variable "iaas_classic_api_key" {
  description = "Classic IaaS API Key."
  type        = string
}

variable "ssh_key" {
  description = "SSH key to add to instance."
  type        = string
}

variable "datacenter" {
  description = "Default datacenter for LBaaS and web instances."
  type        = string
}

variable "lbaas_name"{
   description = "lbaas instance name"
   type = string
}

variable "instance_count" {
  description = "Number of instances"
  type = number
}
// =====================================================

variable "minimum_vm_count" {
    default = 3
    description = "Minumum VMs to be maintained with Load balancer" 
}

variable "namespace" {
    description = "Name space where cloud function is defined"
}

variable "action_name" {
    default = "autoscaleaction"
    description = "Name of the action"
}

variable "api_key" {
    description = "API Key to perform the schematics operations"
}

variable "vm_count"{
    default = 0
    description = "default value for the vm count parameter"
}

//|======================================================| 
//|      sysdig-monitor-config vrariables                |
//|======================================================|
variable "resource_group_name"{
    type =  string
}

variable "instance_name"{
    type =  string
}

variable "location"{
    type =  string
}

variable "scale_up_alert_name"{
    description = "sysdig alert name"
    default = "lb-load-scale-up-alert"
}

variable "scale_down_alert_name"{
    type = string
    default = "lb-load-scale-down-alert"
}

variable "scale_up_alerts_config"{
    type = list(map(string))
    default = []
}

variable "scaledown_lower_threshold"{
    type = number
    default = 0
}

variable "scaledown_upper_threshold"{
    type = number
    default =  5
}

variable "number_of_scale_up_alerts" {
    default = 3
}
