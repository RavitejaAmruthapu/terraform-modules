resource "aws_db_instance" "example" {
    identifier_prefix   = "terraform-up-and-running"
    engine              = "mysql"
    allocated_storage   = 10
    instance_class      = "db.t2.micro"
    skip_final_snapshot = true
    db_name             = var.module_db_name
    username            = var.module_db_username
    password            = var.module_db_password
}
