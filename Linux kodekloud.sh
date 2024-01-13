
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

