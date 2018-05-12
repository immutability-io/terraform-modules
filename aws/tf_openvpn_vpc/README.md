# tf_openvpn_vpc

A vpc with private/public subnets which only has external access via an openvpn server

Requirements:
* AWS Account
* Terraform
* Ansible
* docker
* jq

Deploys:
* Standard public/private AWS VPC.  Uses the terraform registry module.
* An openvpn server with 1194/22 open
* After apply you will find a default.ovpn and other required files in your project root to drag into your favorite client (i.e. tunnelblick)

# starting from scratch

There is a remote state setup in this project... this is specifically what we run at immutability-io.  If you want something that is meant for general use look here:

https://github.com/zambien/terraform-openvpn-vpc-network

The above link is the same just without the remote state config.

# immutablity-io'ers - pulling/deploying from existing state

We assume you have a credential provider setup already so we use that profile.

`terraform init -backend-config="profile=theprofile"`

`terraform plan`

You know the rest.  

Note, if you destroy/apply you will need to setup your connection again in your vpn client.

# Credits

I used some of the code here: https://github.com/mattvonrocketstein/openvpn-ubuntu-ansible-terraform