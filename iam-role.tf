locals {
  service_role_name          = format("%s%s", local.project, replace(title( format("%s-ServiceRole", var.name) ), "-", "" ))
  batch_service_policy_name  = format("%s%s", local.project, replace(title( format("%s-ServicePolicy", var.name) ), "-", "" ))
  ec2_role_name              = format("%s%s", local.project, replace(title( format("%s-EC2Role", var.name) ), "-", "" ))
  batch_instance_policy_name = format("%s%s", local.project, replace(title( format("%s-EC2Policy", var.name) ), "-", "" ))
}

resource "aws_iam_role" "svcRole" {
  count              = local.create_service_role ? 1 : 0
  name               = local.service_role_name
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

  tags = merge(local.tags, { Name = local.service_role_name })
}

resource "aws_iam_role_policy_attachment" "AWSBatchServiceRole" {
  count      = local.create_service_role ? 1 : 0
  role       = aws_iam_role.svcRole[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_role_policy_attachment" "customBatchPolicy" {
  count      = local.create_service_role && var.service_policy_arn != null ? 1 : 0
  role       = aws_iam_role.svcRole[0].name
  policy_arn = var.service_policy_arn
}

resource "aws_iam_role" "ec2" {
  count              = local.create_instance_role ? 1 : 0
  name               = local.ec2_role_name
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

  tags = merge(local.tags, { Name = local.ec2_role_name })
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceforEC2Role" {
  count      = local.create_instance_role ? 1 : 0
  role       = aws_iam_role.ec2[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "AmazonS3ReadOnlyAccess" {
  count      = local.create_instance_role ? 1 : 0
  role       = aws_iam_role.ec2[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "customInstancePolicy" {
  count      = local.create_instance_role && var.instance_policy_arn != null ? 1 : 0
  role       = aws_iam_role.ec2[0].name
  policy_arn = var.instance_policy_arn
}

resource "aws_iam_instance_profile" "ec2" {
  count = local.create_instance_role ? 1 : 0
  name  = local.ec2_role_name
  role  = aws_iam_role.ec2[0].name
  tags  = merge(local.tags, { Name = local.ec2_role_name })
}
