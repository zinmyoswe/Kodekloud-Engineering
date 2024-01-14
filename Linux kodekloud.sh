
https://kodekloudhub.github.io/kodekloud-engineer/docs/projects/nautilus

######################################## Create user ###############################

1.For security reasons the xFusionCorp Industries security team has decided to use custom Apache users for each web application hosted, rather than its default user. This will be the Apache user, so it shouldnt use the default home directory.
Create the user as per requirements given below:

a. Create a user named rose on the App server 1 in Stratos Datacenter.

b. Set its UID to 1439 and home directory to /var/www/rose.

tony@stapp01
sudo useradd -m rose -u 1439 -d /var/www/rose
cat /etc/passwd/ | grep -i rose

######################################## Create group ###############################
groupadd groupname
useradd -G groupname rose
#testing user is having or not
id rose 
cat /etc/passwd |grep rose

######################################## Create a Linux User with non-interactive shell ###############################
adduser ravi  -s /sbin/nologin
-s is shell

######################################## User Expiry ###############################
useradd -e "2021-12-07" rose
-e is expiry

######################################## Linux Archive ###############################

ll /data

#tar file is an archive format. These files take the place of the more widely-known zip file format and are used for both storage and transportation of groups of related files and/or directories between devices.
tar -czcf mariyam.tar.gz /data/mariyam

tar: This is the command-line utility used for archiving files and directories.
-czcf: These are options used with the tar command:
-c: Create a new archive.
-z: Compress the archive using gzip.
-f: Allows you to specify the filename of the archive.
mariyam.tar.gz: This is the name of the archive that will be created.
/data/mariyam: This is the path to the directory or files that will be included in the archive.

ll
mv mariyam.tar.gz /home/

######################################## Linux File Permission ###############################
ls -lsd /tmp/xfusioncorp.sh

-ltr: Options used with ls:
-l: Outputs the long format listing, which includes permissions, number of links, owner, group, size, and modification time.
-t: Sorts the list by modification time (newest modified files first).
-r: Displays the list in reverse order (oldest files first).

chmod o+rx /tmp/xfusioncorp.sh

chmod: This command is used to change the permissions of a file or directory.
o+rx: These are the permission changes being applied:
o: Stands for "others" (those who are neither the owner nor in the group).
+rx: Adds read and execute permissions.
r: Grants read permission.
x: Grants execute permission.

cat /tmp/xfusioncorp.sh

ls -lsd /tmp/xfusioncorp.sh
exit

sh /tmp/xfusioncorp.sh
#The sh command invokes the default shell and uses its syntax and flags. 
#the shell linked to the /usr/bin/sh path is the default shell. 

######################################## Linux Access Control List ###############################
'getfacl' checking ACL
'setfacl' This is a command used in Linux to set Access Control Lists (ACLs) for files and directories.
 
getfacl /etc/hostname
id username

'setfacl -m u:ravi:-,rod:r /etc/hostname'

getfacl /etc/hostname

-m:  modify the ACLs of a file or directory.

u:anita:-:  It's trying to modify the ACL for user anita by removing (-) some permissions. However, in your provided command, the specific permission to be removed is not specified. It's likely that the intention was to remove all permissions, which is denoted by - in ACLs.

eric:r: This part adds a permission to the user eric by granting them read (r) access to the file /etc/hostname.

/etc/hostname: This is the path to the file /etc/hostname whose ACLs are being modified by this command.


######################################## Linux Remote Copy ###############################
 scp /tmp/nautilus.txt.gpg steve@stapp02:/tmp/
 ssh steve@stapp02
 cp nautilus.txt.gpg /home/opt
ls -la

######################################## Create a Cron Job Linux Server ###############################

yum install cronie -y

# Start cron service & check the  status 

systemctl start crond.service
systemctl status crond.service

#Check cron job for user root
crontab -u root -l

#Create a cronjob  as per the task for root user
#Crontab stands for “cron table”. It allows to use job scheduler, which is known as cron to execute tasks.
crontab -e
insert cron in vi editor

#Check cron job for user root
crontab -l

#validation
ll /tmp
watch -n 5 ls -l /tmp

####################################### Cron schedule deny to users ###############

touch /etc/cron.allow
touch /etc/cron.deny
vi /etc/cron.allow
rose
vi /etc/cron.deny
eric

systemctl restart crond.service
systemctl status crond.service

####################################### Linux time zones ###############
#check existing Time Zone set for server
timedatectl
timedatectl --help

#set the time zone  & verify it 
timedatectl set-timezone America/Blanc-Sablon
timedatectl

####################################### Linux Firewalld Setup- Apache & Nginx server ###############
#check the existing Apache httpd & Nginx service status.
systemctl status httpd && systemctl status nginx

#Get the Apache & Nginx Listen port 
#this is checking 8096 nginx
grep -i Listen /etc/httpd/conf/ht* /etc/nginx/nginx.conf/ht*

yum install -y firewalld

