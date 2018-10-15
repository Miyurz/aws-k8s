#!/bin/bash

set -eou pipefail

ORG="test"

#if [ -n "$NAME" ]; then
#    CLUSTER_NAME="pass"
#else
#    CLUSTER_NAME="fail"
#fi

#echo NAME: $NAME
#echo CLUSTER_NAME: $CLUSTER_NAME

#STATE=

# Pre-reqs for kops
#1. Kubernetes version on master
#2. AWS resources like - VPC where the k8s cluster lives
#                      - Bastion server , its internal external IP 
#                      - CIDR - admin access
#                      - image to be used for nodes
#                      - Security group - MASTER
#                      - CIDR - network CIDR
#                      - CIDR - ssh access
#                      - Security group - Nodes
#                      - Subnets
#                      - Utility subnets
#                      - Zones in which to run the cluster. Not master nodes in differenet zones!

#3. Master count
#4. Master public name
#5. Master instance size
#6. Master tenancy
#7. Master instance volume size in GB
#8. Master - number of zones(Odd)

#9.  Node count
#10. Node instance size
#11. Node tenancy
#12. Node instance volume size in GB

#13. output format = json/yaml
#14. ssh public key # create with ssh-keygen
#15. target = terraform
#16. 

function provision_aws_infra() {
 terraform 

}

