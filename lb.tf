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