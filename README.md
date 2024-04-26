# Terraform Examples: <span style="color: orange">AWS Glue</span>: <span style="color: green">Lambda<span/>

An example on deploying a simple lambda and simple lambda functionurl with terraform and codebuild

Terraform configuration is divided into 3 parts:
1. **Infrastructure**: Resource and services which are used regardless of code branch, e.g. S3 bucket, execution IAM role, any other persistent resources or services
2. **Deployment**: CodeBuild IAM and Project to deploy a branch or branches. I decided I wanted a separate CodeBuild ROle per branch, otherwise CodeBuild role would belong under infrastructure.
3. **Application**: The Glue Job(s). Created and updated as part of deployment

### Some notes:

I work primarily on Windows OS, and the purpose of this repo is to capture terraform/AWS details, not to accomodate every OS under the sun. 

Everything has been tested and works at the time of publish, but this being AWS infrastructure at some point it will no longer be supported. One of the many hidden costs of using AWS.    

I am assuming several non-trivial requirements have been set up and are working:
* Nodejs (for client code)
* AWS ClI installed and configured
* GitHub installed and configured

## AWS Components Created

* IAM: Role and Policy
* CodeBuild + WebHook for GitHub
* S3: For application terraform tfstate
* Lambda: 
  * Simple
  * FunctionURLs 
    * Public
    * IAM Secured 


### Standing up a Lambda:

The code terraform uses backend state which is stored in `s3://${infrastructure_bucketname}/${deploy_branch}/terraform/lambda.tfstate`

1. Stand Up Infrastructure
    1. initialize terraform
       ```shell
       cd infrastructure
       terraform init -backend-config="region=us-west-1" -backend-config="bucket=my-tfstate-project-bucket" -backend-config="key=$BRANCH/my-project/infrastructure.tfstate"
       ```
    2. terraform plan to check for errors and review resources to be created
       ```shell
       terraform plan
       ``` 
    3. terraform apply to stand up resources
       ```shell
       terraform apply -auto-approve
       ```
2. Stand Up CodeBuild for a branch (let's pretend we have a branch named `dev-branch`)
    1. initialize terraform
       ```shell
       cd deploy
       terraform init -backend-config="region=us-west-1" -backend-config="bucket=my-tfstate-project-bucket" -backend-config="key=dve-branch/my-project/infrastructure.tfstate"
       ```
    2. terraform plan to check for errors and review resources to be created
       ```shell
       terraform plan -var "branch=dev-branch"
       ```
    3. terraform apply to stand up resources
       ```shell
       terraform apply -auto-approve -var "branch=dev-branch"
       ```
3. Trigger a CodeBuild Build

    Application deployment is managed through a CodeBuild project, which can be launched manually, or triggered by a webhook when changes are `push`ed to the branch

### Tearing down a Glue Job

The process is exactly opposite of standing up

1. Manually Destroy Lambdas:

    The buildspec creates an application.tfvars file and uploads to `s3://${infrastructure_bucketname}/${deploy_branch}/terraform/lambda.tfvars`

    You can use aws cli to copy this file locally then run `terraform destroy`:
    ```shell
    cd code/terraform
    aws s3 cp s3://terraform-examples-aws-lambda/main/terraform/init.tfvars init.tfvars
    aws s3 cp s3://terraform-examples-aws-lambda/main/terraform/application.tfvars lambda.tfvars
    terraform init -backend-config="init.tfvars" 
    terraform destroy -var-file="application.tfvars"
    ```

2. Tear down the CodeBuild using terraform

    ```shell
    cd deploy
    terraform destroy
    ```

3. Tear down the infrastructure using terraform

    ```shell
    cd infrastructure
    terraform destroy
    ```