function spin_k8s_cluster() {

 aws-vault exec admin --no-session --assume-role-ttl=1.5h -- env \
                                                             kops create cluster \
                                                                  --output yaml                 `# Output format. One of json|yaml. Used with the --dry-run flag.`\
                                                                  --dry-run                     `# If true,only print the object that would be sent, dont send!`\
                                                                  --state s3://s3-k8s-"${ORG}"  `#Location of state storage (kops 'config' file). Overrides KOPS_STATE_STORE environment variable`\
                                                                  --zones us-east-1a,us-east-1b,us-east-1c      `# Zones in which to run the cluster`\
   							          --name k8s."${ORG}".ai                        `#Name of cluster. Overrides KOPS_CLUSTER_NAME environment variable`\
   								  #--cloud="aws"                                   `# Cloud provider to use - gce, aws, vsphere`\
  
   								  #Mock run to check the resources that would be created ?
   							          #-y, --yes                  `# Specify --yes to immediately create the cluster`
   								  --target terraform        `# Valid targets: direct, terraform, cloudformation. Set this flag to terraform if you want kops to generate terraform`\
   								  --bastion                 `# Pass the --bastion flag to enable a bastion instance group. Only applies to private topology.`\
  								  #--model string             `# Models to apply (separate multiple models with commas) (default "proto,cloudup")`\
  								  --networking="calico"     `# Networking engine - kubenet (default), classic, external, kopeio-vxlan/kopeio), weave,flannel, flannel-udp, calico, canal, 
								                               kube-router, romana, amazon-vpc-routed-eni, cilium.`\
  								  --ssh-public-key          `# SSH public key to use (defaults to ~/.ssh/id_rsa.pub on AWS)`\
  								  --out="kops-local-log"    `# Path to write any local output`\
  								  #--output="kops.yaml"     `# Output format. One of json|yaml. Used with the --dry-run flag.`\
  								  #--project string         `# Project to use (must be set on GCE)`\
  								  #--encrypt-etcd-storage   `# Generate key in aws kms and use it for encrypt etcd volumes`\
   								  #-h, --help               `# help for cluster`\
  								  --image="debian"          `# Image to use for all instances, Refer, https://github.com/kubernetes/kops/blob/master/docs/images.md`\
  								  --kubernetes-version="1.11.2"  `# Version of kubernetes to run (defaults to version in channel)`\

 								  ##### GLOBAL OPTIONS #######
  								  --alsologtostderr              `#log to standard error as well as files`\
  								  #--config string               `#yaml config file (default is $HOME/.kops.yaml)`\
  								  #--log_backtrace_at traceLocation   #when logging hits line file:N, emit a stack trace (default :0)
								  #--log_dir string                   #If non-empty, write log files in this directory
								  --logtostderr                  `#log to standard error instead of files (default false)`\
								  --stderrthreshold "severity"   `#logs at or above this threshold go to stderr (default 2)`\
								  --v=5 ;                        `#log level for V logs`\
								  #--vmodule moduleSpec          `#comma-separated list of pattern=N settings for file-filtered logging`\

								  #AWS resources
								  --admin-access=0.0.0.0/0       `# Restrict API access to this CIDR. Default being 0.0.0.0/0 `\
								  --api-loadbalancer-type=public `#Sets the API loadbalancer type to either 'public' or 'internal' `\
								  #--api-ssl-certificate string  `# Currently only supported in AWS.Sets the ARN of the SSL Certificate to use for the API server loadbalancer.`\
								  --associate-public-ip          `# Specify --associate-public-ip=[true|false] to enable/disable association of public IP for master ASG & nodes.Default true`\
								  --authorization RBAC           `#Authorization mode to use: AlwaysAllow or RBAC, default is "RBAC"`\
								  --channel stable           `#Channel for default versions/configuration,default is stable.More here: https://github.com/kubernetes/kops/tree/master/channels`\
								  --cloud-labels "test"      `# A list of KV pairs used to tag all instance groups in AWS (eg "Owner=John Doe,Team=Some Team").`\
								  --dns=private                  `# DNS hosted zone to use: public|private. Default is 'public'. (default "Public")`\
								  --dns-zone k8s."${ORG}".ai     `# DNS hosted zone to use (defaults to longest matching zone)`\
								  #--network-cidr string         `# Set to override the default network CIDR`\
								  --ssh-access=0.0.0.0/0         `# Restrict SSH access to this CIDR.  If not set, access will not be restricted by IP. (default [0.0.0.0/0])`\
								  #--subnets strings             `# Set to use shared subnets`\
								  --topology=public              `# Controls network topology for the cluster. public|private. Default is 'public'. (default "public")`\
								  #--utility-subnets strings         `# Set to use shared utility subnets`\
								  #Check if you want to use an exiting VPC?
								  #--vpc string                      `# Set to use a shared VPC`\
								  #-y, --yes                         `# Specify --yes to immediately create the cluster`\
								  
								  ############## MASTER NODE(S) ##########
								  --master-count 1                   `# Set the number of masters.  Defaults to one master per master-zone`\
								  --master-public-name string        `# Sets the public master public name`\
								  --master-security-groups strings   `# Add precreated additional security groups to masters.`\
								  --master-size m5.xlarge         `# Set instance size for masters`\
								  --master-tenancy dedicated      `# The tenancy of the master group on AWS. Can either be default or dedicated.`\
								  --master-volume-size 40         `# Set instance volume size (in GB) for masters`\
								  --master-zones 3                `# Zones in which to run masters (must be an odd number)`\
								  
								  ############# SLAVE NODE(S) ############
								  --node-count 3                   `# Set the number of nodes`\
								  #--node-security-groups strings `# Add precreated additional security groups to nodes.`\
								  --node-size m5d.4xlarge         `# Set instance size for nodes `\
								  --node-tenancy default          `# The tenancy of the node group on AWS. Can be either default or dedicated. `\
								  --node-volume-size 40           `# Set instance volume size (in GB) for nodes ` ;
}

function nuke_k8s_cluster() {
 aws-vault exec admin --no-session --assume-role-ttl=1.5h -- env \
                                                             kops delete cluster \
							                          --yes \
							                          --name k8s."${ORG}".ai \
										  --state s3://s3-k8s-"${ORG}";
}

function main() {
  
  if [ "$#" -ne "1" ]; then
    echo ERROR: Please pass c for create or n for nuke
    exit 1
  fi

  case $1 in
	  c) 
	    echo "INFO: Spinning the cluster"
	    spin_k8s_cluster
          ;;
          n)
	   echo "INFO: Nuking the cluster"
	   nuke_k8s_cluster
	  ;;
          *)
	   echo "ERROR: Uknown option. Run me as $0 c or $0 n"
	   exit 1
	  ;;
  esac
}


main "$@"
