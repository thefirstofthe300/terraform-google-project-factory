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

variable "project_id" {
  description = "The project ID where a compute instance will be created"
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to. Either network or subnetwork must be provided."
  default     = "default"
}

variable "org_id" {
  description = "The organization ID used when running `terraform plan` on the test instance"
}

variable "billing_account" {
  description = "The billing account used when runnng `terraform plan` on the test instance"
}

variable "service_account_email" {
  description = "The email address of a service account to attach to the project-factory-credentials instance"
}
