module "app" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 8.0"

  function_name = var.service
  handler       = "main.lambda_handler"
  runtime       = "python3.14"
  memory_size   = 512

  source_path = "${path.module}/../src"

  attach_network_policy  = true
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [aws_security_group.this.id]

  file_system_arn              = aws_s3files_access_point.this.arn
  file_system_local_mount_path = "/mnt/s3"

  attach_policy_json = true
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "S3FilesMount"
        Effect   = "Allow"
        Action   = ["s3files:ClientMount", "s3files:ClientWrite"]
        Resource = "*"
      },
      {
        Sid      = "S3DirectRead"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource = "${aws_s3_bucket.this.arn}/*"
      },
      {
        Sid    = "S3FilesConsoleSetup"
        Effect = "Allow"
        Action = [
          "s3files:ListFileSystems",
          "s3files:ListAccessPoints",
          "s3files:GetFileSystem",
          "s3files:GetAccessPoint",
          "s3files:CreateAccessPoint"
        ]
        Resource = "*"
      }
    ]
  })

  environment_variables = {
    MOUNT_PATH = "/mnt/s3"
  }

  tags = local.default_tags
}
