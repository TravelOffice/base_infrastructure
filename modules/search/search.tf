variable "ENV" {}
variable "TAGS" {}
variable "AWS_REGION" {}

resource "aws_ebs_volume" "volume" {
  availability_zone = "${var.AWS_REGION}a"
  size              = var.ENV == "dev" ? 40 : 100
  final_snapshot    = true
  type              = "gp3"
  encrypted         = true

  tags = merge(
    var.TAGS,
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
    schedule          = var.SCHEDULE_BACKUP_PLAN
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
    type  = var.BACKUP_SELECTION_RESOURCE.type
    key   = var.BACKUP_SELECTION_RESOURCE.key
    value = var.BACKUP_SELECTION_RESOURCE.value
  }
  iam_role_arn = aws_iam_role.backup-role.arn
}
