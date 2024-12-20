# resource "aws_iam_role" "task_execution_role" {
#   name = "ecsTaskExecutionRole"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }


# resource "aws_iam_role" "ecs_service_role" {
#   name = "ecs-service-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Principal = {
#           Service = "ecs.amazonaws.com"
#         },
#         Effect = "Allow",
#       }
#     ]
#   })
# }

resource "aws_iam_role_policy" "task_execution_logs_policy" {
  name = "ecs-task-execution-logs-policy"
  role = aws_iam_role.ecsTaskExecutionRole.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

# resource "aws_iam_role_policy_attachment" "ecs_service_role_policy" {
#   role       = aws_iam_role.ecs_service_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
# }

# resource "aws_iam_role_policy_attachment" "ecs_elb_policy" {
#   role       = aws_iam_role.ecs_service_role.name
#   policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
# }

resource "aws_iam_role_policy_attachment" "task_execution_policy" {
  role       = aws_iam_role.ecsTaskRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "test-app-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecsTaskRole" {
  name               = "ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecsTaskRole_policy" {
  role       = aws_iam_role.ecsTaskRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}