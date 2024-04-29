


######################################## docker overview ##########

messaging system =>redis
orchestration => ansible

######################################## docker basic command ##########
#will run an instance of the nginx app on docker host
docker run nginx

#lists all running container and some basic info(eg.containerid,image,containername)
docker ps

#to see the container is running or not
#show both run and stopped container
docker ps -a

#stop
#after that check status
docker stop <containername> or <containerid>
docker ps -a

#remove
#deleted exited container permenantly
docker rm <containername> or <containerid>
docker ps -a

#list images on our host
docker images

#rmi
#delete all dependent container
***before delete, must stop and delete all dependent containers to be able to delete image
docker rmi nginx

#pull - download an image
#it download the ubuntu image as it couldn't find one locally
docker run ngix

#only pull image and not run the container
docker pull nginx

#run an instance of ubuntu image and exits immediately
docker run ubuntu

Once the task is complete, the container exits
if not process or work, the container exits

#when container starts, it runs to sleep command and goes into sleep for five sec
docker run ubuntu sleep 5

#exec - execute
#execute a command on running container
docker ps -a
#to print the content of /etc/hosts files
docker exec <containername> cat /etc/hosts

#Run - attach and detach
#in attach mode, attach to the console
#see output of webservice on the screen
docker run kodekloud/simple-webapp

#-d is detach mode, this will run the docker container in background mode.
docker run -d kodekloud/simple-webapp

#only write first 4 character of id
docker attach <containerid>

######################################## Demo docker basic command ##########
#download latest image and version
docker run centos

#to continuously docker run
docker run -it centos bash

#check OS, i am now reaching on centos OS
cat /etc/*release*

exit

docker ps
#run in background
docker run -d centos sleep 20
#after 20 sec, it is gone
docker ps
docker ps -a 




-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------1.Docker Install--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
1.Install docker-ce and docker-compose packages on App Server 1.
Start docker service.

#Docker CE is the Community Edition, while Docker EE is the Enterprise Edition.

ssh tony@stapp01
sudo su -

curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

#Make sure to set  executable permission
ls -l /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ls -l usr/local/bin/docker-compose

#Validate by running version
docker-compose --version

#To install docker-ce  need to configure repo from below link
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#Docker command-line interface (CLI), and containerd.io (an industry-standard container runtime).
#install docker
yum install docker-ce docker-ce-cli container.io

#Verify  docker installed successfully 
rpm -qa | grep docker

#Enable & start the docker service
systemctl enable docker
systemctl start docker
systemctl status docker

#validate
docker --version
docker ps
docker-compose --version

Solution
https://kodekloud.com/community/t/unable-to-install-on-centos-vm/19418/2


-----------------------------------------------------2.Run a Docker Container--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
#check the existing docker  Images & container  running
docker ps
docker images


#This command runs a Docker container named "nginx_1" in detached mode (-d flag) using the nginx:alpine image. It maps port 8080 of the host to port 80 of the container (-p 8080:80). This means that any traffic directed to port 8080 on the host will be forwarded to port 80 inside the container where nginx is running.
#pull the image and name the container make sure it's in running 
docker run -d --name nginx_1 -p 8080:80 nginx:alpine

docker ps
# Validate the task by Curl
curl http://localhost:8080

-----------------------------------------------------3.delete Docker Container--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
#check the existing docker container  running
docker ps

#stop from container running
docker stop kke-container
docker ps

#checking the create and stop time of container
docker ps -a
docker rm kke-container


-----------------------------------------------------4.docker copy operations--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
#check running container
docker ps

#copy from to
docker cp /tmp/natilus.txt.gpg ubuntu_latest:/tmp/

#exec: This subcommand is used to execute a command in a running container.
-it: These are options that are often used together. They stand for "interactive" and "pseudo-TTY" and they allow you to interact with the shell in the container.
docker exec -it ubuntu_latest /bin/bash

cd /tmp/
ls


-----------------------------------------------------4.Docker Container Issue--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
docker ps
#checking the create and stop time of container
docker ps -a 

docker start nautilus
#can be seen nautilus container
docker ps

#It seems like you're trying to use the curl command to send a request to http://localhost:8080/'.
curl http://localhost:8080/


-----------------------------------------------------Task2 1.Docker Container Issue--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
docker images
docker pull busybox:musl
docker images
docker tag busybox:musl busybox:blog

-----------------------------------------------------Task2 2.Docker Update Permissions--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
#check admin has execute permission or not
getent group docker

#permissions to interact with Docker without needing to use sudo for every Docker command.
sudo usermod -aG docker anita

#check anita has execute permission or not
getent group docker

-----------------------------------------------------Task2 3.Create a Docker Image From Container--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
#check docker container and image running
docker ps

#The docker commit command is used to create a new image based on the changes made to a containe
docker commit ubuntu_latest ecommerce:nautilus
docker images

-----------------------------------------------------4.Docker Level 2 - Task 4 - Docker EXEC Operations--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
#checking running container name
docker ps

docker exec -it kkloud sh
apt install apache2 -y
cd /etc/apache2
cat ports.conf
vi ports.conf
apt install vim -y

change listen port 8082
service apache2 status
service apache2 start
service apache2 status

-----------------------------------------------------5. Docker Level 2 - Task 5 - Write a Docker File-------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
cd /opt/docker
ls
vi Dockerfile

FROM ubuntu

RUN apt-get update && apt-get install -y apache2

RUN sed -i 's/Listen 80/Listen 5004/g' /etc/apache2/ports.conf

EXPOSE 5004

CMD ["apache2ctl","-D","FOREGROUND"]

cat Dockerfile

#docker build: This is the command to build a Docker image.
docker build . -t apache-image
docker images

#docker run: This command is used to run a Docker container.
docker run -p 5004:5004 apache-image

Login again
docker ps

-----------------------------------------------------5. Docker Level 3 - Task 1 - Create a Docker Network-------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
docker network ls

#check for network create with driver
docker network create --help
docker network create official --driver macvlan --subnet <> --ip-range <>

#validate
docker network ls