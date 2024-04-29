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

######################################## Deploy Nginx Web Server on Kubernetes Cluster ##########
kubectl get namespace
kubectl get pods

vi /tmp/nginx.yml

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx-app
    type: front-end
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30011
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-app
    type: front-end
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-app
      type: front-end
  template:
    metadata:
      labels:
        app: nginx-app
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest

kubectl create -f /tmp/nginx.yml
kubectl get pods

#validate
kubectl exec <pod-name> -- curl http://localhost
######################################## differnce between pods and deployment  ##########

In this simplified representation, the "Deployment" encapsulates a "ReplicaSet," and the "ReplicaSet" manages multiple "Pods," each hosting one or more containers.
 The "Pods" directly contain and run the application containers.

  +---------------------+
  |      Deployment     |
  |                     |
  |  +---------------+  |
  |  | ReplicaSet    |  |
  |  |               |  |
  |  | +-----------+ |  |
  |  | |   Pods    | |  |
  |  | |           | |  |
  |  | | +-------+ | |  |
  |  | | | Pod   | | |  |
  |  | | +-------+ | |  |
  |  | +-----------+ |  |
  |  +---------------+  |
  +---------------------+

  +---------------------+
  |        Pods         |
  |                     |
  |  +---------------+  |
  |  | Container 1  |  |
  |  +---------------+  |
  |  +---------------+  |
  |  | Container 2  |  |
  |  +---------------+  |
  |  +---------------+  |
  |  | Container 3  |  |
  |  +---------------+  |
  +---------------------+

######################################## Print Environment Variables ##########

kubectl get pods

vi /tmp/env.yml

apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
  labels:
    name: print-envars-greeting
