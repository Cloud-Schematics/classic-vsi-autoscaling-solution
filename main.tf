
module "vms_and_lb"{
  source = "./module_vms_and_loadbalancer"
  iaas_classic_username = var.iaas_classic_username
  iaas_classic_api_key = var.iaas_classic_api_key
  ssh_key = var.ssh_key
  datacenter = var.datacenter
  lbaas_member = var.lbaas_name
  instance_count = var.instance_count
}

module "cloud_function" {
  source = "./module_cloudfunction_autoscale_action"
  minimum_vm_count = var.minimum_vm_count
  namespace = var.namespace
  action_name = var.action_name
  api_key = var.api_key
  workspace_id = module.vms_and_lb.workspace_id
  vm_count = var.vm_count
}

module "sysdig_monitoring_config" {
  source = "./module_sysdig_config"
  resource_group_name = var.resource_group_name
  instance_name = var.instance_name
  location= var.location
  scale_up_alert_name = var.scale_up_alert_name
  scale_down_alert_name = var.scale_down_alert_name
  scale_up_alerts_config = var.scale_up_alerts_config
  scaledown_lower_threshold = var.scaledown_lower_threshold 
  scaledown_upper_threshold = var.scaledown_upper_threshold
  notification_channel_webhook_url = module.cloud_function.cloud_function_target_endpoint_url
}