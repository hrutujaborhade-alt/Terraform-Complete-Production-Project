resource "aws_db_subnet_group" "db_group" {
  subnet_ids = var.db_subnet_ids

  tags = merge(
    common_tags,
    {
        Name = "${var.name_prefix}-db-subnet-group"
    }
  )
}
resource "aws_db_instance" "mysql" {
  
  identifier = "${var.name_prefix}-mysql"

  engine = "mysql"
  engine_version = "8.4.9"

  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type = "gp3"

  db_name = var.db_name
  username = var.username
  password = var.db_password
  
  publicly_accessible = false
  storage_encrypted = true
  backup_retention_period = 7
  skip_final_snapshot = true
  multi_az = false


   db_subnet_group_name = aws_db_subnet_group.db_group.name

   vpc_security_group_ids = [var.db_security_group_ids]


  tags = merge(
    var.common_tags,
    {
        Name = "{var.name_prefix}-rds"
    }
  )
}