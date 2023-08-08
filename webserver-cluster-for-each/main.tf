resource "aws_security_group" "instance" {
    name = var.module_instance_security_group_name
}

resource "aws_security_group_rule" "instance_http_inbound" {
    type                = "ingress"
    security_group_id   = aws_security_group.instance.id

    from_port           = var.module_server_port
    to_port             = var.module_server_port
    protocol            = local.tcp_protocol
    cidr_blocks         = local.all_ips
}

resource "aws_security_group_rule" "instance_ssh_inbound" {
    type                = "ingress"
    security_group_id   = aws_security_group.instance.id

    from_port           = local.ssh_port
    to_port             = local.ssh_port
    protocol            = local.tcp_protocol
    cidr_blocks         = local.all_ips
}

resource "aws_security_group_rule" "instance_all_outbound" {
    type                = "egress"
    security_group_id   = aws_security_group.instance.id

    from_port           = local.any_port
    to_port             = local.any_port
    protocol            = local.any_protocol
    cidr_blocks         = local.all_ips
}

/*resource "aws_launch_configuration" "example" {
    image_id        = "ami-03f65b8614a860c29"
    instance_type   = local.instance_type
    security_groups = [aws_security_group.instance.id]

    # Render the User Data script as a template
    user_data = templatefile("${path.module}/user-data.sh", {
            server_port = var.module_server_port
            db_address  = data.terraform_remote_state.db.outputs.address
            db_port     = data.terraform_remote_state.db.outputs.port
        }
    )

    # Required when using a launch configuration with an auto scaling group.
    lifecycle {
        create_before_destroy = true
    }
}*/

resource "aws_launch_configuration" "example" {
    image_id        = var.ami
    instance_type   = local.instance_type
    security_groups = [aws_security_group.instance.id]

    # Render the User Data script as a template
    //user_data = "${file("${path.module}/user-data.sh")}"
    user_data = templatefile("${path.module}/user-data.sh", {
            text = var.server_text
        }
    )

    # Required when using a launch configuration with an auto scaling group.
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example" {
    name = "${var.cluster_name}-${aws_launch_configuration.example.name}"
    launch_configuration    = aws_launch_configuration.example.id
    availability_zones      = ["us-west-2c"]

    load_balancers          = [aws_elb.example.name]
    health_check_type       = "ELB"

    min_size                = 2
    max_size                = 5
    tag {
        key                 = "Name"
        value               = "terraform-asg-example"
        propagate_at_launch = true
    }
    lifecycle {
        create_before_destroy = true
    }
    dynamic "tag"{
        for_each = var.custom_tags
        content {
            key                 = tag.key
            value               = tag.value
            propagate_at_launch = true
        }
    }
}

resource "aws_elb" "example" {
    name                    = var.module_elb_name
    availability_zones      = ["us-west-2c"]
    security_groups         = [aws_security_group.elb.id]
    listener {
        lb_port             = local.elb_http_port
        lb_protocol         = local.elb_protocol
        instance_port       = var.module_server_port
        instance_protocol   = local.elb_instance_protocol
    }
    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        interval            = 30
        target              = "HTTP:${var.module_server_port}/"
    }
}

resource "aws_security_group" "elb" {
    name = var.module_elb_security_group_name
}

resource "aws_security_group_rule" "elb_http_inbound" {
    type                = "ingress"
    security_group_id   = aws_security_group.elb.id

    from_port           = local.elb_http_port
    to_port             = local.elb_http_port
    protocol            = local.tcp_protocol
    cidr_blocks         = local.all_ips
}

resource "aws_security_group_rule" "elb_http_outbound" {
    type                = "egress"
    security_group_id   = aws_security_group.elb.id

    from_port           = local.any_port
    to_port             = local.any_port
    protocol            = local.any_protocol
    cidr_blocks         = local.all_ips
}

/*data "terraform_remote_state" "db" {
    backend = "s3"
    config = {
        bucket = var.module_db_remote_state_bucket
        key    = var.module_db_remote_state_key
        region = "us-west-2"
    }
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}*/