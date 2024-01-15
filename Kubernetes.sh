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