#Start the firewalld service , Enable and Check the status 
systemctl start Firewalld
systemctl enable Firewalld
systemctl status Firewalld

#Allow the nginx port
firewall-cmd --permanent --zone=public --add-port=8096/tcp

#Allow services http & https port 
firewall-cmd --permanent --zone=public --add-service={http,https}

#Allow the Apache http  port  with LB host IP
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address=172.16.238.14 port protocol=tcp port=8083 accept'

#run and validate
systemctl enable nginx && systemctl status nginx
systemctl enable httpd && systemctl status httpd

firewall-cmd --reload 
systemctl restart firewalld 
firewall-cmd zone=public --list-all

####################################### Firewall Rule ###############
#backup server
ssh clint@172.20.238.16

sudo su -

firewall-cmd --permanent --zone=public --add-port=6100/tcp

firewall-cmd --reload
systemctl restart firewalld
firewall-cmd --zone=public --list-all

####################################### Linux Resource Limits ###############
a. soft limit = 1024
b. hard_limit = 2027

#edit soft and hard limit
vi /etc/security/limits.conf
nfsuser soft nproc 1024
nfsuser hard nproc 2027

cat /etc/security/limits.conf | grep nproc | grep -v ^#


------------------#######################################

----------------- Linux Level II ------------------------

------------------#######################################

####################################### Linux Banner ###############
Update the message of the day on all application and db servers for Nautilus. 
Make use of the approved template located at '/tmp/nautilus_banner' on jump host

1.  Copy the '/tmp/nautilus_banner' using scp command from jumpserver to  
all Apps & DB servers.

#checking
ls -l /home/thor/nautilus_banner

#scp is security copy
scp -r /home/thor/nautilus_banner tony@stapp01:/tmp
scp -r /home/thor/nautilus_banner steve@stapp02:/tmp
scp -r /home/thor/nautilus_banner banner@stapp03:/tmp
scp -r /home/thor/nautilus_banner peter@stdb01:/tmp

-r: Recursively copy entire directories.

ssh tony@stapp01
sudo su -

mv /home/thor/nautilus_banner /etc/motd

#checking
ssh tony@stapp01

#For only dbserver
sudo yum install openssh-clients-y

####################################### Linux Find Command ###############
a. On App Server 2 at location /var/www/html/ecommerce find out all files (not directories) having .php extension.

b. Copy all those files along with their parent directory structure to location /ecommerce on same server.

c. Please make sure not to copy the entire /var/www/html/ecommerce directory content.

find: The command used for searching files and directories.

/var/www/html/ecommerce: The starting directory for the search.
-type f: Specifies that only files should be considered, not directories.
-name '*.php': Filters files based on the name, looking for files with the ".php" extension.
-exec cp --parents {} /ecommerce \;: For each file found, execute the cp command with the --parents option to copy the file to the "/beta" directory
while preserving its original directory structure.

#checking content
ls -l /ecommerce 

#finding file
find /var/www/html/ecommerce -type f -name '*.php'

#checking count
find /var/www/html/ecommerce -type f -name '*.php' | wc -l

find /var/www/html/ecommerce -type f -name '*.php' -exec cp --parents {} /ecommerce \; 

#validate
ls -l /ecommerce 


####################################### Install Anisible ###############
Install ansible version 2.6.10 on Jump host.

To Install specific ansible version, required ansible repo ( refer below video)

ansible --version

vi /etc/yum.repos.d/ansible.repo

[ansible]

name=Ansible RPM repository for Enterprise Linux 7 - $basearch

baseurl=https://releases.ansible.com/ansible/rpm/release/epel-7-$basearch/

enabled=1

gpgcheck=1

gpgkey=https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub

#check 
cat ansible.repo 

yum install ansible 4.10.0 
OR
sudo pip3 install "ansible==4.10.0"

ansible --version

####################################### Install a package ###############
install the zip package on all app-servers.

check &  install zip package

The command rpm -qa | grep zip is used on Linux systems to list all installed RPM packages that contain the term "zip" in their names. 
This is useful for finding information about installed packages related to ZIP compression.

Heres a breakdown of the command:

rpm: This is the 'package manager command' on Red Hat-based Linux systems (like CentOS, Fedora, and Red Hat Enterprise Linux).
-qa: Query all installed packages.
|: Pipe symbol is used to send the output of the first command as input to the second.
grep zip: This part filters the list of installed packages to only show those containing the term "zip" in their names.

rpm -qa |grep epel-release
yum install epel-release -y

#validate
rpm -qa |grep epel-release

ssh -t steve@stapp02 "sudo yum install epel-release -y "
ssh -t steve@stapp02 "sudo rpm -qa |grep epel-release "

ssh -t banner@stapp03 "sudo yum install epel-release -y "
ssh -t banner@stapp03 "sudo rpm -qa |grep epel-release "

####################################### Linux Service ###############
Requirement 
a. Install cups package on all the application servers.

b. Once installed, make sure it is enabled to start during boot.

yum install cups -y

systemctl enable --now cups
systemctl status cups
