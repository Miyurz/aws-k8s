#!/bin/bash

set -eou pipefail

STATE_STORE="s3://k8s-miyurz"
CLUSTER_NAME="k8s.miyurz.ai"
BASE_IMAGE="099720109477/ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180405"
DNS_ZONE="k8s.miyurz.ai"

VPC_ID="vpc-01533e0fd0e4135bc"
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

#function provision_aws_infra() {
 #terraform 

#}

   								  ##Mock run to check the resources that would be created ?
   							          ##-y, --yes                  `# Specify --yes to immediately create the cluster`
  								  #--model string             `# Models to apply (separate multiple models with commas) (default "proto,cloudup")`\
  								  #--ssh-public-key    \
  								  #--out kops-local-log    `# Path to write any local output`\
  								  #--output="kops.yaml"     `# Output format. One of json|yaml. Used with the --dry-run flag.`\
  								  #--encrypt-etcd-storage   `# Generate key in aws kms and use it for encrypt etcd volumes`\
  								  #--config string               `#yaml config file (default is $HOME/.kops.yaml)`\
  								  #--log_backtrace_at traceLocation   #when logging hits line file:N, emit a stack trace (default :0)
								  #--log_dir string                   #If non-empty, write log files in this directory
								  #--network-cidr string         `# Set to override the default network CIDR`\
function spin_k8s_cluster() {

 aws-vault exec admin --no-session --assume-role-ttl=1.5h -- env \
                                                             kops create cluster \
                                                                  --output yaml                 `# Output format. One of json|yaml. Used with the --dry-run flag.`\
                                                                  `#--dry-run       If true,only print the object that would be sent, dont send!`\
								  --state "${STATE_STORE}"  `#Location of state storage (kops 'config' file). Overrides KOPS_STATE_STORE environment variable`\
                                                                  --zones us-east-1a,us-east-1b,us-east-1c      `# Zones in which to run the cluster`\
   							          --name "${CLUSTER_NAME}"                        `#Name of cluster. Overrides KOPS_CLUSTER_NAME environment variable`\
   								  --cloud "aws"                                   `# Cloud provider to use - gce, aws, vsphere`\
   								  --vpc "${VPC_ID}" \
								  --target "terraform"        `# Valid targets: direct, terraform, cloudformation. Set this flag to terraform if you want kops to generate terraform`\
								  --topology private               `# Controls network topology for the cluster. public|private. Default is 'public'. (default "public")`\
   								  --bastion              \
  								  --networking calico    \
  								  --image "${BASE_IMAGE}" \
  								  --kubernetes-version "1.11.0"   \
  								  --alsologtostderr              `#log to standard error as well as files`\
								  --logtostderr                  `#log to standard error instead of files (default false)`\
								  --stderrthreshold 2   `#logs at or above this threshold go to stderr (default 2)`\
								  --v 5                        `#log level for V logs`\
								  --admin-access "0.0.0.0/0" \
								  --api-loadbalancer-type=public \
								  --associate-public-ip=true \
								  --authorization RBAC       \
								  --channel stable      \
								  --cloud-labels "Owner=Mayur,Team=SRE"      `# A list of KV pairs used to tag all instance groups in AWS (eg "Owner=John Doe,Team=Some Team").`\
								  --dns=private                  `# DNS hosted zone to use: public|private. Default is 'public'. (default "Public")`\
								  --dns-zone "${DNS_ZONE}"     `# DNS hosted zone to use (defaults to longest matching zone)`\
								  --ssh-access "0.0.0.0/0"         `# Restrict SSH access to this CIDR.  If not set, access will not be restricted by IP. default [0.0.0.0/0]`\
								  --master-count "3"                `# Set the number of masters.  Defaults to one master per master-zone`\
								  --master-public-name "k8s-master"        `# Sets the public master public name`\
								`#--master-security-groups strings   # Add precreated additional security groups to masters.`\
								  --master-size m5.xlarge            `# Set instance size for masters`\
								  --master-tenancy dedicated      `# The tenancy of the master group on AWS. Can either be default or dedicated.`\
								  --master-volume-size 40         `# Set instance volume size (in GB) for masters`\
								  --master-zones "us-east-1b,us-east-1c,us-east-1a"                `# Zones in which to run masters (must be an odd number)`\
								  --node-count "3"                   `# Set the number of nodes`\
								  `#--node-security-groups strings  Add precreated additional security groups to nodes.`\
								  --node-size m5d.4xlarge         `# Set instance size for nodes `\
								  --node-tenancy default          `# The tenancy of the node group on AWS. Can be either default or dedicated. `\
								  --node-volume-size 40           `# Set instance volume size in GB for nodes ` \
                                                                  --yes ;
}

function nuke_k8s_cluster() {
 aws-vault exec admin --no-session --assume-role-ttl=1.5h -- env \
                                                             kops delete cluster \
							                          --yes \
							                          --name k8s."${ORG}".ai \
										  --state "${STATE_STORE}";
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
