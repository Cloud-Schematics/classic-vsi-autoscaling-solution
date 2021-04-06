output "cloud_function_target_endpoint_url" {
    value = replace(ibm_function_action.action.target_endpoint_url, "us-south.functions.cloud.ibm.com", "us-south.functions.appdomain.cloud") 
}
