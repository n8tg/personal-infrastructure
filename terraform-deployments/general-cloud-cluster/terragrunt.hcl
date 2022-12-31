terraform {
  source = "git::git@github.com:n8tg/gke-cluster.git//.?ref=0.0.10"
  extra_arguments "common_vars" {
    commands = ["plan", "apply"]
    arguments = [
        "-var-file=${get_terragrunt_dir()}/../account-aws.tfvars",
        "-var-file=${get_terragrunt_dir()}/../account-google.tfvars"
      ]
  }
}
inputs = {
  gke_primary_node_type = "n1-standard-1"
  gke_num_nodes = 1
  cluster_ingress_domain = "gke.nategramer.com"
}

include "root_terragrunt_config" {
  path = find_in_parent_folders()
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  project = var.project_id
  region  = var.region
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

provider "helm" {
  kubernetes {
    host  = join("", ["https://", google_container_cluster.primary.endpoint])
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
    )
  }
}

provider "kubernetes" {
  host  = join("", ["https://", google_container_cluster.primary.endpoint])
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}
EOF
}