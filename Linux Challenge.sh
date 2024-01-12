
Always bear in mind that your own resolution to success is more important than any other one thing.
------------------------------- Linux Challenge1-----------------------------------------

sudo su -

#Install lvm
yum install -y lvm2

##dba_users
#Create group
groupadd dba_users

#Add bob
usermod -G dba_users bob

##CreatePVs
#The pvcreate command initializes a direct access storage device (a raw block device) for use as a physical volume in a volume group
pvcreate /dev/vdb
pvcreate /dev/vdc



#Create VG
#The vgcreate command creates a new volume group.
vgcreate dba_storage /dev/vdb /dev/vdc

#Create LVM
#The `lvcreate` command is used to create Logical Volumes (LVs) on Linux systems that utilize the Logical Volume Manager (LVM).
lvcreate -n volume_1 -l 100%FREE dba_storage

#Persistent mountpoint
#Format
#The mkfs. xfs command is used to create a new filesystem;
#the -b flag specifies the block size of the new filesystem.
mkfs.xfs /dev/dba_storage/volume_1

#Mount
#The mount command allows users to mount, i.e., attach additional child file systems to a particular mount point on the currently accessible file system.
mkdir -p /mnt/dba_storage
mount -t xfs /dev/dba_storage/volume_1 /mnt/dba_storage

#Make persistent
echo "/dev/mapper/dba_storage-volume_1 /mnt/dba_storage xfs defaults 0 0" >> /etc/fstab

#group ownership for dba_users
chown :dba_users /mnt/dba_storage

#rwi permission for owner and group, no permission for anyoneelse
chmod 770 /mnt/dba_storage

#The pvs command provides physical volume information
pvs

#The lvs command provides logical volume information
lvs
df -h /mnt/dba_storage
id bob

------------------------------- Linux Challenge2-----------------------------------------
'NGINX' is open source software for web serving, reverse proxying, caching, load balancing, media streaming, and more. 
It started out as a web server designed for maximum performance and stability.

Benefits of 'NGINX'
Reduces the waiting time to load a website. You dont have to worry about high latency on your websites

sudo su -
yum install -y nginx firewalld



#######################security######################
#start and enable "firewalld" service
systemctl is a command-line tool that allows for the management and monitoring of the systemd system and service manager
start, stop, enable, disable, and mask a system service with the systemctl command.
systemctl command to manage services and control when they start.

systemctl enable firewalld
systemctl start firewalld

#Add firewall rules to allor only incoming port "22,80,8081" and make permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8081/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent

firewall-cmd --reload

####################### GoApp ######################
The 'pushd' command is used to save the current directory into a stack and move to a new directory
nohup : Prepends the command, making it resistant to hangups and continuing to run even if the terminal is closed.
Start GoApp by running the "nohup go run main.go &" command from "/home/bob/go-app/" directory

pushd /home/bob/go-app/
nohup go run main.go &

#wait for it to be running (usually 15-20 seconds as it has to compile first)
while ! ps -faux | grep -P '/tmp/go-build\d+/\w+/exe/main'
do
	sleep 2
done

##Explanation
while : Starts a loop.
!: Negates the condition, making the loop continue until the process is not found.
ps -faux: Command to list all processes with full information.
grep -P '/tmp/go-build\d+/\w+/exe/main': Searches for the pattern in the output of ps.
sleep 2: Pauses the loop for 1 second to prevent excessive resource usage while repeatedly checking.

sleep 2
popd #it is opposite of pushd

####################### Nginx ######################
sed -i '48i\          proxy_pass http://localhost:8081;' /etc/nginx/nginx.conf

vi /etc/nginx/nginx.conf
press 48 and add 'proxy_pass http://localhost:8081;'

#Start nginx
systemctl enable nginx
systemctl start nginx
systemctl status nginx

------------------------------- Linux Challenge3-----------------------------------------
sudo su-

####################### admin ######################
groupadd admins

####################### david,Natasha ######################
useradd -s /bin/zsh david

#giving password"
echo "D3vUd3raaw" | passwd --stdin david
echo "DwfawUd113" | passwd --stdin natasha

