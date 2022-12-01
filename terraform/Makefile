.PHONY: fmt apply plan

apply: validate
	terraform apply

validate: fmt
	terraform validate

fmt:
	terraform fmt -recursive

plan: fmt validate
	terraform plan

destroy:
	terraform destroy

init:
	terraform init

refresh:
	terraform refresh

tflint:
	tflint

tunnel:
	$(eval ENDPOINT := $(shell terraform output neptune_endpoint))
	$(eval IP := $(shell terraform output ec2_ip))
	ssh ec2-user@$(IP) -NL 8182:$(ENDPOINT):8182
