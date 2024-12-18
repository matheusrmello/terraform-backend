resource "aws_lb" "ecs_lb" {
  name               = "test-matheus-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_ecs.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "test-matheus-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path = "/posts"
    port = 3000
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    matcher = "200-499"
  }

}

resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}