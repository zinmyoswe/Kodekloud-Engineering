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

######################################## CCreate Deployments in Kubernetes Cluster ###############################
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






