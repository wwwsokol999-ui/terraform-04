terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }

    template = {
      source = "hashicorp/template"
    }
  }

  required_version = "~>1.12.0"

  backend "s3" {
    bucket = "terraform-state-wwwsokol999-05"
    key    = "terraform.tfstate"
    region = "ru-central1"

    use_lockfile = true

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
