Kubernetes namespace CRUD
https://kodekloud.com/blog/kubectl-create-namespace/

######################################## Create Pods in Kubernetes Cluster ###############################
A Kubernetes pod is a collection of one or more Linux® containers, and is the smallest unit of a Kubernetes application. 

#kubectl get namespace command is used with Kubernetes to list all the namespaces in your Kubernetes cluster.

kubectl get namespace

#The kubectl get pods command is used to list all the pods running in the current Kubernetes cluster.

kubectl get pods

vi /tmp/pod.yaml

YAML is writing configuration files
#yaml file

apiVersion: v1
kind: Pod
metadata:
    name: pod-httpd
    labels:
      app: httpd_app
spec:
    containers:
    - name: httpd-container
      image: httpd:latest
      
      
kubectl create -f /tmp/pod.yaml

#validation
kubectl get pods

#waiting for pods running status
kubectl get pods

######################################## Create Deployments in Kubernetes Cluster ###############################
Task => Create a deployment named nginx to deploy the application nginx using the image nginx: latest (remember to mention the tag as well) 


The command 'kubectl' get deploy is used with Kubernetes, a popular container orchestration system, to retrieve information about deployments. When you run this command, 
it fetches details about the deployments currently running in the Kubernetes cluster.

kubectl get deploy
kubectl get namespaces
kubectl get deploy -n default
kubectl get deployment

#checking pods are exist or not
kubectl get pods

So, 'kubectl get deploy -n' default specifically fetches deployment information from the "default" namespace. 
The "default" namespace is where Kubernetes resources are created if no specific namespace is specified during resource creation.

-n default: The flag specifying the namespace, in this case, "default."

#Create deploy & and run image as per the task reques
kubectl create deploy nginx --image nginx:latest

#validation
kubectl get pods -o wide
kubectl get deployment

#existing pod to describe
kubectl describe pod nginx-55649fd747-8qq78

OR
cat >deploy.yml
k apply -f deploy.yml
k get deploy
k get pods

######################################## Create Namespaces in Kubernetes Cluster ###############################
Create a namespace named 'dev' and create a POD under it; 
name the pod 'dev-nginx-pod' and use nginx image with latest tag only and 
remember to mention tag i.e 'nginx:latest'.

kubectl get namespace

kubectl get pods -n dev

kubectl create namespace dev

kubectl get namespace

#create a pod
kubectl run dev-nginx-pod --image=nginx:latest -n dev

-n dev: This specifies the namespace in which to create the pod.
 The pod will be created in the "dev" namespace.
 
kubectl get pods -n dev

kubectl describe pod dev-nginx-pod -n dev

######################################## Set Limits for Resources in Kubernetes ###############################
Question : Recently some of the performance issues were observed with some applications hosted on Kubernetes cluster. The Nautilus DevOps team has observed some resources constraints where some of the applications are running out of resources like memory, cpu etc., and some of the applications are consuming more resources than needed. Therefore, the team has decided to add some limits for resources utilization. Below you can find more details.
Create a pod named httpd-pod and a container under it named as httpd-container, use httpd image with latest tag only and remember to mention tag i.e httpd:latest and set the following limits:

Requests: Memory: 15Mi, CPU: 1
Limits: Memory: 20Mi, CPU: 2
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

kubectl get namespace
kubectl get pods

vi /tmp/limit.yaml
cat /tmp/limit.yaml

apiVersion: v1
kind: Pod
metadata:
  name: httpd-pod
spec:
  containers:
  - name: httpd-container
    image: httpd:latest
    resources:
      requests:
        memory: "15Mi"
        cpu: "100m"
      limits:
        memory: "20Mi"
        cpu: "100m"
		
kubectl create -f /tmp/limit.yaml

#validation
kubectl get pods

kubectl describe pods httpd-pod

######################################## rolling updates in kubernetes ###############################
#what is rolling updates in kubernetes
Overview. You can perform a rolling update to update the images, configuration, labels, annotations, and resource limits/requests of the workloads in your clusters.
Rolling updates incrementally replace your resource s Pods with new ones, which are then scheduled on nodes with available resources.

Question : There is a production deployment planned for next week. The Nautilus DevOps team wants to test the deployment update and rollback on Dev environment first so that they can identify the risks in advance. Below you can find more details about the plan they want to execute.

Create a namespace 'xfusion'. Create a deployment called 'httpd-deploy' under this new namespace, 
It should have one container called 'httpd', use 'httpd:2.4.25' image and 6 replicas. 
The deployment should use RollingUpdate strategy with maxSurge=1, and maxUnavailable=2.

Next upgrade the deployment to version httpd:2.4.43 using a rolling update.

Finally, once all pods are updated undo the update and roll back to the previous/original version.

#checking namespace and deployment is exist or not
kubectl get namespace
kubectl get deployment -n xfusion

