resource "aws_elb" "matheus-test-elb" {
  name               = "test-matheus-elb"
  availability_zones = var.availability_zone

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }


  tags = {
    Terraform = "true"
    Name      = "matheus-test-elb"
  }
}

# resource "aws_lb" "lb_k8s" {
#   name = "test-matheus-lb-k8s"
#   internal = false
#   load_balancer_type = "application"
#   subnet_mapping {
#     subnet_id = aws_subnet.public_subnet_1.id
#   }
#   subnet_mapping {
#     subnet_id = aws_subnet.public_subnet_2.id
#   }


#   security_groups = [ aws_security_group.sg_k8s.id ]

#   }

#   resource "aws_lb_listener" "lb_listener_k8s" {
#     load_balancer_arn = aws_lb.lb_k8s.arn
#     protocol          = "HTTP"
#     port              = 80

#     default_action {
#       type             = "forward"
#       target_group_arn = aws_lb_target_group.test-tg-k8s.arn
#     }
# }

# resource "aws_lb_target_group" "test-tg-k8s" {
#   name = "test-matheus-tg-k8s"
#   port = 80
#   protocol = "HTTP"
#   vpc_id = aws_vpc.project_vpc.id
#   target_type = "instance"
# }

# resource "aws_autoscaling_attachment" "attach_instance_k8s" {
#   autoscaling_group_name = aws_instance.instance-k8s.id
#   lb_target_group_arn = aws_lb_target_group.test-tg-k8s.arn
# }