#!/bin/bash

set -xv

# Define parameters
stack_name="MyEC2Stack"
aws_region="eu-central-1"
template_file="ec2-template.yaml"
allowed_CIDR="88.135.185.19/18"
vpc_id="vpc-05dc26c3a348b96bd"
ec2_ami_id="ami-04e601abe3e1a910f"

key_name=$(aws cloudformation describe-stacks \
    --stack-name $stack_name \
    --query "Stacks[0].Outputs")

validation_output=$(aws cloudformation validate-template \
    --template-body file://$template_file 2>&1)

if [ ! $? -eq 0 ]; then
    echo "Validation failed. Error message:"
    echo "$validation_output"
    exit 1
else
    echo "Validation successful. Proceeding with stack creation..."


    # Deploy the CloudFormation stack
    aws cloudformation create-stack \
    --stack-name $stack_name \
    --template-body file://$template_file \
    --region $aws_region \
    --parameters ParameterKey=AllowedCIDR,ParameterValue=$allowed_CIDR \
                 ParameterKey=MyVpcId,ParameterValue=$vpc_id \
                 ParameterKey=MyAmiId,ParameterValue=$ec2_ami_id # ParameterKey=KeyName,ParameterValue=$key_name \

    # Wait for the stack to complete (you can add more robust error handling)
    aws cloudformation wait stack-create-complete --stack-name $stack_name

    # Optionally, retrieve EC2 instance information
    instance_id=$(aws cloudformation describe-stacks \
    --stack-name $stack_name \
    --query "Stacks[0].Outputs[?OutputKey=='InstanceID'].OutputValue" \
    --output text)

    echo "EC2 Instance ID: $instance_id"

fi