resource "aws_alb" "application_load_balancer" {
  name               = "test-matheus-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]

  tags = {
    Name = "test-matheus-alb"
  }

}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "test-matheus-tg"
  port        = 4000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.project_vpc.id

  tags = {
    Name = "test-matheus-ecs_tg"
  }
}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

