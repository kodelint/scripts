import boto.ec2.elb
import argparse
import smtplib
import os
import sys


def get_profile_credentials(profile_name):
    from ConfigParser import ConfigParser
    from ConfigParser import ParsingError
    from ConfigParser import NoOptionError
    from ConfigParser import NoSectionError
    from os import path
    config = ConfigParser()
    config.read([path.join(path.expanduser("~"), '.aws/credentials')])
    try:
        aws_access_key_id = config.get(profile_name, 'aws_access_key_id')
        aws_secret_access_key = config.get(profile_name, 'aws_secret_access_key')
    except ParsingError:
        print('Error parsing config file')
        raise
    except (NoSectionError, NoOptionError):
        try:
            aws_access_key_id = config.get('default', 'aws_access_key_id')
            aws_secret_access_key = config.get('default', 'aws_secret_access_key')
        except (NoSectionError, NoOptionError):
            print('Unable to find valid AWS credentials')
            raise
    return aws_access_key_id, aws_secret_access_key


def send_mail(sender, receiver, subject, msg, smtp_relay='mail.chegg.com'):
    msg = "From: {sender}\nTo: {receiver}\nSubject: {subject}\n".format(sender=sender,
                                                                        receiver=receiver, subject=subject) + msg
    try:
        smtp = smtplib.SMTP(smtp_relay)
        smtp.sendmail(sender, receiver, msg.format(sender=sender, receiver=receiver))
    except smtplib.SMTPException:
        return False

def delete_obsolete_elbs(elbs, vpc_id, vpc_name):
    print("WARNING!! This will delete OBSOLETE elbs")
    message_body = "List of OBSOLETE ELBs in " + vpc_name.capitalize() + "has been delete"+ "\n" + "\n"
    for elb in elbs:
        if elb.vpc_id == vpc_id and len(elb.instances) == 0:
            elb.delete_load_balancer(elb.name)
            print ("VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + "............Deleted")
            message_body += "VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + " Deleted" + "\n"


def obsolote_elbs(elbs, vpc_id, vpc_name):
    print("Searching for obsolete ELBs in VPC " + vpc_name + " [" + vpc_id + "]")
    message_body = "List of OBSOLETE ELBs in " + vpc_name.capitalize() + "\n" + "\n"
    for elb in elbs:
        if elb.vpc_id == vpc_id and len(elb.instances) == 0:
            print ("VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + " Instances Count : " + str(len(elb.instances)))
            message_body += "VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + " Instances Count : " + str(len(elb.instances)) + "\n"

    send_mail("sroy@chegg.com", "sroy@chegg.com", "List of OBSOLETE ELBs " + vpc_name.capitalize(), message_body)


def list_all(elbs, vpc_id, vpc_name):
    print("List of ELBs in VPC :" + vpc_name + " [" + vpc_id + "]")
    message_body = "List of ELBs in " + vpc_name.capitalize() + "\n" + "\n"
    for elb in elbs:
            print ("VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + " Instances Count : " + str(len(elb.instances)))
            message_body += "VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + " Instances Count : " + str(len(elb.instances)) + "\n"

    send_mail("sroy@chegg.com", "sroy@chegg.com", "List of OBSOLETE ELBs " + vpc_name.capitalize(), message_body)


def main():
    # Parse Input
    vpcs = ['prod2', 'test3', 'test2', 'load2', 'dev3', 'serv2', 'core2']
    parser = argparse.ArgumentParser(description='Find Orphaned ELBs',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--region', default='us-west-2', action='store', help='AWS Region')
    parser.add_argument('--profile', help='Name of the connection profile in the AWS credentials file', required=True)
    parser.add_argument('--vpc', help='Which VPC you want to look for', choices=vpcs, required=True)
    parser.add_argument('--list', help='Get all ELBs in VPC', action='store_true', required=False)
    parser.add_argument('--obsolete', help='Get Orphaned ELBs in VPC', action='store_true', required=False)
    parser.add_argument('--delete', help='Delete Orphaned ELBs in VPC', action='store_true', required=False)
    args = parser.parse_args()

    if args.vpc == 'test3':
        vpc_id = 'vpc-4344232a'
        vpc_name = args.vpc
    elif args.vpc == 'dev3':
        vpc_id = 'vpc-4344232a'
        vpc_name = args.vpc
    elif args.vpc == 'test2':
        vpc_id = 'vpc-e646d18f'
        vpc_name = args.vpc
    elif args.vpc == 'load2':
        vpc_id = 'vpc-bacecbd3'
        vpc_name = args.vpc
    elif args.vpc == 'prod2':
        vpc_id = 'vpc-8cf706e5'
        vpc_name = args.vpc
    elif args.vpc == 'core2':
        vpc_id = 'vpc-7facb91d'
        vpc_name = args.vpc
    elif args.vpc == 'serv2':
        vpc_id = 'vpc-0276556a'
        vpc_name = args.vpc

    [aws_access_key_id, aws_secret_access_key] = get_profile_credentials(args.profile)
    elbconn = boto.ec2.elb.connect_to_region('us-west-2', aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key)
    elbs = elbconn.get_all_load_balancers()
    if args.obsolete and args.list is True:
        print("You cannot use '--list' and '--obsolete' switch together")
        sys.exit(0)
    if args.obsolete:
        obsolote_elbs(elbs, vpc_id, vpc_name)
    elif args.list:
        list_all(elbs, vpc_id, vpc_name)
    elif args.delete:
        delete_obsolete_elbs(elbs, vpc_id, vpc_name)
    else:
        print("Wrong Choice...")


if __name__ == '__main__':
    main()
    sys.exit(0)
