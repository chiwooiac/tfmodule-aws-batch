locals {
  role_name     = format("%s%s", local.project, replace(title( format("%s-BatchServiceRole", var.name) ), "-", "" ))
  policy_name   = format("%s%s", local.project, replace(title( format("%s-BatchServicePolicy", var.name) ), "-", "" ))
  ecs_role_name = format("%s%s", local.project, replace(title( format("%s-BatchECSRole", var.name) ), "-", "" ))
}

resource "aws_iam_role" "ecs" {
  name               = local.ecs_role_name
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF

  tags = merge(local.tags, { Name = local.ecs_role_name })
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
  name = local.ecs_role_name
  role = aws_iam_role.ecs.name
}

resource "aws_iam_role" "svcRole" {
  name               = local.role_name
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": ["batch.amazonaws.com", "events.amazonaws.com"]
        }
    }
    ]
}
EOF

  tags = merge(local.tags, { Name = local.role_name })
}

resource "aws_iam_role_policy_attachment" "svcRole" {
  role       = aws_iam_role.svcRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}
