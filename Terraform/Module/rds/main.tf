resource "aws_security_group" "Db_sg" {
  vpc_id = var.vpc_id
  ingress = {
    cidr_block = var.db_cidr
    from_port  = 3306
    to_port    = 3306
    protocol   = "tcp"

  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

}
resource "aws_db_subnet_group" "urotaxi_db" {
  subnet_ids = var.subnet_ids
  tags = {
    "Name" = "Db_subnet_group"
  }
}
resource "aws_db_instance" "urotaxi_db" {
  allocated_storage = var.allocated_storage
  db_name           = var.db_name
  engine            = "mysql"
  engine_version    = "8.0.31"
  instance_class    = var.instance_class
  username = var.db_username
  password = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.urotaxi_db.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  tags = {
    "Name" = var.db_name
  }
}
