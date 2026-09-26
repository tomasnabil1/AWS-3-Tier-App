terraform {
  backend "s3" {
    bucket       = "thomas-3tier-terraform-state"
    key          = "3tier/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

  }
}
