output "db_endpoint" {
  value = aws_instance.db.private_ip
}
