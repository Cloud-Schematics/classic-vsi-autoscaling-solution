terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.21.0"
    }
  }
}


locals{
    user_defined_parameters = <<EOF
        [
    {
        "key": "apikey",
        "value": "${var.api_key}"
    },
    {
        "key":"workspace_id",
        "value": "${var.workspace_id}"
    },
    {
        "key": "vmcount",
        "value": "${var.vm_count}"
    },
    {
        "key": "min_vms",
        "value": ${var.minimum_vm_count}
    }
]
EOF
}

resource "ibm_function_action" "action" {
  name = var.action_name
  namespace = var.namespace  

  exec {
    kind = "python:3.7"
    code = file("${path.module}/main.py")
  }

  limits {
    log_size = 10
    memory   = 2048
    timeout  = 600000
  }
  user_defined_annotations = <<EOF
        [
    {
        "key": "web-export",
        "value": true
    },
    {
        "key":"raw-http",
        "value":true
    },
    {
        "key":"final",
        "value":true
    },
    {
        "key":"exec",
        "value":"blackbox"
    }
]
EOF
 user_defined_parameters = local.user_defined_parameters
}
