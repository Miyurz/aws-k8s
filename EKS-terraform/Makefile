.PHONY: staging production

env:
	@test $(env) ||  echo ERROR: Please provide what cluster to provision
	echo $$?
	@if [ "$(env)" == "stg" ]; then \
	  echo staging enviro; \
	  TFVARS=staging.tfvars; \
	elif [ "$(env)" == "prod" ]; then \
	  TFVARS=production.tfvars; \
	  echo prod enviro; \
	else \
	echo ERROR: Unknown environment !!; \
	fi;

#TO DO: Ideally these states should be saved in Admin account and need to think of a way to do it 
STAGING_TF_STATE="staging.tfstate" #Change that to http://staging.infrastructure.s3.amazonaws.com later
PRODUCTION_TF_STATE="production.tfstate" #Change that to http://staging.infrastructure.s3.amazonaws.com later

#BUCKET="miyurz-eks"

test:
	@echo I run even when you dont specify $(env)

prereqs: env
	@echo $(TFVARS)
	$(shell aws --profile=$(AWS_PROFILE) s3 ls "s3://${BUCKET}" || echo "bucket doesn't exist, so creating one ";  aws --profile=$(PROFILE) s3 mb "s3://${BUCKET}" )

init: prereqs
	terraform init --backend-config=backend.hcl

provision_cluster: prereqs *.tfvars
	aws-vault exec admin --no-session --assume-role-ttl=1.5h -- terraform apply -var-file=${TFVARS} -state=${TFSTATE} --auto-approve
	
	terraform output kubeconfig > ~/.kube/config
	terraform output config-map-aws-auth > config-map-aws-auth.yaml
	kubectl get pods -n kube-system

nuke:
	terraform destroy -var-file=staging.tfvars -state=staging.tfstate --auto-approve

