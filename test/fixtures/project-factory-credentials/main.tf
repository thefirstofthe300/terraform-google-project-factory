/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  version = "~> 1.20"
}

provider "google-beta" {
  #credentials = "${file(local.credentials_file_path)}"
  version = "~> 1.20"
}

resource "random_id" "main" {
  byte_length = 4
}

locals {
  suffix                  = "${random_id.main.hex}"
  project_factory_archive = "${path.module}/files/project-factory.tar"
  remote_credentials_path = "../../../credentials.json"
  terraform_user          = "terraform"
  ssh_pkey_path           = "${path.module}/files/sshkey"
  ssh_pkey                = "${tls_private_key.main.private_key_pem}"
}

resource "google_service_account_key" "main" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "gce-keypair-pk" {
  content  = "${tls_private_key.main.private_key_pem}"
  filename = "${local.ssh_pkey_path}"
}

resource "null_resource" "archive" {
  provisioner "local-exec" {
    command     = "git archive -o ${local.project_factory_archive} --prefix project-factory/ HEAD"
    working_dir = "${path.module}/../../.."
  }

  triggers {
    uuid = "${uuid()}"
  }
}

data "template_file" "project-factory-tfvars" {
  template = "${file("${path.module}/templates/terraform.tfvars.tpl")}"

  vars {
    org_id           = "${var.org_id}"
    billing_account  = "${var.billing_account}"
    credentials_path = "${local.remote_credentials_path}"
  }
}
