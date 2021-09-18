# Terraform AWS Initialization

To create a new environment, you'll need to make a new workspace.

Run `terraform workspace new <your_env_name>`

This example repo already comes with a pre-made staging and prod environment.

*NOTE* - The state files are stored locally, this should be a ran only by a trusted system administrator.

Saving the state files somewhere safe might be a good idea. Take care in saving this in a safe location.

Copy and paste `Makefile` commands for the workspace, plan, apply, and destroy.

Replace with your new environment name. 