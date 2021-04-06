output "sysdig_dashboard_url" {
    value = "${ibm_resource_key.resource_key.credentials["Sysdig Endpoint"]}/#/dashboards/${sysdig_monitor_dashboard.autoscale_dashboard.id}"
}