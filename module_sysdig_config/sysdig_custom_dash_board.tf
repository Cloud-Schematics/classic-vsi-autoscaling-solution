resource "sysdig_monitor_dashboard" "autoscale_dashboard" {
  name        = "classic infra autoscale dashboard"
  description = "Dash board for autoscale feature in classic infrastructure"

    panel {
    pos_x       = 0
    pos_y       = 0
    width       = 12 # Maximum size: 24
    height      = 6
    type        = "timechart" # timechart or number
    name        = "Connection Rate (connections per sec)"
    description = "Description: connections per second"

    query {
      promql = "avg(avg_over_time(ibm_cloud_load_balancer_connection_rate[$__interval]))"
      unit   = "time"
    }
  }

  panel {
    pos_x       = 12
    pos_y       = 0
    width       = 12
    height      = 6
    type        = "timechart"
    name        = "Active Connections"
    description = "description: active connections"

    query {
      promql = "avg(avg_over_time(sysdig_host_cpu_used_percent[$__interval]))"
      unit   = "percent"
    }
  }

    panel {
    pos_x       = 0
    pos_y       = 12
    width       = 12
    height      = 6
    type        = "timechart"
    name        = "cloud function activations"
    description = "description: Cloud function activation"

    query {
      promql = "avg(avg_over_time(sysdig_host_cpu_used_percent[$__interval]))"
      unit   = "time"
    }
  }
}