vi /tmp/httpd.yaml

kubectl create namespace xfusion

kubectl get namespace
#Create yaml  file with all the parameters


apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: xfusion
spec:
  replicas: 6
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.19
		  
		  

		  

		  
		  
maxSurge=1:
This specifies the maximum number of additional pods that can be created beyond the desired number of replicas during an update. 
In this case, it allows only one additional pod to be created at a time.

maxUnavailable=2:
This specifies the maximum number of pods that can be unavailable (not running) during the update. 
In this case, it allows up to two pods to be unavailable at any given time.


#create pod
kubectl apply -f /tmp/httpd.yaml --namespace=xfusion

#Wait for  pods to get running status
kubectl get pods -n xfusion
kubectl get deployment -n xfusion -o wide

#Perform  rolling update by running below command
kubectl set image deployment/httpd-deploy httpd-httpd:2.4.43 --namespace xfusion --record=true

#validate rollback is success or not
kubectl get pods -n xfusion
kubectl get deployment -n xfusion -o wide

#Rollback the deployment as per task  
kubectl rollout status deployment httd-deploy n -xfusion
kubectl rollout history deployment httd-deploy n -xfusion
kubectl rollout undo deployment httd-deploy n -xfusion
kubectl rollout status deployment httd-deploy n -xfusion

#validate rollback is success or not again
kubectl get pods -n xfusion
kubectl get deployment -n xfusion -o wide

'OR'

kubectl set image deployment/nginx-deployment nginx=nginx:1.19 --record=true

kubectl get deployment nginx-deployment -o=jsonpath='{.spec.template.spec.containers[*].name}'
kubectl get deployment nginx-deployment -o yaml
kubectl set image deployment/nginx-deployment <container-name>=nginx:1.19 --record

kubectl set image deployment/nginx-deployment nginx-container=nginx:1.19 --record
kubectl rollout status deployment/nginx-deployment
kubectl describe deployment nginx-deployment


######################################## Rollback a Deployment in Kubernetes ###############################

Question : This morning the Nautilus DevOps team rolled out a new release for one of the applications. Recently on of the customers logged a complaint which seems to be about a bug related to the recent release. Therefore, the team wants to roll back the recent release.

There is a deployment named 'nginx-deployment'; roll it back to the previous revision.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.

#check existing deployment and pods running status 
kubectl get deploy
kubectl get pods

#Run the below command to roll back to an earlier release 
kubectl rollout undo deployment nginx-deployment

#Wait for deployment & pods to get running status
kubectl get deploy
kubectl get pods

kubectl get deploy
kubectl get pods

kubectl rollout status deployment nginx-deployment

######################################## Create Replicaset in Kubernetes Cluster ###############################

kubectl get deploy
kubectl get services

vi /tmp/httpd.yaml
cat /tmp/httpd.yaml

#create pod
kubectl create -f /tmp/httpd.yaml

# pods to get running status
kubectl get pods

######################################## Create Cronjobs in Kubernetes ###############################
#check the existing pod & cronjob
kubectl get pod
kubectl get cronjob

vi /tmp/cron.yml
cat /tmp/cron.yml

#create a pod
kubectl create -f /tmp/cron.yml

#validate
kubectl get cronjob
kubectl get pod
kubectl get pods -o wide

#checking pod name logs
kubectl logs nautilus-1627054320-f6xl6

######################################## countdown job in kubernetes ###############################

kubectl get services
kubectl get pods

vi /tmp/devops.yaml

#create pods
kubectl create -f /tmp/devops.yaml

kubectl get pods

kubectl logs <pods-name>

######################################## Kubernetes Time Check Pod ###############################


kubectl get namespace
kubectl get pods

kubectl create namespace xfusion

vi /tmp/time.yaml
cat /tmp/time.yaml

apiVersion: v1

kind: ConfigMap

metadata:

  name: time-config

  namespace: xfusion

data:

  TIME_FREQ: "4"

---

apiVersion: v1

kind: Pod

metadata:

  name: time-check

  namespace: xfusion

  labels:

    app: time-check

spec:

  volumes:

    - name: log-volume

      emptyDir: {}

  containers:

    - name: time-check

      image: busybox:latest

      volumeMounts:

        - mountPath: /opt/itadmin/time

          name: log-volume

      envFrom:

        - configMapRef:

            name: time-config

      command: ["/bin/sh", "-c"]

      args:

        [

          "while true; do date; sleep $TIME_FREQ;done > /opt/itadmin/time/time-check.log",

        ]

kubectl create -f /tmp/time.yaml
kubectl get pods -n xfusion

######################################## Troubleshoot Issue With Pods ###############################

kubectl get pods

kubectl describe pod webserver

kubectl edit pod webserver

kubectl get pods

######################################## Update an Existing Deployment in Kubernetes ###############################


kubectl get deploy

#checking existing service to edit
kubectl get service