spec:
  restartPolicy: Never
  containers:
    - name: print-env-container
      image: bash
      env:
        - name: GREETING
          value: "Welcome to"
        - name: COMPANY
          value: "Stratos"
        - name: GROUP
          value: "Datacenter"
      command: ["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"']


#pod create
kubectl create -f /tmp/env.yml

#validate
kubectl get pods
#see the greeting message
kubectl logs <pod-name>

######################################## difference of namespace and deployment ##########
                            +-------------------------+
                            |     Kubernetes Cluster  |
                            |-------------------------|
                            |         Node 1          |
                            |-------------------------|
                            |         Node 2          |
                            |-------------------------|
                            |         Node N          |
                            +------------+------------+
                                         |
                               +---------+----------+
                               |   Namespaces        |
                               |---------------------|
                               |      Namespace 1    |
                               |---------------------|
                               |      Namespace 2    |
                               |---------------------|
                               |      Namespace N    |
                               +---------+----------+
                                         |
                            +------------+-----------+
                            |       Deployments       |
                            |-------------------------|
                            |   Deployment 1          |
                            |-------------------------|
                            |   Deployment 2          |
                            |-------------------------|
                            |   Deployment N          |
                            +-------------------------+

Kubernetes cluster consists of nodes running Kubernetes components.
Namespaces provide logical isolation within the cluster.
Deployments manage the lifecycle of application pods within namespaces, ensuring desired state and handling updates.

######################################## Rolling Updates And Rolling Back Deployments in Kubernetes ##########

kubectl get namespace

kubectl create namespace xfusion

vi /tmp/httpd.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deploy
  namespace: devops
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 2
  selector:
    matchLabels:
      app: httpd
  template:
    metadata:
      labels:
        app: httpd
    spec:
      containers:
        - name: httpd
          image: httpd:2.4.25
---                                                                                                           
apiVersion: v1                                                                                                
kind: Service                                                                                                 
metadata:                                                                                                     
  name: httpd-service  
  namespace: devops  
spec:                                                                                                         
   type: NodePort                                                                                             
   selector:                                                                                                  
     app: httpd                                                                                     
   ports:                                                                                                     
     - port: 80                                                                                               
       targetPort: 80                                                                                         
       nodePort: 30008

		  
#create pods under namespace
kubectl create -f /tmp/httd.yaml --namespace=xfusion

kubectl get pods -n xfusion
kubectl get deployment -n xfusion

#rolling update by running below command
kubectl set image deployment httpd-deploy httpd=httpd:2.4.43 --namespace xfusion --record=true

#Rollback the deployment as per tasks
kubectl rollout undo deployment httpd-deploy -n xfusion

#validate
kubectl rollout status deployment httpd-deploy -n xfusion
kubectl get pods -n xfusion
kubectl get deployment -n xfusion -o wide
kubectl describe deploy httpd-deploy -n xfusion


######################################## Deploy Jenkins on Kubernetes ##########

why=> Deploy Jenkins on Kubernetes
Kubernetes ability to orchestrate container deployment ensures that Jenkins always has the right amount of resources available. 
Hosting Jenkins on a Kubernetes Cluster is beneficial for Kubernetes-based deployments and dynamic container-based scalable Jenkins agents.

what is => Jenkins on Kubernetes
Jenkins on Kubernetes is the integration of the Jenkins automation server with the Kubernetes container orchestration platform. 
This combination streamlines the deployment, scaling, and management of Jenkins instances and build environments.

Advantages => of scaling Jenkins on Kubernetes
If your build or your agent gets corrupted, you no longer need to worry — Jenkins will remove the unhealthy instance and spin up a new one.

kubectl get namespace
kubectl get service

kubectl create namespace jenkins

vi /tmp/jenkins.yaml

apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
  namespace: jenkins
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30008

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-deployment
  namespace: jenkins
  labels:
    app: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      containers:
        - name: jenkins-container
          image: jenkins/jenkins
          ports:
            - containerPort: 8080
			
			
#create pod
kubectl create -f /tmp/jenkins.yaml

#Wait for deployment & pods to get running status
kubectl get deployment -n jenkins
kubectl get pod -n jenkins
kubectl get service -n jenkins

#Validate the task by curl or open the browser by clicking 'Open Port on Host 1'
kubectl exec <deployment-name> -n jenkins -- curl http://localhost:8080

#for login jerkin
kubectl exec <deployment-name> -n jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword

######################################## Deploy Grafana on Kubernetes Cluster ##########
why => Deploy Grafana on Kubernetes Cluster
Grafana provides a powerful interface for creating and visualizing dashboards, connecting to various data sources, and setting up alerts and notifications. 
Using Helm to provision Grafana on a Kubernetes cluster simplifies the deployment process and allows for easy customization and management.


Why use Kubernetes Monitoring in Grafana Cloud?
Accelerate time to value. Reduce deployment, setup, and troubleshooting time with this ready-to-use monitoring tool that only requires running a few CLI commands or adding some small changes to your Helm chart.
Identify root causes faster. ...
Reduce costs.

kubectl get pods
kubectl get services

vi /tmp/grafana.yaml

apiVersion: v1
kind: Service
metadata:
  name: grafana-service-nautilus
spec:
  type: NodePort
  selector:
    app: grafana
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 32000

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-deployment-nautilus
spec:
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
        - name: grafana-container-nautilus
          image: grafana/grafana:latest
          ports:
            - containerPort: 3000
			
			
kubectl create -f /tmp/grafana.yaml
kubectl get service
kubectl get pods

######################################## Deploy Tomcat App on Kubernetes ##########
kubectl create namespace tomcat-namespace-xfusion
vi /tmp/tomcat.yaml

apiVersion: v1
kind: Service
metadata:
  name: tomcat-service-xfusion
  namespace: tomcat-namespace-xfusion
spec:
  type: NodePort
  selector:
    app: tomcat
  ports:
    - port: 80
      protocol: TCP
      targetPort: 8080
      nodePort: 32227
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tomcat-deployment-xfusion
  namespace: tomcat-namespace-xfusion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tomcat
  template:
    metadata:
      labels:
        app: tomcat
    spec:
      containers:
        - name: tomcat-container-xfusion
          image: gcr.io/kodekloud/centos-ssh-enabled:tomcat
          ports:
            - containerPort: 8080


kubectl create -f /tmp/tomcat.yaml

kubectl get pods -n tomcat-namespace-xfusion
kubectl get service
kubectl get deploy -n tomcat-namespace-xfusion

kubectl exec <pod-name> -n tomcat-namespace-xfusion -- curl http://localhost:8080

######################################## Deploy Node App on Kubernetes ##########

vi /tmp/node.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodeapp-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodeapp
  template:
    metadata:
      labels:
        app: nodeapp
    spec:
      containers:
      - name: nodeapp
        image: gcr.io/kodekloud/centos-ssh-enabled:node
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: nodeapp-service
spec:
  type: NodePort
  selector:
    app: nodeapp
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 30012



kubectl apply -f /tmp/node.yaml

kubectl get pods
kubectl get service 
kubectl get deploy 

######################################## Troubleshoot Deployment issues in Kubernetes ##########

kubectl get deployment
kubectl get pods
kubectl get configmap

kubectl describe deployment
kubectl describe configmap

#can be seen redis-cofig not found, so, we change redis-cofig to redis-config
kubectl describe pods

kubectl edit deployment

#search
#pressing / and then typing your search pattern/word.
/cofig
change 'cofig' to 'config'

/alphin
change 'alphin' to 'alpine'


#validation
#be sure running in pods and ready in deployment
kubectl get deployment
kubectl get pods

######################################## Kubernetes Level 2 - Task 11 - Fix issue with LAMP Environment in Kubernetes##########



#A LAMP stack is a bundle of four different software technologies that developers use to build websites and web applications. 
kubectl get deploy
kubectl describe deploy lamp-wp

#will see portno is wrong
kubectl get service

#change port no
kubectl edit service lamp-service

change node port to 30008

kubectl get configmap
kubectl describe configmap <configmap-name> eg.php-config

kubectl get deploy
kubectl get pods
kubectl describe pods <pod-name>

kubectl get pods
kubectl exec -it <pod-name> -c httpd-php-container -- sh
ls
cd app/
ls
cat index.php

copy index.php
exit
vi index.php
CHANGE MYSQL-Host to MYSQL_Host
CHANGE MYSQL-PASSWORDS to MYSQL-PASSWORDS

kubectl create configmap --help
kubectl create configmap index --from-file=index.php


kubectl get configmap
#MYSQLHost was updated
kubectl describe configmap index
kubectl edit deployment lamp-wp

below SubPath
- mountPath: /app/index.php
  name: index
  subPath: index.php
  
below name: php-config-volume
- configMap:
	defaultMode: 420
	name: index
  name: index
----------------
kubectl get Pods

#mount path was changed after editing
kubectl describe pod <pod-name>

#validate
kubectl exec -it <pod-name> -c httpd-php-container -- sh
ls
cd app/
ls
cat index.php


######################################## Kubernetes Level 3 - Task 1 - Deploy Apache Web Server on Kubernetes Cluster##########

kubectl create namespace httpd-namespace-xfusion
kubectl create deployment httpd-deployment-xfusion -n httpd-namespace-xfusion --image=httpd:latest --replicas=2
kubectl get deployment

kubectl get deploy -n httpd-namespace-xfusion

kubectl get pod -n httpd-namespace-xfusion
#This kubectl expose command creates a new service named httpd-service-xfusion in the httpd-namespace-xfusion namespace. It exposes the deployment named httpd-deployment-xfusion on port 80 using the NodePort type.
#This means that the service will be accessible externally via a port on each Kubernetes node. The port number will be dynamically assigned unless you specify it. In this case, it's set to port 80.

kubectl expose deployment httpd-deployment-xfusion -n httpd-namespace-xfusion --name=httpd-service-xfusion --type="NodePort" --port=80

kubectl edit service httpd-service-xfusion -n httpd-namespace-xfusion

kubectl get service httpd-service-xfusion -n httpd-namespace-xfusion