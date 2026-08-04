locals {

  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-certificate"
    }
  )

}
