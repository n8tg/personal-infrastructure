terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply"]
    arguments = [
        "-var-file=${get_terragrunt_dir()}/../account-aws.tfvars",
        "-var-file=${get_terragrunt_dir()}/../account-google.tfvars"
      ]
  }
}

include "root_terragrunt_config" {
  path = find_in_parent_folders()
}