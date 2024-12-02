resource "aws_iam_role" "role" {
  name = "${var.tool_name}-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
  {
    "Effect": "Allow",
    "Principal": {
    "Service": "ec2.amazonaws.com"
  },
    "Action": "sts:AssumeRole"
  }
  ]
}
EOF

inline_policy {
  name = "${var.tool_name}-inline-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.policy_list
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

  tags = {
    name = "${var.tool_name}-role"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.tool_name}-role"
  role = aws_iam_role.role.name
}