#!/bin/bash

ami_id="ami-09c813fb71547fc4f"
sg_id="sg-0142341bd063dfed3"
instances=("mongodb" "catalogue" "frontend")
zone_id="Z06633071XX7HF3WWN7FZ"
domain_name="buymebot.shop"

for instance in ${instances[@]}
do  
    instance_id=$(aws ec2 run-instances --image-id $ami_id --instance-type t3.micro --security-group-ids $sg_id --associate-public-ip-address --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query "Instances[0].InstanceId" --output json)
    if [ $instance_id != "frontend" ]
    then 
        IP=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi
    echo "$instance IP address: $IP"

done