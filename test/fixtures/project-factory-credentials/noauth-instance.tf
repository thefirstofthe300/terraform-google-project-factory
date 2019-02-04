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

resource "google_compute_instance" "noauth" {
  name         = "pf-credentials-noauth-${local.suffix}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  project      = "${var.project_id}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "${var.network}"

    access_config {}
  }

  metadata {
    sshKeys = "${local.terraform_user}:${tls_private_key.main.public_key_openssh}"
  }

  provisioner "file" {
    content     = "${base64decode(google_service_account_key.main.private_key)}"
    destination = "/home/terraform/credentials.json"

    connection {
      type        = "ssh"
      user        = "${local.terraform_user}"
      private_key = "${local.ssh_pkey}"
    }
  }

  provisioner "file" {
    source      = "${local.project_factory_archive}"
    destination = "/home/terraform/project-factory.tar"

    connection {
      type        = "ssh"
      user        = "${local.terraform_user}"
      private_key = "${local.ssh_pkey}"
    }
  }

  provisioner "file" {
    content     = "${data.template_file.project-factory-tfvars.rendered}"
    destination = "/home/terraform/terraform.tfvars"

    connection {
      type        = "ssh"
      user        = "${local.terraform_user}"
      private_key = "${local.ssh_pkey}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "tar -xf project-factory.tar -C ~terraform",
      "~terraform/project-factory/helpers/init_debian.sh",
    ]

    connection {
      type        = "ssh"
      user        = "${local.terraform_user}"
      private_key = "${local.ssh_pkey}"
    }
  }
}
