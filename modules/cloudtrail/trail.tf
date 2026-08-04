resource "aws_cloudtrail" "main" {

  name = "${local.name_prefix}-cloudtrail"

  s3_bucket_name = var.trail_bucket_name

  kms_key_id = var.kms_key_arn

  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true

  enable_logging = true

  event_selector {

    read_write_type           = "All"
    include_management_events = true
  }

  tags = merge(

    local.common_tags,

    {
      Name = "${local.name_prefix}-cloudtrail"
    }

  )
}
