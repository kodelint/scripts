import csv
from pprint import pprint
from boto import ec2

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


def main():
	[AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY] = get_profile_credentials('default')
	ec2conn = ec2.connect_to_region('us-west-2', aws_access_key_id=AWS_ACCESS_KEY_ID, aws_secret_access_key=AWS_SECRET_ACCESS_KEY)
	reservations = ec2conn.get_all_instances()
	instances = [i for r in reservations for i in r.instances]
	csvfile = open('PROD01-stopped_ec2.csv', 'wb')
	writer = csv.writer(csvfile)
	for i in instances:
		if i.state == 'stopped' and i.private_ip_address is not None:
			print("Instance ID : " + "[" + i.id + "]" + " Name:" + " [" + i.tags['Name'] + "] " + " IP Address : " + "[" + i.private_ip_address + "]" + " Instance State : " + "[" + i.state + "]" + " Launch Time :" + "[" + i.launch_time + "]" + " Stopped Time : " + "[" + i.reason + "]")
			writer.writerow([i.id, i.tags['Name'], i.private_ip_address, i.state, i.launch_time, i.reason])

	csvfile.close

if __name__ == '__main__':
	main()
	exit(0)
