# resource "aws_security_group" "instance_sg" {
#   vpc_id                 = aws_vpc.project_vpc.id
#   name                   = "alb-sg-instance"
#   description            = "Security group for instance app"
#   revoke_rules_on_delete = true
# }

# resource "aws_security_group" "alb_sg_instance" {
#   vpc_id                 = aws_vpc.project_vpc.id
#   name                   = "instance-sg-alb"
#   description            = "Security group for alb"
#   revoke_rules_on_delete = true
# }

# resource "aws_security_group_rule" "instance_alb_ingress" {
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   description              = "Allow inbound traffic from ALB"
#   security_group_id        = aws_security_group.instance_sg.id
#   source_security_group_id = aws_security_group.alb_sg_instance.id
# }

# resource "aws_security_group_rule" "alb_http_ingress_instance" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "TCP"
#   description       = "Allow http inbound traffic from internet"
#   security_group_id = aws_security_group.alb_sg_instance.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }

resource "aws_security_group" "sg_docker" {
  name   = "sg_instance_docker"
  vpc_id = aws_vpc.project_vpc.id


  ingress {
    description     = "Allow SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.alb_sg_instance.id]
  }

  ingress {
    description     = "Allow HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.alb_sg_instance.id]
  }

  ingress {
    description     = "Allow HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.alb_sg_instance.id]
  }

  ingress {
    description     = "Allow HTTPS"
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.alb_sg_instance.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    # security_groups  = [aws_security_group.alb_sg_instance.id]
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
    description = "Allow SSH"
    from_port   = 31080
    to_port     = 31080
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
    Name = "matheus-test-sg-k8s"
  }
}

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

resource "aws_security_group" "ecs_sg" {
  vpc_id                 = aws_vpc.project_vpc.id
  name                   = "ecs-sg"
  description            = "Security group for ECS app"
  revoke_rules_on_delete = true
}

# Allow ALB to communicate with ECS tasks
resource "aws_security_group_rule" "ecs_alb_api" {
  type                     = "ingress"
  from_port                = 4000
  to_port                  = 4000
  protocol                 = "TCP"
  description              = "Allow inbound traffic from ALB to ECS tasks"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "ecs_internal_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
}


resource "aws_security_group_rule" "ecs_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  description       = "Allow HTTP inbound traffic from internet"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  description       = "Allow HTTP inbound traffic from internet"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_db_ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "TCP"
  description              = "Allow DB inbound traffic from ECS tasks"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
}

resource "aws_security_group_rule" "ecs_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from ECS"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group" "alb_sg" {
  vpc_id                 = aws_vpc.project_vpc.id
  name                   = "alb-sg-ecs"
  description            = "Security group for ALB"
  revoke_rules_on_delete = true
}

# ALB Rules for HTTP, HTTPS, and API traffic
resource "aws_security_group_rule" "alb_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  description       = "Allow HTTP inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  description       = "Allow HTTPS inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_api_ingress" {
  type              = "ingress"
  from_port         = 4000
  to_port           = 4000
  protocol          = "TCP"
  description       = "Allow API inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow ALB to communicate out to the ECS tasks
resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from ALB"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_efs_ingress" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "TCP"
  description       = "Allow ECS tasks to access EFS"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = [aws_vpc.project_vpc.cidr_block]
}

resource "aws_security_group_rule" "ecs_efs_egress" {
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "TCP"
  description       = "Allow ECS tasks to access EFS"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = [aws_vpc.project_vpc.cidr_block]
}
