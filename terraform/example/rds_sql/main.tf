resource "aws_db_instance" "db" {
    identifier                  = "terraform-database"    # DB Identifier on console
    allocated_storage           = 20
    storage_type                = "gp2"             # General Purpose SSD
    engine                      = "mysql" 
    engine_version              = "8.0"             # mysql v8.0
    instance_class              = "db.t2.micro"     # Free tier t2.micro
    name                        = "test_db"
    username                    = "Terraform"        
    password                    = "password"
    multi_az                    = true  # Multiple availability zones
    skip_final_snapshot         = true  # if ommitted Finalsnahotid throws an error
    backup_retention_period     = 0
    backup_window               = "06:00-09:00" # Automates Daily Backups
    delete_automated_backups    = true  # deletes backups with DB
    deletion_protection         = false
}