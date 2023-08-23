
output "db_address" {
  value = aws_db_instance.urotaxi_db.address
  
}
output "db_endpoint" {
  value = aws_db_instance.urotaxi_db.endpoint
}