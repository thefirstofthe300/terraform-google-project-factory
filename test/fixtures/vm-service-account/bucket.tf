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

resource "google_storage_bucket" "main" {
  project       = "${var.project_id}"
  name          = "vm-service-account-${local.suffix}"
  force_destroy = "true"
}

resource "null_resource" "archive" {
  provisioner "local-exec" {
    command = "git archive -o ${local.project_factory_archive} --prefix project-factory/ HEAD"
    working_dir = "${path.module}/../../.."
  }

  triggers {
    uuid = "${uuid()}"
  }
}

resource "google_storage_bucket_object" "project-factory-tar" {
  bucket  = "${google_storage_bucket.main.name}"
  name    = "project-factory.tar"
  source  = "${local.project_factory_archive}"

  depends_on = ["null_resource.archive"]
}

data "template_file" "project-factory-tfvars" {
  template = "${file("${path.module}/templates/terraform.tfvars.tpl")}"

  vars {
    org_id           = "${var.org_id}"
    billing_account  = "${var.billing_account}"
    credentials_path = "${local.remote_credentials_path}"
  }
}

resource "google_storage_bucket_object" "terraform-tfvars" {
  bucket = "${google_storage_bucket.main.name}"
  name    = "terraform.tfvars"
  content = "${data.template_file.project-factory-tfvars.rendered}"
}

resource "google_storage_bucket_object" "credentials" {
  bucket = "${google_storage_bucket.main.name}"
  name    = "credentials.json"
  content = "${base64decode(google_service_account_key.main.private_key)}"
}
