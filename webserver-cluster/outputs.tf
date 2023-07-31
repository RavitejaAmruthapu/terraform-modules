output "alb_dns_name" {
    value       = aws_elb.example.dns_name
    description = "The domain name of the load balancer"
}

output "instance_security_group_id" {
    value       = aws_security_group.instance.id
    description = "The domain name of the load balancer"
}

output "elb_security_group_id" {
    value       = aws_security_group.elb.id
    description = "The domain name of the load balancer"
}