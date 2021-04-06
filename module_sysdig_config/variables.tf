variable "resource_group_name"{
    type =  string
}

variable "instance_name"{
    type =  string
}

variable "location"{
    type =  string
}

variable "scale_up_alert_name"{
    type = string
}

variable "scale_down_alert_name"{
    type = string
}

variable "scale_up_alerts_config"{
    type = list(map(string))
    default = []
}

variable "scaledown_lower_threshold"{
    type = number
}

variable "scaledown_upper_threshold"{
    type = number
}

variable "notification_channel_webhook_url" {
    type = string
}