resource "aws_ecs_cluster" "cluster_backend" {
  name = var.cluster_name

  tags = {
    Name = "test-matheus-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "deploy_api" {
  family                   = "api-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([{
    "name" : "node-api-server",
    "image" : "654654369899.dkr.ecr.us-east-2.amazonaws.com/test-matheus-app-node-api:v4",
    "essential" : true,
    "portMappings" : [
      {
        "containerPort" : 5000,
        "hostPort" : 5000
      }
    ],
    "environment" : [
      {
        "name" : "DB_HOST",
        "value" : aws_db_instance.postgres_db.endpoint
      },
      {
        "name" : "DB_PORT",
        "value" : "5432"
      },
      {
        "name" : "DB_USER",
        "value" : "root"
      },
      {
        "name" : "DB_PASS",
        "value" : "928BDeuE"
      },
      {
        "name" : "DB_NAME",
        "value" : "blog"
      }
    ]
  }])
}

resource "aws_ecs_service" "ecs_service" {
  name                 = var.cluster_name
  cluster              = aws_ecs_cluster.cluster_backend.id
  task_definition      = aws_ecs_task_definition.deploy_api.arn
  desired_count        = var.desired_count
  launch_type          = "FARGATE"
  force_delete         = true
  force_new_deployment = true
  depends_on           = [aws_iam_role.task_execution_role]

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "node-api-server"
    container_port   = 5000
  }

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.sg_ecs.id]
    assign_public_ip = true
  }

}

