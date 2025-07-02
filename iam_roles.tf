resource "aws_iam_role" "read_only" {
  name = "${var.stage}_read_only_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "read_only_policy" {
  name = "${var.stage}_read_only_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "read_only_attach" {
  role       = aws_iam_role.read_only.name
  policy_arn = aws_iam_policy.read_only_policy.arn
}

resource "aws_iam_role" "write_only" {
  name = "${var.stage}_write_only_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "write_only_policy" {
  name = "${var.stage}_write_only_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:ListBucket",
          "s3:CreateBucket"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "write_only_attach" {
  role       = aws_iam_role.write_only.name
  policy_arn = aws_iam_policy.write_only_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.stage}_ec2_profile"
  role = aws_iam_role.write_only.name
}
