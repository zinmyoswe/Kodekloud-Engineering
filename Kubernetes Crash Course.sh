
For short, use get
For long, use describe
----------------------------- kubectl -----------------------------------------------------
1.How many nodes are part of the cluster?

Type 'kubectl get nodes' in the terminal on the right and count the number of nodes that are listed.


2.What is the version of Kubernetes running on the nodes ?

kubectl version

3.What is the flavor and version of Operating System on which the Kubernetes nodes are running?

kubectl get nodes -o wide

----------------------------- pods -----------------------------------------------------
1.How many pods exist on the system?
kubectl get pods

2.Create a new pod with the 'nginx' image.
kubectl run nginx --image=nginx

3.How many pods are created now?
Note: We have created a few more pods. So please check again
kubectl get pods

4.What is the image used to create the new pods?
You must look at one of the new pods in detail to figure this out.

kubectl get pods

#check under container section
kubectl describe pods newpods-xqdz4

5.Which nodes are these pods placed on?
You must look at all the pods in detail to figure this out.

Run the command 'kubectl describe pod newpods-<id>' and look at the node field.
Alternatively run 'kubectl get pods -o wide' and check for the node the pod is placed on.

6.How many containers are part of the pod webapp?
Note: We just created a new POD. Ignore the state of the POD for now.

kubectl get pods
Run the command 'kubectl describe pod webapp' and look under the Containers section.

8.What is the state of the container 'agentx' in the pod webapp?
Wait for it to finish the ContainerCreating state

kubectl describe pods webapp 


9.Why do you think the container 'agentx' in pod webapp is in error?
Try to figure it out from the events section of the pod

Run the command 'kubectl describe pod webapp' and look under the events section.
An image by that name does not exist in DockerHub.

10.What does the READY column in the output of the kubectl get pods command indicate?
kubectl get pods

11.Delete the webapp Pod.
Once deleted, wait for the pod to fully terminate.

kubectl delete pod webapp 


12.Create a new pod with the name 'redis' and the image 'redis123'.
Use a pod-definition YAML file. And yes the image name is wrong!

We use kubectl run command with --dry-run=client -o yaml option to create a manifest file :-
kubectl run redis --image=redis123 --dry-run=client -o yaml > redis-definition.yaml


After that, using kubectl create -f command to create a resource from the manifest file :-
kubectl create -f redis-definition.yaml

Verify the work by running kubectl get command :-
kubectl get pods

13.Now change the image on this pod to redis.
Once done, the pod should be in a running state.

Name: redis
Image name: redis

Use the kubectl edit command to update the image of the pod to redis.

kubectl edit pod redis

vi redis-definition.yaml

If you used a pod definition file then update the image from redis123 to redis in the definition file via Vi or Nano editor 
and then run kubectl apply command to update the image :-

kubectl apply -f redis-definition.yaml

----------------------------- replicasets -----------------------------------------------------
1.How many PODs exist on the system?

kubectl get pods

2.How many ReplicaSets exist on the system?

kubectl get replicaset

3.How about now? How many ReplicaSets do you see?
We just made a few changes!

kubectl get replicaset

4.How many PODs are 'DESIRED' in the new-replica-set?

kubectl get pods

5.What is the image used to create the pods in the new-replica-set?

Run the command: 'kubectl describe replicaset' and look under the Containers section.

6.How many PODs are READY in the new-replica-set?

Run the command: kubectl get replicaset and look at the count under the Ready column.

7.Why do you think the PODs are not ready?

Run the command: 'kubectl describe pods' and look at under the Events section.

8.Delete any one of the 4 PODs

kubectl get pods
kubectl delete pods new-replica-set-5ss78

9. How many PODS exist now?

kubectl get pods


11.Create a ReplicaSet using the replicaset-definition-1.yaml file located at /root/.
There is an issue with the file, so try to fix it.

Run the command: You can check for apiVersion of replicaset by command kubectl api-resources | grep replicaset

kubectl explain replicaset | grep VERSION and correct the apiVersion for ReplicaSet.

'apiVersion: apps/v1'

Then run the command: kubectl create -f /root/replicaset-definition-1.yaml


12.Fix the issue in the replicaset-definition-2.yaml file and create a ReplicaSet using it.
This file is located at /root/.

The values for labels on lines 9 and 13 should match.

13.Delete the two newly created ReplicaSets - replicaset-1 and replicaset-2

kubectl delete rs replicaset-1
kubectl delete rs replicaset-2

rs => replicaset

14.Fix the original replica set new-replica-set to use the correct 'busybox' image.
Either delete and recreate the ReplicaSet or Update the existing ReplicaSet and then delete all PODs, so new ones with the correct image will be created.

Run the command: 'kubectl edit replicaset new-replica-set', modify the image name and then save the file.

Delete the previous pods to get the new ones with the correct image.

For this, run the command: 'kubectl delete po <pod-name>'

15.Scale the ReplicaSet to 5 PODs.
Use kubectl scale command or edit the replicaset using kubectl edit replicaset.

kubectl edit rs new-replica-set

edit 4 to 5


16.Now scale the ReplicaSet down to 2 PODs.
Use the kubectl scale command or edit the replicaset using kubectl edit replicaset.

kubectl edit rs new-replica-set
edit 5 to 2

----------------------------- deployment -----------------------------------------------------

kubectl describe deployment

#create deployment
kubectl create deploy deployment-1 --image=busybox888


vi /root/deployment-definition-httpd.yaml


11.Create a new Deployment with the below attributes using your own deployment definition file.
Name: httpd-frontend;
Replicas: 3;
Image: httpd:2.4-alpine

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      name: httpd-frontend
  template:
    metadata:
      labels:
        name: httpd-frontend
    spec:
      containers:
      - name: httpd-frontend
        image: httpd:2.4-alpine

vi /root/deployment-definition-httpd.yaml

kubectl apply -f deployment-definition-httpd.yaml 
kubectl get rs

----------------------------- service -----------------------------------------------------

kubectl get service
kubectl describe service

10.Create a new service to access the web application using the service-definition-1.yaml file.

Name: webapp-service
Type: NodePort
targetPort: 8080
port: 8080
nodePort: 30080
selector:
  name: simple-webapp

Solution =>
Update the /root/service-definition-1.yaml file as follows:

---
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
  namespace: default
spec:
  ports:
  - nodePort: 30080
    port: 8080
    targetPort: 8080
  selector:
    name: simple-webapp
  type: NodePort


Run the following command to create a webapp-service service as follows: -

kubectl apply -f /root/service-definition-1.yaml

----------------------------- final -----------------------------------------------------

Step 2: Create a custom Namespace

kubectl create namespace vore

Step 2: Create a Service

apiVersion: v1
kind: Service
metadata:
  name: vote-service
  namespace: default
spec:
  ports:
  - nodePort: 31000
    port: 5000
    targetPort: 80
  selector:
    name: vote-service
  type: NodePort
