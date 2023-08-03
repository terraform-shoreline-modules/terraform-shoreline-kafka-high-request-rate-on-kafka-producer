terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "high_request_rate_on_kafka_producer" {
  source    = "./modules/high_request_rate_on_kafka_producer"

  providers = {
    shoreline = shoreline
  }
}