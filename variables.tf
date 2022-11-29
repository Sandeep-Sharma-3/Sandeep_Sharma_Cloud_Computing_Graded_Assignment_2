variable "image_id" {
    type = string
    default = "ami-08c40ec9ead489470"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "asg_min_size" {
    type = number
    default = 2
}

variable "asg_max_size" {
    type = number
    default = 3
}

variable "asg_health_check_grace_period" {
    type = number
    default = 100
}

variable "asg_policy_scaling_adjustment_up" {
    type = number
    default = 1
}

variable "asg_polic_scale_up_cooldown" {
    type = number
    default = 60
}

variable "asg_policy_scaling_adjustment_down" {
    type = number
    default = -1
}

variable "asg_polic_scale_down_cooldown" {
    type = number
    default = 60
}