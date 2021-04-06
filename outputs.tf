output "web_server_private_ips" {
  value = module.vms_and_lb.web_server_private_ips
}

output "lbaas_subnet" {
  value = module.vms_and_lb.lbaas_subnet
}

output "lbaas_hostname" {
  value = module.vms_and_lb.lbaas_hostname
}

output "health_monitors" {
  value = module.vms_and_lb.health_monitors
}

output "sysdig_dashboard_url" {
  value = module.sysdig_monitoring_config.sysdig_dashboard_url
}
