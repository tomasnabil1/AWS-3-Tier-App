variable "project_name" {
    description = "The name of the project"
    type = string 
}

variable "ami_id" {
  type = string
}

variable "key_id" {
    type = string 
}

variable "instance_type" {
    type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ec2_sg_id" {
  type = string
}