data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  dynamic "filter" {
    for_each = var.subnet_prefix_name == null ? [] : [""]
    content {
      name   = "tag:Name"
      values = [format("%s*", var.subnet_prefix_name)]
    }
  }

}

output "aaa" {
  value = data.aws_subnets.this.ids
}
