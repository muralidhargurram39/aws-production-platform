resource "aws_iam_role_policy_attachment" "ssm" {

  role = var.ec2_role_name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
