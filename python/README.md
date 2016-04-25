# Scripts

Useful Scripts for AWS using Python - Boto

Script CloneEC2instance.py  is used for Clone a running AWS Instances with all the attached volumes.
```
CloneEC2instance.py  [-h] [--loglevel LOGLEVEL] [Required] [--region REGION] [Required] --instanceid INSTANCEID --keys KEYS --hostname HOSTNAME --ami_description AMI_DESCRIPTION --count COUNT [--type TYPE] [Required] --subnet SUBNET [Required]
```
Srcipt tag_ebs_volume.py is used to tag all the volumes based on the EC2 instance TAGS

`tag_ebs_volume.py`


### Version
0.0.1

### Tech

Dillinger uses a number of open source projects to work properly:

* [CloneEC2instance.py] - Script CloneEC2instance.py  is used for Clone a running AWS Instances with all the attached volumes.
* [tag_ebs_volume.py] - Srcipt tag_ebs_volume.py is used to tag all the volumes based on the EC2 instance TAGS

### Usages
```
CloneEC2Instance.py --loglevel INFO --instanceid i-xxxxxx --hostname hostname.env --ami_description 'This for only Testing purpose' --keys <keyname> --subnet subnet-xxxxx --count 3 --type t2.micro
```
<img src=http://i.imgur.com/TtrJXHm.png>

`tag_ebs_volume.py` [Will tag all the volumes]

<img src=http://i.imgur.com/8wANdRq.png>

`python findStopInstance.py --profile skynet`

`python /home/sroy/s3upload.py --log_dir /var/log/app_logs --bucket_name mybucket`

<img src=http://i.imgur.com/iaxD8KX.png>

`python clone_repo.py <<reponame>>`

### Todo's



License
----
MIT
