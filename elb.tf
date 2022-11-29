#AWS ELB config
resource "aws_elb" "custom-elb" {
    name = "custom-elb"
    subnets = [aws_subnet.customvpc-public-1.id, aws_subnet.customvpc-public-2.id]
    security_groups = [aws_security_group.custom-security-group-elb.id]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check {
        #(required) The number of checks before the instance is declared healthy
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
    }

    cross_zone_load_balancing = true
    connection_draining = true
    connection_draining_timeout = 400

    tags = {
      "Name" = "custom-elb"
    }
}

output "ELB" {
  value = aws_elb.custom-elb.dns_name
}