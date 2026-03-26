From 9/9/25 Youtube class review
Class 7: EC2 Basics
task == Building an Amazon Linux EC2 with a custom script

Template == https://github.com/MookieWAF/bmc4/blob/main/ec2scrpit

Steps

	1. Create new security group DO NOT USE DEFAULT
name the group
copy the name into the description
Inbound rules - add rule
Type dropdown - choose HTTP
Source dropdown - Anywhere-IPv4
Description - type “webpage”

	2. Create an EC2 

	3. Copy public DMS, make it into a usable link and past the link in the chat
Make sure to can make a hyperlink by typing “http://“ before any links are made
Example: http://ec2-107-21-129-130.compute-1.amazonaws.com

Teardown instructions

Terminate the EC2 instance: This is the primary action that deletes the virtual server. During termination, all associated data is permanently erased.
Manual termination: In the AWS Management Console, you navigate to the EC2 Dashboard, select the instance, and choose Instance State > Terminate instance from the Actions menu.
