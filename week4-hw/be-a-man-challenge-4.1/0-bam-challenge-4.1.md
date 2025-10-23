## HW - BE A MAN CHALLENGE 4.1 (10 pts)

- Must be in github repo link
- Create a VPC in your preferred region (must have at least 3 availability zones).  
- Inside your VPC, build a single Windows bastion host within a public subnet, 
- and one Linux web server per availability zone, all  in different private subnets. 
- Each Linux web server should also display different text and pictures. 
- Take screenshots of the running WIndows bastion host, the three Linux servers (highlighting the three different AZs in each photo), 
- and a screenshot of a successful SSH connection to each Linux server from within the bastion host.

##### GetFresh network architecture

Region = Virginia (us-east-1)  
VPC subnet mask = 10.71.0.0/16  

Subnets
| col 1 | col 2| col 3|
| --- | --- | --- |  
| Public | Zone a | 10.71.1.0/24 | 
| Private | Zone a | 10.71.11.0/24 |
| Private | Zone b | 10.71.12.0/24 |
| Private | Zone C | 10.71.13.0/24 |

### Create VPC  
VPC settings  
- VPC and more  

Name tag auto-generation  

- get-fresh  

IPv4 CIDR block
- 10.71.0.0/16

Number of Availabiility Zones (AZs)  
- 3

Number of public subnets
- 1

Number of private subnets
- 3

Customize subnets CIDR blocks
- see subnets above or picture below

Nat gateways ($)  
- In 1 AZ

VPC endpoints
- none


Fill out VPC info
![fill out create vpc](1-VPC.png)
Create VPC
![create vpc](2-create-vpc-workflow.png)
View VPC
![view vpc ](3-view-vpc.png)

### Create Security Groups 

#### Public
![Public security group](4-public-security-group-bastion.png)
![Public security group](5-public-security-bastion.png)

#### Private
![private security info](6-create-private-security.png)
![create private security](7-created-private-security.png)

### Create Instances

Go to ec2 instances 

### Launch public instance

Name an Tags
- get-fresh-public-bastion

Application and OS Images (Amazon Machine Inmage)
- choose window server

Instance Type
- m7i-flex.large

Key pair (login)
- create key pair
- named it get-fresh-public-bastion
![create key pair](8-create-key-pair.png)

Network Settings
- choose edit 

VPC required
- choose vpc created

Subnet
- choose get-fresh-subnet-public1-us-east-1a

Auto-assign public IP
- enable

Firewall (security groups)
- Select existing security group

Common security groups
- get-fresh-public-bastion

![launch instance info](9-bastion-instance-info.png)
Launch instance


![launched instance](10-Launched-instance.png)

### Launch private instance for zone 1a

Amazon Linux

Create Key Pair
get-fresh-private.pem
![create private key pair](11-create-key-pair-private.png)

Network settings
- edit

VPC - required
- choose my vpc created

Subnet
- choose private subnet get-fresh-subnet-private1-us-east-1a

Auto-assign public IP
- disable

Firewall (securtiy groups)
- Select existing securtiy group

Common security groups
- choose private    get-fresh-private

Advanced details
- add script from github <https://github.com/MookieWAF/bmc4/blob/main/ec2scrpitto> to user data
- note: I will manipulate the code after I confirm everything works


### Launch private instance for zone 1b

![Theo's github script](12-github-theo-script.png)
![private instance info](13-private-instance-info.png)

Launch Instance  - private zone 1a
![sucess](14-sucess-private-instance.png)

Launch Instance -private zone 1b

![key pair for zone 1b](15-key-pair-get-fresh-private-zone1b.png)
![sucess](16-success-private-instance-zone1b.png)

Launch Instance -private zone 1c

![key pair for zone 1c](17-key-pair-get-fresh-private-zone1c.png)

Launch instance

![sucess](18-success-private-instance-zone1c.png)

### View all instances

![view all instances](19-view-all-instances.png)

### Connect to instance (Windows Bastion)

- copy private IP DNS name  

- go to RDP client  

-  Download remote desktop get-fresh-public.bastion.rdp file

- click get password
- upload private key file
>>- navigate to your get-fresh-public-bastion.pem file and open this creates your begin rsa private key now decrypt password
>>- copy password and run the get-fresh-public.bastion.rdp file and paste the password note user name will be Administrator
>>- password: k%&f0X46?h)1(myH1*Dwm&wJJCxg?!YD

![connect rdp client open windows bastion](20-connect-rdp-client.png)

![windows bastion](21-windows-bastion.png)

open a terminal in the windows bastion

ping each of your private instances to verify each

![bastion host pings](22-bastion-host-pings.png)

go into windows exporer internet and view the private instances
- go to AWS highlight the instances copy the private 1Pv4 addresses or the Private IP DNS names and type in the bastion host http:// + these addresses

>>- zone1a    http://ip-10-72-1-113.ec2.internal (bastion host)
>>- zone1a    http://ip-10-72-11-248.ec2.internal
>>- zone1b    http://ip-10-72-12-82.ec2.internal
>>- zone1c    http://ip-10-72-13-114.ec2.internal

![be a man challenge 4.1 pdf](23-bam-challenge-4.1.png)
