#!/usr/bin/env python
import os
import fabric.api
from fabric.colors import green as _green, yellow as _yellow, red as _red
import sys
import argparse
import logging
import pprint
import time
import re
import datetime
from boto import ec2

# Hack to widen terminal, can be removed when Python2.7 is everywhere
os.environ['COLUMNS'] = '120'

def launch(ec2conn, ami_id, count, keys, image_type, hostname, subnet, description):
    logging.info (_yellow('getting the instance ready...'))
    #logging.info ('getting the instance ready...')
    ami = ec2conn.get_all_images(image_ids = ami_id)
    reservation = ami[0].run(max_count=count, key_name=keys, instance_type=image_type, monitoring_enabled=False, subnet_id=subnet)
    instance = reservation.instances[0]
    ec2conn.create_tags([instance.id], { "Name": hostname })
    while instance.state == u'pending':
        logging.info(_yellow("Instance state is " + _red(instance.state) + ', sleeping for 10 seconds...'))
        #logging.info("Instance state: " + instance.state)
        time.sleep(10)
        instance.update()

    logging.info(_green("Instance id: ") + _red(instance.id))
    logging.info(_green("Instance name: ") + _red(instance.tags['Name']))
    logging.info(_green("Instance state: ") + _red(instance.state))


def createAmiImage( ec2conn, name, image_id, description ):
    instances = ec2conn.get_only_instances(
        filters = {
            "instance-id": image_id
        }
    );
    logging.debug ( 'Instances response: ' + pprint.pformat( instances ) )
    node = instances[0]
    logging.info (_yellow( 'Found instance id: ') + _red(node.id) )
    #name = hostname

    ami_id = node.create_image( name, description = description, no_reboot = True, dry_run = False )
    logging.debug ( 'Create image response: ' + pprint.pformat( ami_id ) )
    return ami_id

def ami_status(ec2conn, ami_id):
    getami_id = ec2conn.get_all_images(image_ids = ami_id)
    logging.info (_yellow( 'AMI is ') + _red(getami_id[0].state) )
    while getami_id[0].state != 'available' :
        logging.info (_yellow( 'AMI is still ') + _red(getami_id[0].state) + ', sleeping for 5 seconds..')
        time.sleep(5)
        getami_id[0].update()

    logging.debug(_green( 'AMI Status' ) + _red(getami_id[0].state))
    return getami_id[0].state

def prep_image( ec2conn, ami_id):
    logging.info (_yellow( 'Wating for AMI to be available....' ))
    newami_id = ami_status( ec2conn, ami_id )
    if newami_id == 'available':
        logging.info(_green('Lets launch instance ..'))
        #launch_instance(ec2conn, ami_id)
        #ec2conn.run_instances( ami_id, key_name = keys, instance_type='m3.xlarge', dry_run = False )
    else:
        sendError (_red('Instance Failed..!'))


def sendError( message, parser ):
    logging.error( 'ERROR: ' + message )
    if parser:
        parser.print_help()
    sys.exit(1)

def main():
    # Parse Input
    parser = argparse.ArgumentParser(
        formatter_class = argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument( '--loglevel', default='INFO', action='store', help='Loglevel' )
    parser.add_argument( '--region', default='us-west-2', action='store', help='AWS Region' )
    parser.add_argument( '--instanceid', required=True, action='store', help='Instance id to be clonned ' )
    parser.add_argument( '--keys', required=True, action='store', help='Required keys for the instance ' )
    parser.add_argument( '--hostname', required=True, action='store', help='Instance name (hostname.env)' )
    parser.add_argument( '--ami_description', required=True, action='store', help='Description for the instance' )
    parser.add_argument( '--count', required=True, action='store', help='How many clones you want..' )
    parser.add_argument( '--type', action='store', help='Tell us about the instance type (default: m3.xlarge) ' )
    parser.add_argument( '--subnet', required=True, action='store', help='Subnet for the new cloned instance ' )
    args = parser.parse_args()

    # Set the logging level
    numeric_loglevel = getattr(logging, args.loglevel.upper(), None)
    if not isinstance(numeric_loglevel, int):
        raise ValueError('Invalid log level: %s' % loglevel)
    logging.basicConfig( level = numeric_loglevel, format = '%(asctime)-15s %(message)s' )

    # Debug output
    logging.debug ( 'Input was: ' + pprint.pformat( args ) )

    # Check input
    if args.hostname == '':
        sendError( 'The hostname of the node must be specified.', parser )
    elif not re.match( '^[\w\-]+\.\w+', args.hostname ):
        sendError( 'The hostname of the node with the environment is required, e.g. live-web21.prod', parser )

    # When is now?
    now = datetime.datetime.now()
    today = now.strftime( '%Y%m%d' )

    #Instance id
    image_id = args.instanceid
    logging.info (_yellow( 'Instance id given: ') + _red(image_id) )

    if args.ami_description:
        description = args.ami_description
    else:
        description = 'Cloned from: ' + args.instanceid
    logging.info (_yellow( 'AMI description given: ') + _red(description) )

    # Default image name
    name = args.hostname + '-cloned' + '-' + today
    logging.info (_yellow( 'AMI name would be: ') + _red(name) )

    if args.type:
        image_type = args.type
    else:
        image_type = 'm3.xlarge'

    logging.info (_yellow('Instance type is ') + _red(image_type))



    # The real work
    ec2conn = ec2.connect_to_region( args.region )
    ami_id = createAmiImage( ec2conn, name, image_id, description )
    logging.info(_green( 'AMI created successfully, new ami id: ') + _red(ami_id) )
    # Launching the AMI
    prep_image( ec2conn, ami_id )
    launch(ec2conn, ami_id, args.count, args.keys, image_type, args.hostname, args.subnet, description)


# What to do.
main()
sys.exit(0)
