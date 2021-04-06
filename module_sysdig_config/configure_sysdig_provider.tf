
provider "ibm" {}

data "ibm_iam_auth_token" "tokendata" {

}
/*********************************************************
Fetch IBMInstanceID
*********************************************************/

data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

data "ibm_resource_instance" "resource_instance" {
  name              = var.instance_name
  location          = var.location
  resource_group_id = data.ibm_resource_group.group.id
}

resource "ibm_resource_key" "resource_key" {
  name                 = "sysdig-key-testing"
  role                 = "Writer"
  resource_instance_id = data.ibm_resource_instance.resource_instance.id

  //User can increase timeouts
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

/*********************************************************
Fetch sysdig iam token
*********************************************************/

data external monitor_api_key {
  program = [
    "bash",                                                                                   # Run with bash
    "${path.module}/scripts/monitor-api-key.sh",                                              # Script to run
    data.ibm_iam_auth_token.tokendata.iam_access_token,                                       # IBM Cloud access token
    data.ibm_resource_instance.resource_instance.guid                                         # sysdig instance ID  
  ]
}

provider "sysdig" {
  sysdig_monitor_api_token = data.external.monitor_api_key.result["api_key"] 
  sysdig_monitor_url       = ibm_resource_key.resource_key.credentials["Sysdig Endpoint"]
}