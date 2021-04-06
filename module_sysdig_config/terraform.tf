terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.21.0"
    }
    sysdig = {
      source = "sysdiglabs/sysdig"
      version = "0.5.7"
    }
  }
}