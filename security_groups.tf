resource "aws_security_group" "sg_docker" {
  name   = "sg_instance_docker"
  vpc_id = aws_vpc.project_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "matheus-test-sg-docker"
  }
}

resource "aws_security_group" "sg_k8s" {
  name   = "sg_instance_k8s"
  vpc_id = aws_vpc.project_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 7443
    to_port     = 7443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "Allow HTTPS"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "matheus-test-sg-k8s"
  }
}

# resource "aws_security_group" "sg_ecs" {
#   name   = "sg_instance_ecs"
#   vpc_id = aws_vpc.project_vpc.id

#   ingress {
#     description     = "Allow HTTPS"
#     from_port       = 4000
#     to_port         = 4000
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "matheus-test-sg-ecs"
#   }
# }

resource "aws_security_group" "rds_sg" {
  vpc_id      = aws_vpc.project_vpc.id
  description = "Allow traffic for RDS"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "matheus-test-sg-rds"
  }
}

# resource "aws_security_group" "alb_sg" {
#   vpc_id = aws_vpc.project_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "alb-sg"
#   }
# }
resource "aws_security_group" "ecs_sg" {
  vpc_id                 = aws_vpc.project_vpc.id
  name                   = "demo-sg-ecs"
  description            = "Security group for ecs app"
  revoke_rules_on_delete = true
}
# ------------------------------------------------------------------------------
# ECS app Security Group Rules - INBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "ecs_alb_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Allow inbound traffic from ALB"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}
# ------------------------------------------------------------------------------
# ECS app Security Group Rules - OUTBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "ecs_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from ECS"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# ------------------------------------------------------------------------------
# Security Group for alb
# ------------------------------------------------------------------------------
resource "aws_security_group" "alb_sg" {
  vpc_id                 = aws_vpc.project_vpc.id
  name                   = "demo-sg-alb"
  description            = "Security group for alb"
  revoke_rules_on_delete = true
}
# ------------------------------------------------------------------------------
# Alb Security Group Rules - INBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "alb_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  description       = "Allow http inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "alb_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  description       = "Allow https inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
# ------------------------------------------------------------------------------
# Alb Security Group Rules - OUTBOUND
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from alb"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}