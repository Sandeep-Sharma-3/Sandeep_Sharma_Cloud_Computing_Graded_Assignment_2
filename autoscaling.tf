#define autoscaling launch configuration
resource "aws_launch_configuration" "custom-launch-configuration" {
    name = "custom-launch-configuration"
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = "project3_devops"
    user_data = "${file("user_data.sh")}"
    security_groups = ["${aws_security_group.custom-security-group-inst.id}"]
    lifecycle {
      create_before_destroy = true
    }
}

#define autoscaling group
resource "aws_autoscaling_group" "custom-group-autoscaling" {
    name = "custom-group-autoscaling"
    vpc_zone_identifier = [ aws_subnet.customvpc-public-1.id, aws_subnet.customvpc-public-2.id ]
    launch_configuration = aws_launch_configuration.custom-launch-configuration.name
    min_size = var.asg_min_size
    max_size = var.asg_max_size
    health_check_grace_period = var.asg_health_check_grace_period
    health_check_type = "ELB"
    load_balancers = [aws_elb.custom-elb.name]
    force_delete = true
    tag {
      key = "Name"
      value = "custom_ec2_instance"
      propagate_at_launch = true 
    }
}

#define autoscaling configuration policy
resource "aws_autoscaling_policy" "custom-cpu-policy" {
    name = "custom-cpu-policy"
    autoscaling_group_name = aws_autoscaling_group.custom-group-autoscaling.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = var.asg_policy_scaling_adjustment_up
    cooldown = var.asg_polic_scale_up_cooldown
    policy_type = "SimpleScaling"
}

#define cloud watch monitoring
#resource "aws_cloudwatch_metric_alarm" "custome-cpu-alarm" {
#    alarm_name = "custome-cpu-alarm"
#    alarm_description = "Alarm once cpu usage increases."
#    comparison_operator = "GreaterThanOrEqualToThreshold"
#    evaluation_periods = 2
#    metric_name = "CPUUtilization"
#    namespace = "AWS/EC2"
#    period = 120
#    statistic = "Average"
#    threshold = 20

#    dimensions = {
#      "AutoScalingGroupName" = aws_autoscaling_group.custom-group-autoscaling.name
#    }
#    actions_enabled = true
#    alarm_actions = [ aws_autoscaling_policy.custom-cpu-policy.arn ]
#}

#Define auto descaling policy
resource "aws_autoscaling_policy" "custom-cpu-policy-scaledown" {
    name = "custom-cpu-policy-scaledown"
    autoscaling_group_name = aws_autoscaling_group.custom-group-autoscaling.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = var.asg_policy_scaling_adjustment_down
    cooldown = var.asg_polic_scale_down_cooldown
    policy_type = "SimpleScaling"
}

#Define descaling cloud watch
#resource "aws_cloudwatch_metric_alarm" "custome-cpu-alarm-scaledown" {
#    alarm_name = "custome-cpu-alarm-scaledown"
#    alarm_description = "Alarm once cpu usage decreases."
#    comparison_operator = "LessThanOrEqualToThreshold"
#    evaluation_periods = 2
#    metric_name = "CPUUtilization"
#    namespace = "AWS/EC2"
#    period = 120
#    statistic = "Average"
#    threshold = 10

#    dimensions = {
#      "AutoScalingGroupName" = aws_autoscaling_group.custom-group-autoscaling.name
#    }
#    actions_enabled = true
#    alarm_actions = [ aws_autoscaling_policy.custom-cpu-policy-scaledown.arn ]
#}