#usergroup
usermod -G admins david

####################### devs ######################
groupadd devs

####################### ray and lisa ######################
useradd -s /bin/sh ray

#giving password"
echo "D3vU3r321" | passwd --stdin ray
echo "D3vUd3r123" | passwd --stdin lisa

#usergroup
usermod -G devs ray

####################### bob,data ######################
/data is owned by "bob" and group "devs"
chown -R bob:devs /data/
chmod 770 /data/

####################### sudo ######################
"admins" group can run all command with sudo and without entering any password
echo '%admins ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

####################### sudo(dnf) ######################
"devs" group can only run "dnf" command with sudo and without entering any password
echo '%devs ALL=(ALL) NOPASSWD:/usr/bin/dnf' >> /etc/sudoers

####################### limits ######################
resource limit for "devs" group
echo '@devs     - nproc     30' >> /etc/security/limits.conf

####################### quota ######################
edit disk quota for "devs"group
setquota -g devs 100M 500M  0 0 /dev/vdb1
quota -g -s devs /data

------------------------------- Linux Challenge4-----------------------------------------
sudo su -

####################### find ######################
mkdir -p /opt/appdata/hidden
mkdir -p /opt/appdata/files

#hidden
find /home/bob/preserved -type f -name ".*"
find /home/bob/preserved -type f -name ".*" -exec cp "{}" /opt/appdata/hidden/ \;
ls -a #view hidden file

#find /home/bob/preserved: Starts the find command in the specified directory.

-type f: Specifies that it should only find files (not directories).
-name ".*": Matches files with names starting with a dot (hidden files).
-exec cp "{}" /opt/appdata/hidden/ \;: Executes the cp (copy) command for each found file, copying it to the specified destination.
In summary, this command is recursively searching for hidden files under /home/bob/preserved and copying them to /opt/appdata/hidden/.

#no hidden
find /home/bob/preserved -type f -not -name ".*" -exec cp "{}" /opt/appdata/files/ \;
OR
find /home/bob/preserved -type f -name "[!.]*" -exec cp "{}" /opt/appdata/files/ \;


-not -name ".*": Excludes files with names starting with a dot (hidden files).

#delete files with words end in 't'
rm -f $(find /opt/appdata/ -type f -exec grep -l 't\>' "{}" \; )
OR
find /opt/appdata/ -type f -exec grep -l 't$' "{}" \; -delete
#explanation
find /opt/appdata/ -type f: Starts the find command in the specified directory and searches for files (not directories).
-exec grep -l 't\>' "{}" \;: Executes the grep command for each found file, looking for lines that contain the whole word 't' and prints the filenames of the matching files.
$(...): Command substitution. The output of the find and grep combination is used as arguments to the rm -f command.
rm -f: Removes files forcefully without prompting for confirmation.
In summary, this command removes files in the /opt/appdata/ directory and its subdirectories if they contain the letter 't' as a whole word.

####################### replcae ######################
#change all occurences of the word "yes" to "no"
find /opt/appdata -type f -name "*" -exec sed -i 's/\<yes\>/no/g' "{}" \;
#validate
find /opt/appdata -type f -name "*" -exec grep -l 'yes' "{}" \;
find /opt/appdata -type f -name "*" -exec grep -l 'no' "{}" \;
#change all occurences of the word "raw" to "processed"
find /opt/appdata -type f -name "*" -exec sed -i 's/\<raw\>/processed/ig' "{}" \;
ig => case sensitive

####################### permission ######################
chmod +t /opt/appdata/
#validate file permission
ls -ld /opt/appdata/

####################### appdata.tar.gz ######################
#create a "tar.gz" archive of "/opt/appdata" directory and save the archive to this file "/opt/appdata.tar.gz"

tar zcvf /opt/appdata.tar.gz /opt/appdata

tar: The basic tar command.
-z: Compress the archive using gzip.
-c: Create a new archive.
-f appdata.tar.gz: Specifies the name of the archive file (appdata.tar.gz).
appdata: The directory to be archived.

chown bob: /opt/appdata.tar.gz
chmod 440 /opt/appdata.tar.gz

