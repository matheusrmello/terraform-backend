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
    "image" : "654654369899.dkr.ecr.us-east-2.amazonaws.com/test-matheus-app-node-api:latest",
    "essential" : true,
    "portMappings" : [
      {
        "containerPort" : 3000,
        "hostPort" : 3000
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
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
          "options": {
            "awslogs-group": aws_cloudwatch_log_group.ecs_log_group.name,
            "awslogs-region": "us-east-2",
            "awslogs-stream-prefix": "ecs",
            "awslogs-create-group": "true"
    }
  }
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
    container_port   = 3000
  }

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.sg_ecs.id]
    assign_public_ip = true
  }

}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/api-service"
  retention_in_days = 3
}