#checking existing deployment to edit
kubectl get pod


kubectl edit service nginx-service

kubectl get service

kubectl edit deploy nginx-deployment

kubectl get deploy

# check the running status
kubectl get pods

#Wait for  deployment & pods to get ready & running status
kubectl get deploy

kubectl get pods

######################################## Replication Controller in Kubernetes ###############################

kubectl get namespace

kubectl get pod

vi /tmp/replica.yaml

apiVersion: v1
kind: ReplicationController
metadata:
  name: httpd-replicationcontroller
  labels:
    app: httpd_app
    type: front-end
spec:
  replicas: 3
  selector:
    app: httpd_app
  template:
    metadata:
      name: httpd_pod
      labels:
        app: httpd_app
        type: front-end
    spec:
      containers:
        - name: httpd-container
          image: httpd:latest
          ports:
            - containerPort: 80		

#create pods
kubectl create -f /tmp/replica.yaml

kubectl get pods

#Validate the task
kubectl exec <pod-name>  -- curl http://localhost

######################################## vloume mount in Kubernetes ##########
#The kubectl get configmap command is used to retrieve information about ConfigMaps in a Kubernetes cluster. 
#ConfigMaps in Kubernetes are used to store configuration data in key-value pairs, which can be consumed by pods or other resources in the cluster.

kubectl get pods

kubectl get configmap

kubectl describe configmap nginx-config

#-o yaml: This flag specifies the output format as YAML.


kubectl get configmap nginx-config -o yaml

#checking optional (no need)
kubectl cp /tmp/index.php nginx-phpfpm:/var/www/html -c nginx-container

#checking wrong path ‘/usr/share/nginx/html’
kubectl describe pod/nginx-phpfpm -n default

kubectl get pod nginx-phpfpm -o yaml  > /tmp/nginx.yaml
ls /tmp/nginx.yaml

#Edit the nginx.yaml file and changed ‘/usr/share/nginx/html’ to ‘/var/www/html’ in 3 places. 
cat /tmp/nginx.yaml |grep /usr/share/nginx/html

#in mountPath
vi /tmp/nginx.yaml

cat /tmp/nginx.yaml

#Post changes the mount path run below command to replace the running pods
kubectl replace -f /tmp/nginx.yaml --force

kubectl get pods

#validate
kubectl describe pod/nginx-phpfpm -n default

ll /home/thor/

ls

cat index.php

kubectl cp index.php nginx-phpfpm:/index.php -c nginx-container

kubectl exec -it nginx-phpfpm -c nginx-container  -- /bin/bash

ls -al

cp index.php /var/www/html
cd /var/www/html
ls
cat index.php









#####################################################################
---------------------------------------------------------------------
---------------------------------------------------------------------
//*-------------- Level 2 ---------------------------------------*//
---------------------------------------------------------------------
---------------------------------------------------------------------
#####################################################################


######################################## Kubernetes Shared Volumes ##########

kubectl get service
kubectl get pod

vi /tmp/volume.yaml

apiVersion: v1
kind: Pod
metadata:
  name: volume-share-nautilus
  labels:
    name: myapp
spec:
  volumes:
    - name: volume-share
      emptyDir: {}
  containers:
    - name: volume-container-nautilus-1
      image: centos:latest
      command: ["/bin/bash", "-c", "sleep 10000"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/media
    - name: volume-container-nautilus-2
      image: centos:latest
      command: ["/bin/bash", "-c", "sleep 10000"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/games


# create a pods
kubectl create -f /tmp/volume.yaml

kubectl get pods

kubectl exec -it volume-share-nautilus -c vloume-container-nautilus-01 -- /bin/bash

cd /tmp/media
touch media.txt

exit

kubectl exec -it volume-share-nautilus -c vloume-container-nautilus-02 -- /bin/bash

cd /tmp/games
touch media.txt

######################################## Kubernetes Sidecar containers ##########
what is it?=> Sidecar containers work alongside the main container, extending its functionality and providing additional services.

why use =>A sidecar container can handle data synchronization tasks, keeping the data in the primary container(s) in sync with external databases or services. 
It can replicate data across multiple primary container instances to ensure consistency and availability.

kubectl get services

kubectl get pods

vi /tmp/webserver.yaml

apiVersion: v1
kind: Pod
metadata:
  name: webserver
  labels:
    name: webserver
spec:
  volumes:
    - name: shared-logs
      emptyDir: {}
  containers:
    - name: nginx-container
      image: nginx:latest
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
    - name: sidecar-container
      image: ubuntu:latest
      command:
        [
          "/bin/bash",
          "-c",
          "while true; do cat /var/log/nginx/access.log /var/log/nginx/error.log; sleep 30; done",
        ]
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx 	


#Run the below command to create a pod
kubectl create -f /tmp/webserver.yaml

#validate
kubectl get pods
kubectl describe pods