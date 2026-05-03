resource "aws_s3_bucket" "this" {
  bucket = "${var.service}-${data.aws_caller_identity.this.account_id}"

  tags = local.default_tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3files_file_system" "this" {
  bucket   = aws_s3_bucket.this.arn
  role_arn = aws_iam_role.this.arn

  depends_on = [aws_s3_bucket_versioning.this]

  tags = local.default_tags
}

resource "aws_s3files_mount_target" "this" {
  for_each = local.private_subnet_by_az

  file_system_id  = aws_s3files_file_system.this.id
  subnet_id       = each.value
  security_groups = [aws_security_group.this.id]
}

resource "aws_s3files_access_point" "this" {
  file_system_id = aws_s3files_file_system.this.id

  posix_user {
    uid = 0
    gid = 0
  }

  root_directory {
    path = "/"
  }

  tags = local.default_tags
}
