locals {
  ssh_public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

