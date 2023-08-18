variable "aws_region" {}
variable "env" {}
variable "tags" {}

resource "aws_ebs_volume" "volume" {
  availability_zone = "${var.aws_region}a"
  size              = var.env == "dev" ? 40 : 100
  final_snapshot    = true
  type              = "gp3"
  encrypted         = true

  tags = merge(
    var.tags,
    {
      Name = "EBS-Search-Service"
    }
  )
}
output "volume_id" {
  value = aws_ebs_volume.volume.id
}
## add backup ebs
resource "aws_backup_vault" "vault" {
  name = "vault-EBS"
}
resource "aws_backup_plan" "backup" {
  name = "EBS-bk-plan"
  rule {
    rule_name         = "rule-bk-ebs"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = var.schedule_backup_plan
    lifecycle {
      cold_storage_after = 0
      delete_after       = 30
    }
  }
}

resource "aws_iam_role" "backup-role" {
  name               = "backup-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "backup-role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup-role.name
}

resource "aws_backup_selection" "selection" {
  name    = "selection-EBS"
  plan_id = aws_backup_plan.backup.id
  selection_tag {
    type  = var.backup_selection_resource.type
    key   = var.backup_selection_resource.key
    value = var.backup_selection_resource.value
  }
  iam_role_arn = aws_iam_role.backup-role.arn
}
