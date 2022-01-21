#!/bin/bash
#
# Find value in running CloudFormation template in AWS account
#
# This require aws-cli and jq to be installed

# Set here AWS Profile ~/.aws/profile if it's not default
PROFILE=default

## Don't edit below

FIND=$1

if [[ -z "${FIND}" ]]; then
    echo "Syntax: $0 <StringToFind>"
    exit 1
fi

# Get all all Cloudformation stacks from AWS account
STACKS=$(aws --profile ${PROFILE} cloudformation list-stacks)
STACKID=$(echo ${STACKS} | jq -r '.StackSummaries[].StackId')

# Loop all stacks
for STACK in $STACKID
do
    TEMPLATE=$(aws --profile ${PROFILE} cloudformation get-template --stack-name ${STACK} | jq -c '.TemplateBody' | grep "${FIND}")
    # If keyword found in stack
    if [[ ! -z "${TEMPLATE}" ]]; then
        echo "Found result in Stack: $STACK"
    fi
done