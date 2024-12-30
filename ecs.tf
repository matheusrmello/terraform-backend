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
      "image" : "${var.ecr_repo_url_api}",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : "${var.api_container_port}"
        }
      ],
      "environment" : [
        { "name" : "DB_HOST", "value" : "localhost" },
        { "name" : "DB_PORT", "value" : "5432" },
        { "name" : "DB_USER", "value" : "${var.db_user}" },
        { "name" : "DB_PASSWORD", "value" : "${var.db_pass}" },
        { "name" : "DB_NAME", "value" : "${var.db_name}" }
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
      "name" : "postgres",
      "image" : "${var.ecr_repo_url_db}",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 5432
        }
      ],
      "environment" : [
        { "name" : "POSTGRES_USER", "value" : "${var.db_user}" },
        { "name" : "POSTGRES_PASSWORD", "value" : "${var.db_pass}" },
        { "name" : "POSTGRES_DB", "value" : "${var.db_name}" }
      ],
      "mountPoints" : [
        {
          "sourceVolume" : "db-data",
          "containerPath" : "/var/lib/postgresql/data",
          "readOnly" : false
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

  volume {
    name = "db-data"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.db_efs.id
    }
  }
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
    container_name   = "node-api-server"
    container_port   = var.api_container_port
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

resource "aws_efs_file_system" "db_efs" {
  creation_token   = "blog-efs"
  performance_mode = "generalPurpose"
}

resource "aws_efs_mount_target" "efs_mount" {
  file_system_id  = aws_efs_file_system.db_efs.id
  subnet_id       = aws_subnet.private_subnet_1.id
  security_groups = [aws_security_group.ecs_sg.id]
}
