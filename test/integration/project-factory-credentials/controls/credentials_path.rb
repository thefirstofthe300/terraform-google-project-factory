# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

control "credentials_path" do
  preamble = "cd project-factory/examples/simple_project"

  describe bash("#{preamble} && terraform init -no-color") do
    its('exit_status') { should eq 0 }
    its('stderr') { should eq '' }
    its('stdout') { should include 'Terraform has been successfully initialized' }
  end
  describe bash("#{preamble} && terraform plan -no-color -input=false -var-file=../../../terraform.tfvars") do
    its('exit_status') { should eq 0 }
    its('stderr') { should eq '' }
    its('stdout') { should include 'Plan: 6 to add, 0 to change, 0 to destroy' }
  end
end
