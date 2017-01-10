#! /bin/bash

ec2id_container='/tmp/ec2ins.tmp'
ec2tags='/tmp/ec2tags.tmp'

# Populating the instanes ids temporary container

aws ec2 describe-tags --filters Name=resource-type,Values=instance --query 'Tags[*].[ResourceId]' --output text | sort -n | uniq >> $ins_id_container

for instanse in `cat $ec2id_container`
do
    EBS_VOL_ID=$(aws --profile PROD ec2 describe-instances --instance-ids $instanse --query 'Reservations[*].Instances[*].BlockDeviceMappings[*].[Ebs.VolumeId]' --output text)
    tagcheck=$(aws --profile PROD ec2 describe-volumes --volume-ids `echo $EBS_VOL_ID` --query 'Volumes[*].Tags[*]' --output text)
    if [ ! -n "$tagcheck" ]; then
        (aws --profile PROD ec2 describe-instances --instance-ids $instanse --query 'Reservations[*].Instances[*].Tags[*].[Key,Value]' --output text) >> $ec2tags
        # Get the tags and apply tags to the volume
        cat $ec2tags | while read line
        do
            tkey=$(echo $line | awk {'print $1'})
            tvalue=$(echo $line | awk {'print $2'})
            # Apply tags to the volume
            aws --profile PROD ec2 create-tags --resources $EBS_VOL_ID --tags Key=$tkey,Value=$tvalue
        done
    else
        echo "Volume $EBS_VOL_ID is already tagged"
    fi
done
