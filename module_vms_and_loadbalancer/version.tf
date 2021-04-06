terraform {
  required_version = ">= 0.13.0"

  required_providers {
    ibm = {
      source           = "IBM-Cloud/ibm"
      required_version = ">= 1.21.0"
    }
  }
}
