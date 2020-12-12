# aws-educate-test

## Linux, Mac, Windows (via WSL)

- If you run MS Windows, follow the instuctions below to install WSL
- Terraform is an Infrastructure as Code (IaC) language that allows easy, repeatable creation of infrastructure.
- The terraform scripts in this repo create:
    - A DMZ and a Private Subnet
    - A NAT Instance in the DMZ
    - A Linux Instance in the Private Subnet
    - The security groups needed for communication between the instances

## Setting Up Windows with Windows Subsystem for Linux (WSL)

- Enable [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- Install *Ubuntu 18.04 LTS* from the Microsoft Store
    - You will be asked for a Username and Password; this does not need to be the same as your Windows username/password

## Install AWS Command Line Tool and Terraform

- Open (WSL) Ubuntu - or your command prompt on Linux/Mac
- Add unzip
    - ```sudo apt install unzip -y```
- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)
    - ```curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"```
    - ```unzip awscliv2.zip```
    - ```sudo ./aws/install```
    - ```aws --version```
- Add $HOME/.local/bin to path
    - ```
        vim .bashrc
            if [ -d "$HOME/.local/bin" ] ; then
                PATH="$HOME/.local/bin:$PATH"
            fi
        source .bashrc
- Install [Terraform](https://www.terraform.io/downloads.html)
    - ```curl "https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip" -o "terraform.zip"```
    - ```unzip terraform.zip```
    - ```mkdir -p ~/.local/bin```
    - ```mv terraform ~/.local/bin/terraform```
    - ```terraform --version```

## Logging in to AWS Educate

- Log in to [https://www.awseducate.com](https://www.awseducate.com)
- Click the *My Classrooms* link
- Click the *Go to classroom* button alongside your desired classroom
- Under the *Your AWS Account Status* area, click the *Account Details* button
- Show the *AWS CLI* information - copy this into your *~/.aws/credentials* file
- Click the *AWS Console* button to log into the console.

## Terraform Infrastructure

- ```mkdir ~/GitRepos```
- ```cd ~/GitRepos```
- ```git clone https://github.com/michaelkemp/aws-educate-test.git```
- ```cd aws-educate-test```
- ```terraform init```
- ```terraform apply```
- Accept the changes ```yes```
- If Terraform complains about credentials, go back to the *Logging in to AWS Educate* section and re-create your ~/.aws/credentials file
- This will take a few minutes, but you should see the infrastructure appear in the AWS Console.
- Once you are finished, you can use ```terraform destroy``` to remove the infrastructure.

