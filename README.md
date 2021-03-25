# Deploy-Flask-on-ECS-using-Terraform
Deploys a simple Flask application to serve JSON APIs and Web requests deployed on ECS using Terraform.

# Add AWS Credentials in your workspace.
$aws configure

# Clone the code and go to the Terraform directory.
$git clone https://github.com/sangameshajm/Deploy-Flask-on-ECS-using-Terraform.git
$cd ~/Deploy-Flask-on-ECS-using-Terraform/Terraform/

# Initialize the terraform backend to download required plugins.
$terraform init

# View the blueprint of the infrastructure that will be created using files
$terraform plan

# If the plan looks good apply the changes.
$terraform apply

# Login to ECR registry from the output displayed from apply command.
$aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 895274709841.dkr.ecr.eu-west-1.amazonaws.com

# Build docker image using Docker file in Flask directory.
$cd ~/Deploy-Flask-on-ECS-using-Terraform/Flask/
$docker build -t ecr_assignment .

# Tag the docker image
$docker tag ecr_assignment:latest 895274709841.dkr.ecr.eu-west-1.amazonaws.com/ecr_assignment:latest

# Push to the registry. This will start a task/Flask app in ECS.
$docker push 895274709841.dkr.ecr.eu-west-1.amazonaws.com/ecr_assignment:latest

# To destroy the infrastructure if not needed anymore
$terraform destroy
