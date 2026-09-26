module "network" {
  source = "./Modules/Network"

  project_name = var.project_name
}


module "compute" {
  source = "./Modules/Compute"

  project_name  = var.project_name
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_id        = var.key_id

  lb_sg_id           = module.network.alb_sg_id
  ec2_sg_id          = module.network.ec2_sg_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  vpc_id             = module.network.vpc_id
}


module "database" {
  source = "./Modules/Database"

  project_name      = var.project_name
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class

  db_sg_id             = module.network.db_sg_id
  db_subnet_group_name = module.network.db_subnet_group_name
}