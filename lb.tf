# resource "aws_alb" "docker_load_balancer" {
#   name               = "test-matheus-alb-docker"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg_instance.id]
#   subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]

#   tags = {
#     Name = "test-matheus-alb-docker"
#   }

# }

# resource "aws_lb_target_group" "docker_tg" {
#   name        = "test-matheus-tg-docker"
#   protocol    = "HTTP"
#   port        = 80
#   target_type = "instance"
#   vpc_id      = aws_vpc.project_vpc.id

#   health_check {
#     port                = 80
#     interval            = 30
#     timeout             = 10
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     path                = "/"
#     matcher             = "200-499"
#   }

#   tags = {
#     Name = "test-matheus-docker_tg"
#   }
# }

# resource "aws_lb_listener" "docker_listener" {
#   load_balancer_arn = aws_alb.docker_load_balancer.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.docker_tg.arn
#   }
# }

# resource "aws_lb_target_group_attachment" "my_attachment" {
#   target_group_arn = aws_lb_target_group.docker_tg.arn
#   target_id        = aws_instance.instance-docker.id
#   port             = 80
# }


# data "aws_acm_certificate" "amazon_issued" {
#   provider    = aws.us_east_1
#   domain      = "mrmello.com.br"
#   types       = ["AMAZON_ISSUED"]
#   statuses    = ["ISSUED"]
#   most_recent = true
# }

# data "aws_route53_zone" "zone" {
#   name         = "mrmello.com.br."
#   private_zone = false
# }

# resource "aws_route53_record" "alias_route53_record" {
#   zone_id = data.aws_route53_zone.zone.zone_id
#   name    = "api.test-matheus"
#   type    = "CNAME"
#   ttl     = 300
#   records = [aws_alb.docker_load_balancer.dns_name]
# }