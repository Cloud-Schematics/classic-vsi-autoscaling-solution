output lbaas_hostname {
  value = ibm_lbaas.lbaas.vip
}

output health_monitors {
  value = ibm_lbaas.lbaas.health_monitors
}

output "schematics_workspace_id" {
    value = [for x in split(",", data.external.get_env_var.result["env_var"]): split(":", x)[1] if contains(split(":", x), "Schematics")][0]
}
