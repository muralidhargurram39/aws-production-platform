resource "aws_kms_alias" "main" {

  name = "alias/${local.name_prefix}"

  target_key_id = aws_kms_key.main.key_id
}