The first digit (4) corresponds to read permission.
The second digit (4) corresponds to read permission.
The third digit (0) corresponds to no permission.
So, specifically, the permissions are set as follows:

The owner (user) has read permission.
The group has read permission.
Others have no permission.

####################### softlink ######################
#ln command is used to create links between files or directories. 
-s symbiolic link
ln -s /opt/appdata.tar.gz /home/bob/appdata.tar.gz
#validate
ls -l /home/bob/

####################### filter.sh ######################
touch /home/bob/filter.sh
OR
cat <<'EOF' > /home/bob/filter.sh
#!/bin/bash

cat: Concatenates and displays the content.
<<'EOF': This starts a here document. The EOF is a delimiter that indicates the end of the document. The single quotes around 'EOF' ensure that no variable substitution will occur within the here document.
> /home/bob/filter.sh: Redirects the content of the here document to the file /home/bob/filter.sh.

tar -xzOf /opt/appdata.tar.gz | grep processed > /home/bob/filtered.txt
EOF

tar -xzOf /opt/appdata.tar.gz: Extracts the contents of the gzip-compressed tar archive /opt/appdata.tar.gz to the standard output (-O option).
|: Pipes the output of the tar command to the next command.
grep processed: Filters the lines containing the word "processed."
> /home/bob/filtered.txt: Redirects the filtered output to a file named filtered.txt in the /home/bob/ directory.


OR
vi /home/bob/filter.sh
#!/bin/bash
tar -xzOf /opt/appdata.tar.gz | grep processed > /home/bob/filtered.txt


####################### filter.txt ######################
#execute our script
touch /home/bob/filtered.txt
cd /home/bob/

ls -l
chmod +x filter.sh
+x execute permission.

./filter.sh

cat /home/bob/filtered.txt




------------------------------- Linux Challenge5-----------------------------------------
sudo su -

####################### network ######################
#cheking ip list
ip a
ip addr add 10.0.0.50/24 dev eth1
#validation
ip a

####################### dns ######################
vi /etc/hosts/
10.0.0.50 mydb.kodekloud.com
ping mydb.kodekloud.com

####################### root ######################
#unlock of root account
usermod --help
usermod -U root
# root is a member of wheel group
sudo id root
usermod -aG wheel root
sudo id root

####################### database ######################
#install mariadb" database on this server
#star/enable its service

#checking data center os
cat /etc/os-release
#checking mariadb existing features
yum search mariadb
yum install -y mariadb mariadb-server

systemctl status mariadb

#check system
sudo system+tab
systemctl enable --now mariadb
systemctl status mariadb

####################### security ######################
#set a password for mysql root user to "S3cure#321"
#enter as root user
mysql -u root

#checking database
show databases;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'S3cure#321';

#checking password is update or not
mysql -u root -p
exit()

####################### pam ######################
#we can different service on different module

cd /etc/pam.d/
ls
cat login

#wheel group can use 'su' command and  no need password
sudo vi su
delete # 

####################### docker image ######################
#pull nginx docker image

####################### docker container ######################
#create and run a new docker container base on ngix image
#container name is "myapp" and port 80 host have to be mapped
sudo docker run -itd --name myapp -p 80:80 nginx
-itd interactive terminal detect

#validation
sudo docker ps

####################### container-start.sh ######################
#create container-start.sh user /home/bob/ , it able to start in myapp container
#and display message "myapp container start"
cd
pwd
vi container-start.sh
#!/bin/bash

sudo docker start myapp
echo "myapp container started"

vi container-stop.sh
sudo docker stop myapp
echo "myapp container stopped"

ls -l

#add ececute permission
chmod +x container-st*
ls -l

#check script is work or not 
sudo docker ps
./contain-stop.sh
sudo docker ps
./contain-start.sh
sudo docker ps

####################### cronjob ######################
cronjob is to run script daily
#root user, contain-stop script at 12 am everyday
#root user, contain-start script at 8 am everyday
sudo crontab -u root -e
0 0 * * * /home/bob/container-stop.sh
0 8 * * * /home/bob/container-start.sh

sudo crontab -l -u root






















