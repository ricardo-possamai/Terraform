terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
  }
}



# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "dop_v1_d515d933028e884acf3c1dac8a6a7f0f78ead3a68cdbe44b3fad5677af268ad2"
}
data "digitalocean_ssh_key" "jornada" {
  name = "jornada"
}


# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "jankiens_elite" {
  image  = "ubuntu-20-04-x64"
  name   = "jankiens-elite"
  region = "nyc1"
  size   = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.jornada.id]
}

# CONFIGURAÇÃO DO Cluster Kubenets

resource "digitalocean_kubernetes_cluster" "elite" {
  name   = "elite"
  region = "nyc1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = "elite-pool"
    size       = "s-2vcpu-2gb"
    node_count = 2

  }
}

resource "local_file" "foo" {
    content  = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
    filename = "kube_config.yaml"
}