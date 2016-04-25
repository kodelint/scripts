import tinys3
import datetime
from fabric.colors import green as _green, yellow as _yellow, red as _red
import os
import fnmatch
import sys
import argparse

# Hack to widen terminal, can be removed when Python2.7 is everywhere
os.environ['COLUMNS'] = '120'


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


def upload_s3(args):
    [key, value] = get_profile_credentials(args.profile)
    s3conn = tinys3.Connection(key, value, tls=True, endpoint='s3-us-west-2.amazonaws.com')
    now = datetime.datetime.now()
    dt = now.strftime("%Y%m%d%H")
    for file in os.listdir(args.log_dir):
        if fnmatch.fnmatch(file, args.pattern):
        log = os.path.join(args.log_dir,file)
            upload_file = open(log, 'rb')
            s3filelocation = "hour_id=" + dt + "/" + file
            s3conn.upload(s3filelocation, upload_file, args.bucket_name)
            print(_green('Uploading file') + " " + _red(log) + " to s3://s3-us-west-2.amazonaws.com/iedu-haproxy.log/" + s3filelocation)


def main():
    parser = argparse.ArgumentParser(
        description='Upload logs to S3',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument('--log_dir', required=True, action='store')
    parser.add_argument('--bucket_name', required=True, action='store')
    parser.add_argument('--pattern', required=True, action='store')
    parser.add_argument('--profile', help='Name of the connection profile in the AWS credentials file', required=False)
    args = parser.parse_args()

    if args.log_dir == '' or args.bucket_name == '':
        print ("Log Directory is required")
        sys.exit()
    else:
        upload_s3(args)

if __name__ == '__main__':
    # What to do.
    main()
    sys.exit(0)
