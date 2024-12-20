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
  execution_role_arn       = aws_iam_role.ecsTaskRole.arn

  container_definitions = jsonencode([
    {
      "name" : "node-api-server",
      "image" : "654654369899.dkr.ecr.us-east-2.amazonaws.com/test-matheus-app-node-api:latest",
      "essential" : true,
      "entryPoint" : [],
      "portMappings" : [
        {
          "containerPort" : 4000,
          "hostPort" : 4000,
          "protocol" : "tcp"
        }
      ],
      "environment" : [
        {
          "name" : "DB_HOST",
          "value" : "postgres"
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
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.ecs_log_group.name,
          "awslogs-region" : "us-east-2",
          "awslogs-stream-prefix" : "ecs",
          "awslogs-create-group" : "true"
        }
      }
    },
    {
      "name" : "vue-app",
      "image" : "matheusmello09/vue-js:latest",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort" : 3000,
          "protocol" : "tcp"
        }
      ]
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.ecs_log_group.name,
          "awslogs-region" : "us-east-2",
          "awslogs-stream-prefix" : "ecs",
          "awslogs-create-group" : "true"
        }
      }
    },
    {
      "name" : "postgres",
      "image" : "postgres:11",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 5432,
          "hostPort" : 5432,
          "protocol" : "tcp"
        }
      ],
      "environment" : [
        {
          "name" : "POSTGRES_USER",
          "value" : "root"
        },
        {
          "name" : "POSTGRES_PASSWORD",
          "value" : "928BDeuE"
        },
        {
          "name" : "POSTGRES_DB",
          "value" : "blog"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.ecs_log_group.name,
          "awslogs-region" : "us-east-2",
          "awslogs-stream-prefix" : "ecs",
          "awslogs-create-group" : "true"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name                 = var.cluster_name
  cluster              = aws_ecs_cluster.cluster_backend.id
  task_definition      = aws_ecs_task_definition.deploy_api.arn
  desired_count        = var.desired_count
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  force_delete         = true
  force_new_deployment = true

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "vue-app"
    container_port   = 3000
  }

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
    security_groups  = [aws_security_group.ecs_sg.id, aws_security_group.alb_sg.id]
    assign_public_ip = false
  }
  depends_on = [aws_lb_listener.ecs_listener]

}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/api-service"
  retention_in_days = 1
}
