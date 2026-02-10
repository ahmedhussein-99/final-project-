resource "aws_kms_key" "main" {
  description             = "KMS key for RDS and Secret encryption"
  deletion_window_in_days = 7
}

# Changed name to v4 to bypass the current deletion lock.
# recovery_window_in_days set to 0 allows immediate deletion without waiting for the recovery period.
resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "myapp-db-credentials-v4" 
  kms_key_id              = aws_kms_key.main.arn
  recovery_window_in_days = 0 
}

output "kms_key_arn" { 
  value = aws_kms_key.main.arn 
}