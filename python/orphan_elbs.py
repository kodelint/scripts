import boto.ec2.elb
import argparse
import smtplib
import os
import textwrap
import sys


def get_profile_credentials(profile_name):
    """Returns the AWS credentials based on "~/.aws/creadentials" file. Scripts assumes that you have multiple profiles, default is default profile"""
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


def send_mail(sender, receiver, subject, msg, smtp_relay='mail.example.com'):
    """Sends an email with the results"""
    msg = "From: {sender}\nTo: {receiver}\nSubject: {subject}\n".format(sender=sender,
                                                                        receiver=receiver, subject=subject) + msg
    try:
        smtp = smtplib.SMTP(smtp_relay)
        smtp.sendmail(sender, receiver, msg.format(sender=sender, receiver=receiver))
    except smtplib.SMTPException:
        return False


def obsolote_elbs(elbs, vpc_id, vpc_name):
    """Returns the obsolete elbs based on the profile and vpc"""
    print("Searching for obsolete ELBs in VPC " + vpc_name + " [" + vpc_id + "]")
    message_body = "List of OBSOLETE ELBs in " + vpc_name.capitalize() + "\n" + "\n"
    for elb in elbs:
        if elb.vpc_id == vpc_id and len(elb.instances) == 0:
            print ("VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + " Instances Count : " + str(len(elb.instances)))
            message_body += "VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + " Instances Count : " + str(len(elb.instances)) + "\n"

    send_mail("awsmon@example.com", "awsmon@example.com", "List of OBSOLETE ELBs " + vpc_name.capitalize(), message_body)


def list_all(elbs, vpc_id, vpc_name):
    """Returns all elbs based on the profile and vpc"""
    print("List of ELBs in VPC :" + vpc_name + " [" + vpc_id + "]")
    message_body = "List of ELBs in " + vpc_name.capitalize() + "\n" + "\n"
    for elb in elbs:
            print ("VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + " Instances Count : " + str(len(elb.instances)))
            message_body += "VPC ID : " + vpc_id + " VPC Name : " + vpc_name + " ELB Name : " + elb.dns_name + " Instances Count : " + str(len(elb.instances)) + "\n"

    send_mail("sroy@chegg.com", "sroy@chegg.com", "List of OBSOLETE ELBs " + vpc_name.capitalize(), message_body)


def main():
    vpcs = ['prod', 'test']
    parser = argparse.ArgumentParser(description='Find Orphaned ELBs',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter, epilog=textwrap.dedent('''
                                        please setup your boto credentails first.
                                        here's a few options:
                                         setup environment varialbes: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
                                         or create one or some of below files (boto will evaluate in order):
                                            /etc/boto.cfg
                                            ~/.boto
                                            ~/.aws/credentials
                                         and put your credentials in the file(s) with below format:
                                           [Credentials]
                                           aws_access_key_id = <your_access_key_here>
                                           aws_secret_access_key = <your_secret_key_here>'''))

    parser.add_argument('--region', default='us-west-2', action='store', help='AWS Region')
    parser.add_argument('--profile', default='default', help='Name of the connection profile in the AWS credentials file', required=True)
    parser.add_argument('--vpc', help='Which VPC you want to look for', choices=vpcs, required=True)
    parser.add_argument('--list', help='Get all ELBs in VPC', action='store_true', required=False)
    parser.add_argument('--obsolete', help='Get Orphaned ELBs in VPC', action='store_true', required=False)
    args = parser.parse_args()

    if args.vpc == 'test':
        vpc_id = 'vpc-XXXXX'
        vpc_name = args.vpc
    elif args.vpc == 'prod':
        vpc_id = 'vpc-XXXXX'
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
    else:
        print("Wrong Choice...")


if __name__ == '__main__':
    main()
    sys.exit(0)
