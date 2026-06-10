locals {
  global_vars    = yamldecode(file(find_in_parent_folders("global-values.yaml")))
  environment    = local.global_vars.global.environment
  building_block = local.global_vars.global.building_block
  region         = local.global_vars.global.cloud_storage_region
  eks_version    = try(local.global_vars.global.eks_version, null)
}

# For local development
terraform {
  source = "../../modules//eks/"
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    eks_subnet_ids = ["dummy-subnet-1", "dummy-subnet-2"]
  }
}

inputs = {
  environment    = local.environment
  building_block = local.building_block
  region         = local.region
  eks_version    = local.eks_version
  subnet_ids     = dependency.network.outputs.eks_subnet_ids
}
