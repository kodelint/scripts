# Scripts

Useful Scripts for AWS using **Python - Boto**

Script `CloneEC2instance.py`  is used for Clone a running AWS Instances with all the attached volumes.

```
python CloneEC2instance.py --help
usage: CloneEC2instance.py [-h] [--loglevel LOGLEVEL] [--region REGION] --instanceid INSTANCEID --keys KEYS --hostname
                           HOSTNAME --ami_description AMI_DESCRIPTION --count COUNT [--type TYPE] --subnet SUBNET

optional arguments:
  -h, --help            show this help message and exit
  --loglevel LOGLEVEL   Loglevel (default: INFO)
  --region REGION       AWS Region (default: us-west-2)
  --instanceid INSTANCEID
                        Instance id to be cloned (default: None)
  --keys KEYS           Required keys for the instance (default: None)
  --hostname HOSTNAME   Instance name (hostname.env) (default: None)
  --ami_description AMI_DESCRIPTION
                        Description for the instance (default: None)
  --count COUNT         How many clones you want.. (default: None)
  --type TYPE           Tell us about the instance type (default: m3.xlarge) (default: None)
  --subnet SUBNET       Subnet for the new cloned instance (default: None)
```

`tag_ebs_volume.py` is used to tag all the volumes based on the ec2 instances tags


### Tech

Dillinger uses a number of open source projects to work properly:

* `CloneEC2instance.py` - is used for clone a running AWS Instances with all the attached volumes.
* `tag_ebs_volume.py` - is used to tag all the volumes based on the ec2 instances tags

### Usages
```
CloneEC2Instance.py --loglevel INFO --instanceid i-xxxxxx --hostname hostname.env --ami_description 'This for only Testing purpose' --keys <keyname> --subnet subnet-xxxxx --count 3 --type t2.micro
```
<img src=http://i.imgur.com/TtrJXHm.png>

`tag_ebs_volume.py`: will tag all the volumes.

<img src=http://i.imgur.com/8wANdRq.png>

```
python findStopInstance.py --profile skynet
python /home/sroy/s3upload.py --log_dir /var/log/app_logs --bucket_name mybucket
```
<img src=http://i.imgur.com/iaxD8KX.png>

```
python clone_repo.py <<reponame>>
python orphan_elbs.py --region us-west-2 --profile test --vpc test --list
```

### Version
0.0.2
