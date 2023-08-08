resource "aws_security_group" "this" {
  count = var.enabled_default_security_group ? 1 : 0
  name        = local.sg_name
  description = local.sg_name
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { Name = local.sg_name })
}
