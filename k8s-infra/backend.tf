terraform {
  backend "remote" {
    organization = "orent2020"

    workspaces {
      name = "CardinalDemo"
    }
  }

  required_version = ">= 0.14.0"
}
