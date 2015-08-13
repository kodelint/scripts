import os
import sys
import fabric.api
from fabric.colors import green as _green, yellow as _yellow, red as _red
from boto import ec2


os.environ['COLUMNS'] = '120'

def tag_volumes(ec2conn):
    print(_green('lets get info about all the volumes..'))
    volumes = ec2conn.get_all_volumes()
    for volume in volumes:
        instance = volume.attach_data.instance_id
        instance_tags = ec2conn.get_all_tags({'resource-id': instance})
        for instance_tag in instance_tags:
            print(_green('Adding tags to Volume: ') + _red(volume.id) + ' ' + _green('Key: ') + _red(instance_tag.name) + ' ' + _green('Value: ') + _red(instance_tag.value))
            volume.add_tag(instance_tag.name, instance_tag.value)

def main ():
    # The real work
    print(_green('Default region is us-west-2'))
    ec2conn = ec2.connect_to_region( 'us-west-2' )
    tag_volumes(ec2conn)

main()
sys.exit(0)
