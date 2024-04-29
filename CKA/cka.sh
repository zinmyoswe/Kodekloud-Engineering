In the video, I said the exam is 3 hours. With the latest version of the exam, it is now only 2 hours. The contents of this course has been updated with the changes required for the latest version of the exam.

Below are some references:

Certified Kubernetes Administrator: https://www.cncf.io/certification/cka/

Exam Curriculum (Topics): https://github.com/cncf/curriculum

Candidate Handbook: https://www.cncf.io/certification/candidate-handbook

Exam Tips: http://training.linuxfoundation.org/go//Important-Tips-CKA-CKAD

 

Head over to this link to enroll in the Certification Exam. Remember to keep the code – 20KODE – handy to get a 20% discount while registering for the CKA exam with Linux Foundation.
######################################## 

*/-----Show pods under all namespace------------*/
kubectl get pods --all-namespaces

*/-----Show pods one namespace------------*/
kubectl get pods -n <Namespace>

*/-------------create pods------------*/
vi pod.yaml
kubectl apply -f pod.yaml

*/-----create image with pods------------*/
kubectl run <pod-name> --image=redis123

*/-----create edit pods------------*/
kubectl edit pods <pod-name>

*/-----create delete pods------------*/
kubectl delete pods <pod-name>


etcd is used for ca,server certificate and backup for reboot and restore backup

--------------Storage -------------------------
pv pvc sc 


configmap config

daemonsets

logs

expose








################################################## certificate ####################################################
Create an NGINX Pod

kubectl run nginx --image=nginx

Generate POD Manifest YAML file (-o yaml). Don’t create it(–dry-run)

kubectl run nginx --image=nginx --dry-run=client -o yaml

Create a deployment

kubectl create deployment --image=nginx nginx

Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run)

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run) and save it to a file.

kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml

Make necessary changes to the file (for example, adding more replicas) and then create the deployment.

kubectl create -f nginx-deployment.yaml

OR

In k8s version 1.19+, we can specify the –replicas option to create a deployment with 4 replicas.

kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml


########################################
-----------------Service---
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
  
---------------- Deployment ----
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: default
spec:
  replicas: 4
  selector:
    matchLabels:
      name: webapp
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        name: webapp
    spec:
      containers:
      - image: kodekloud/webapp-color:v2
        name: simple-webapp
        ports:
        - containerPort: 8080
          protocol: TCP
  


####################################################################################################################################
####################################################################################################################################
*/--------------------------------------------------- scheduling -----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################
-

-----------------------------------------------------------------------------------------
1.A pod definition file nginx.yaml is given. Create a pod using the file.
Only create the POD for now. We will inspect its status next.

kubectl create -f nginx.yaml

#check the status
kubectl get pods

3.Why is the POD in a pending state?
Inspect the environment for various kubernetes control plane components.

kubectl get pods --namespace kube-system

No scheduler present

4.Manually schedule the pod on node01.
Delete and recreate the POD if necessary.

Delete the existing pod first. Run the below command:

$ kubectl delete po nginx
To list and know the names of available nodes on the cluster:

$ kubectl get nodes
Add the nodeName field under the spec section in the nginx.yaml file with node01 as the value:

---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  nodeName: node01
  containers:
  -  image: nginx
     name: nginx
Then run the command kubectl create -f nginx.yaml to create a pod from the definition file.

To check the status of a nginx pod and to know the node name: 

$ kubectl get pods -o wide

5.Now schedule the same pod on the controlplane node.
Delete and recreate the POD if necessary.

Status: Running
Pod: nginx
Node: controlplane

Delete the existing pod first. Run the below command:

$ kubectl delete po nginx
To list and know the names of available nodes on the cluster:

$ kubectl get nodes
Update the value of the nodeName field to controlplane:

---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  nodeName: controlplane
  containers:
  -  image: nginx
     name: nginx
Then run the command kubectl create -f nginx.yaml to create a pod from the definition file.

To check the status of a nginx pod and to know the node name: 

$ kubectl get pods -o wide


###############################################################################################################
1.We have deployed a number of PODs. They are labelled with tier, env and bu. How many PODs exist in the dev environment (env)?
Use selectors to filter the output

kubectl get pods --selector env=dev
#count pods
kubectl get pods --selector env=dev --no-headers | wc -l

2.How many PODs are in the 'finance' business unit (bu)?
 kubectl get pods --selector bu=finance
 
 3.How many objects are in the 'prod' environment including PODs, ReplicaSets and any other objects?
 kubectl get all --selector env=prod
 #count
 kubectl get all --selector env=prod --no-headers | wc -l
 
 4.Identify the POD which is part of the 'prod' environment, the 'finance BU' and of 'frontend' tier?
 kubectl get all --selector env=prod,bu=finance,tier=frontend
 
 5.A ReplicaSet definition file is given 'replicaset-definition-1.yaml'. Attempt to create the replicaset; you will encounter an issue with the file. Try to fix it.
Once you fix the issue, create the replicaset from the definition file.

 Update the /root/replicaset-definition-1.yaml file as follows:

---
apiVersion: apps/v1
kind: ReplicaSet
metadata:
   name: replicaset-1
spec:
   replicas: 2
   selector:
      matchLabels:
        tier: front-end
   template:
     metadata:
       labels:
        tier: front-end
     spec:
       containers:
       - name: nginx
         image: nginx 
Then run kubectl apply -f replicaset-definition-1.yaml


###############################################################################################################
1.How many 'nodes' exist on the system?
Including the 'controlplane node'.
kubectl get nodes

2. Use the 'kubectl describe command' to see the taint property.
kubectl describe node node01 | grep -i taints

3.Create a taint on 'node01' with key of 'spray', value of 'mortein' and effect of 'NoSchedule'
kubectl taint node node01 spray=mortein:NoSchedule

4.Create a new pod with the 'nginx image' and pod name as 'mosquito'.
Solution manifest file to create a pod called mosquito as follows:

---
apiVersion: v1
kind: Pod
metadata:
  name: mosquito
spec:
  containers:
  - image: nginx
    name: mosquito
then run kubectl create -f <FILE-NAME>.yaml

5.Create another pod named 'bee' with the 'nginx' image, which has a toleration set to the taint 'mortein'.
Image name: nginx
Key: spray
Value: mortein
Effect: NoSchedule
Status: Running

Solution manifest file to create a pod called bee as follows:

---
apiVersion: v1
kind: Pod
metadata:
  name: bee
spec:
  containers:
  - image: nginx
    name: bee
  tolerations:
  - key: spray
    value: mortein
    effect: NoSchedule
    operator: Equal
then run the kubectl create -f <FILE-NAME>.yaml to create a pod.


6.

kubectl describe node controlplane | grep -i taints

7.Remove the taint on 'controlplane', which currently has the taint effect of 'NoSchedule'.

#show taints reason
kubectl describe node controlplane | grep -i taints
#remove that taint reason
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-


################################################## Node Affanity####################################################

1.	How many Labels exist on node node01?
Run the command 'kubectl describe node node01' and count the number of labels.

2.
'kubectl describe node node01' OR kubectl get node node01 --show-labels and check the value for the given label key.

3.Apply a label 'color=blue' to 'node node01'

kubectl label node node01 color=blue

4.Create a new deployment named 'blue 'with the 'nginx image' and '3 replicas'.
Name: blue
Replicas: 3
Image: nginx

kubectl create deployment blue --image='nginx' --replicas=3

5.Which nodes can the pods for the 'blue' deployment be placed on?
Make sure to check taints on both nodes!

kubectl get pods -o wide

6.Set Node Affinity to the deployment to place the pods on 'node01' only.
Name: blue
Replicas: 3
Image: nginx
NodeAffinity: requiredDuringSchedulingIgnoredDuringExecution
Key: color
value: blue

controlplane ~ ✖ kubectl delete deployment blue
deployment.apps "blue" deleted

controlplane ~ ➜  vi blue.yaml

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: color
                operator: In
                values:
                - blue

controlplane ~ ➜  kubectl apply -f blue.yaml 
deployment.apps/blue created

controlplane ~ ➜  kubectl get deployments.apps 
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
blue   3/3     3            3           14s

controlplane ~ ➜  kubectl get deployments.apps blue -o wide
NAME   READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES   SELECTOR
blue   3/3     3            3           38s   nginx        nginx    run=nginx
----------------------------------
6.Create a new deployment named 'red' with the 'nginx' image and 2 replicas, and ensure it gets placed on the 'controlplane node only'.
Use the label key - 'node-role.kubernetes.io/control-plane' - which is already set on the controlplane node.

Name: red
Replicas: 2
Image: nginx
NodeAffinity: requiredDuringSchedulingIgnoredDuringExecution
Key: node-role.kubernetes.io/control-plane
Use the right operator


Create the file reddeploy.yaml file as follows:


---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: red
spec:
  replicas: 2
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/control-plane
                operator: Exists


Then run kubectl create -f reddeploy.yaml

################################################## Practice Resource Limits####################################################
1.A pod called 'rabbit' is deployed. Identify the CPU requirements set on the Pod
in the current(default) namespace

kubectl describe pod rabbit

2.Delete the 'rabbit' Pod.
Once deleted, wait for the pod to fully terminate.

kubectl delete pods rabbit

3.Another pod called 'elephant' has been deployed in the default namespace. It fails to get to a running state. Inspect this pod and identify the 'Reason' why it is not running.
kubectl describe pods elephant

#find the last error reason every 2 sec
watch kubectl get pods

4.The 'elephant' pod runs a process that consumes 15Mi of memory. Increase the limit of the elephant pod to 20Mi.
Delete and recreate the pod if required. Do not modify anything other than the required fields.

Pod Name: elephant
Image Name: polinux/stress
Memory Limit: 20Mi

Create the file elephant.yaml by running command kubectl get po elephant -o yaml > elephant.yaml and edit the file such as memory limit is set to 20Mi as follows:

---
apiVersion: v1
kind: Pod
metadata:
  name: elephant
  namespace: default
spec:
  containers:
  - args:
    - --vm
    - "1"
    - --vm-bytes
    - 15M
    - --vm-hang
    - "1"
    command:
    - stress
    image: polinux/stress
    name: mem-stress
    resources:
      limits:
        memory: 20Mi
      requests:
        memory: 5Mi
then run kubectl replace -f elephant.yaml --force. This command will delete the existing one first and recreate a new one from the YAML file.

---------------------

################################################## practice-test-daemonsets####################################################
#DaemonSet is a Kubernetes feature that lets you run a Kubernetes pod on all cluster nodes that meet certain criteria

1.How many 'DaemonSets' are created in the cluster in all namespaces?
Check all namespaces

kubectl get daemonsets --all-namespaces

2.Which namespace is the 'kube-proxy' Daemonset created in?

kubectl get daemonsets --all-namespaces -o wide

3.Which of the below is a 'DaemonSet'?
kubectl get all --all-namespaces

4.On how many nodes are the pods scheduled by the DaemonSet 'kube-proxy'?
kubectl describe daemonset kube-proxy --namespace=kube-system


5.What is the image used by the POD deployed by the 'kube-flannel-ds' DaemonSet?
 kubectl describe daemonsets kube-flannel-ds --namespace=kube-flannel
 
 6.Deploy a DaemonSet for 'FluentD' Logging.
Use the given specifications.
Name: elasticsearch
Namespace: kube-system
Image: registry.k8s.io/fluentd-elasticsearch:1.20

An easy way to create a DaemonSet is to first generate a YAML file for a Deployment with the command 
kubectl create deployment elasticsearch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system --dry-run=client -o yaml > fluentd.yaml. Next, remove the replicas, strategy and status fields from the YAML file using a text editor. Also, change the kind from Deployment to DaemonSet.

Finally, create the Daemonset by running kubectl create -f fluentd.yaml

################################################## -test-static-pods####################################################
1.How many static pods exist in this cluster in all namespaces?
Run the command 'kubectl get pods --all-namespaces' and look for those with '-controlplane' appended in the name

2.Which of the below components is NOT deployed as a static pod?
Run kubectl get pods --all-namespaces and look for the pod from the list that does not end with -controlplane

3.Which of the below components is NOT deployed as a static POD?
same with no2

4.On which nodes are the static pods created currently?
controlplane 

5.What is the path of the directory holding the static pod definition files?
First idenity the kubelet config file:

root@controlplane:~# ps -aux | grep /usr/bin/kubelet
root      3668  0.0  1.5 1933476 63076 ?       Ssl  Mar13  16:18 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --network-plugin=cni --pod-infra-container-image=k8s.gcr.io/pause:3.2
root      4879  0.0  0.0  11468  1040 pts/0    S+   00:06   0:00 grep --color=auto /usr/bin/kubelet
root@controlplane:~# 
From the output we can see that the kubelet config file used is /var/lib/kubelet/config.yaml


Next, lookup the value assigned for staticPodPath:

root@controlplane:~# grep -i staticpod /var/lib/kubelet/config.yaml
staticPodPath: /etc/kubernetes/manifests
root@controlplane:~# 
As you can see, the path configured is the /etc/kubernetes/manifests directory.

#The ps -aux | grep kubelet command is used to list all running processes (ps) and filter them to display only those related to the kubelet service (grep kubelet). 
#This can be useful for checking the status of the kubelet process or troubleshooting kubelet-related issues.
--------------------
6.How many pod definition files are present in the manifests directory?
cd /etc/kubernetes/manifests/
ls

7.
Check the image defined in the '/etc/kubernetes/manifests/kube-apiserver.yaml' manifest file.

8.Create a static pod named 'static-busybox' that uses the 'busybox' image and the command sleep 1000

Name: static-busybox
Image: busybox

kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml

8.Edit the image on the static pod to use busybox:1.28.4
Name: static-busybox
Image: busybox:1.28.4

kubectl edit pod static-busybox-controlplane 
-------------------------------- ### cannot delete use this ##------------------------
9.We just created a new static pod named 'static-greenbox'. Find it and delete it.
This question is a bit tricky. But if you use the knowledge you gained in the previous questions in this lab, you should be able to find the answer to it.

First, lets identify the node in which the pod called static-greenbox is created. To do this, run:
root@controlplane:~# kubectl get pods --all-namespaces -o wide  | grep static-greenbox
default       static-greenbox-node01                 1/1     Running   0          19s     10.244.1.2   node01       <none>           <none>
root@controlplane:~#
From the result of this command, we can see that the pod is running on node01.


Next, SSH to node01 and identify the path configured for static pods in this node.

Important: The path need not be /etc/kubernetes/manifests. Make sure to check the path configured in the kubelet configuration file.
root@controlplane:~# ssh node01 
root@node01:~# ps -ef |  grep /usr/bin/kubelet 
root        4147       1  0 14:05 ?        00:00:00 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.9
root        4773    4733  0 14:05 pts/0    00:00:00 grep /usr/bin/kubelet

root@node01:~# grep -i staticpod /var/lib/kubelet/config.yaml
staticPodPath: /etc/just-to-mess-with-you

root@node01:~# 
Here the staticPodPath is /etc/just-to-mess-with-you


Navigate to this directory and delete the YAML file:
root@node01:/etc/just-to-mess-with-you# ls
greenbox.yaml
root@node01:/etc/just-to-mess-with-you# rm -rf greenbox.yaml 
root@node01:/etc/just-to-mess-with-you#
Exit out of node01 using CTRL + D or type exit. You should return to the controlplane node. Check if the static-greenbox pod has been deleted:
root@controlplane:~# kubectl get pods --all-namespaces -o wide  | grep static-greenbox
root@controlplane:~# 

-----------------------------------------------------


################################################## practice-test-multiple-schedulers####################################################
1.What is the name of the POD that deploys the default kubernetes scheduler in this environment?
 kubectl get pods --all-namespaces 
 
 2.kubectl describe pods kube-scheduler-controlplane -n kube-system 
 
 3.Lets create a configmap that the new scheduler will employ using the concept of ConfigMap as a volume.
We have already given a configMap definition file called 'my-scheduler-configmap.yaml' at 
'/root/' path that will create a configmap with name 'my-scheduler-config' using the content of file '/root/my-scheduler-config.yaml'.

kubectl create -f /root/my-scheduler-configmap.yaml.

4.Deploy an additional scheduler to the cluster following the given specification.
Use the manifest file provided at /'root/my-scheduler.yaml'. Use the same image as used by the default kubernetes scheduler.
Name: my-scheduler
Status: Running
Correct image used?

kubectl create -f my-scheduler.yaml 

################################################## ETCDCTL####################################################

For example, ETCDCTL version 2 supports the following commands:

etcdctl backup
etcdctl cluster-health
etcdctl mk
etcdctl mkdir
etcdctl set

Whereas the commands are different in version 3

etcdctl snapshot save
etcdctl endpoint health
etcdctl get
etcdctl put

To set the right version of API set the environment variable ETCDCTL_API command

export ETCDCTL_API=3

When the API version is not set, it is assumed to be set to version 2. And version 3 commands listed above don’t work. When API version is set to version 3, version 2 commands listed above don’t work.

Apart from that, you must also specify the path to certificate files so that ETCDCTL can authenticate to the ETCD API Server. The certificate files are available in the etcd-master at the following path. We discuss more about certificates in the security section of this course. So don’t worry if this looks complex:

--cacert /etc/kubernetes/pki/etcd/ca.crt
--cert /etc/kubernetes/pki/etcd/server.crt
--key /etc/kubernetes/pki/etcd/server.key

So for the commands, I showed in the previous video to work you must specify the ETCDCTL API version and path to certificate files. Below is the final form:

kubectl exec etcd-controlplane -n kube-system -- sh -c "ETCDCTL_API=3 etcdctl get / --prefix --keys-only --limit=10 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key"

################################################## test pods####################################################
1.How many pods exist on the system?
In the current(default) namespace.

kubectl get pods

2.Create a new pod with the 'nginx' image.

kubectl run nginx --image=nginx

4.
kubectl describe pods newpods-lwdp7

5.Create a new pod with the name 'redis' and the image 'redis123'.
Use a pod-definition YAML file. And yes the image name is wrong!

kubectl run redis --image=redis123

kubectl edit pods redis


################################################## replicasets####################################################
1.How many ReplicaSets exist on the system?

kubectl get replicaset or rs

2.
kubectl get replicaset -o wide

3.kubectl describe replicaset new-replica-set 

#delete all pods app name with my-app
4.kubectl delete pods -l app=my-app

5.Scale the ReplicaSet to 5 PODs.
Use 'kubectl scale' command or edit the replicaset using' kubectl edit replicaset'.

Run the command: kubectl edit replicaset new-replica-set, 
modify the replicas and then save the file OR run: 'kubectl scale rs new-replica-set --replicas=5' to scale up to 5 PODs.

#edit and scale is same in replica
6.kubectl scale rs new-replica-set --replicas=2

################################################## Deployment ####################################################

1.Create a new Deployment with the below attributes using your own deployment definition file.
Name: httpd-frontend;
Replicas: 3;
Image: httpd:2.4-alpine

kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=3

################################################## Service ####################################################

kubectl get service

#detail of mentioned service
kubectl describe service kubernetes

#
kubectl describe deployments.apps <deployment-name>

################################################## namespace ####################################################
kubectl get namespaces


kubectl get pods -n research


3.Create a POD in the finance namespace.
Use the spec given below.
kubectl run redis --image=redis -n finance


4.
kubectl get pods --all-namespaces

##################################################practice-test-imperative-commands-2 ####################################################
1.Deploy a redis pod using the 'redis:alpine' image with the labels set to 'tier=db.'

kubectl run redis -l tier=db --image=redis:alpine

2.Create a service redis-service to expose the redis application within the cluster on port 6379.
Use imperative commands.
Service: redis-service
Port: 6379
Type: ClusterIP

kubectl expose pod redis --port=6379 --name redis-service

3.Create a deployment named webapp using the image kodekloud/webapp-color with 3 replicas.
Try to use imperative commands only. Do not create definition files.
Name: webapp
Image: kodekloud/webapp-color
Replicas: 3

kubectl create deployment webapp --image=kodekloud/webapp-color --replicas=3

4.Create a new pod called custom-nginx using the nginx image and expose it on container port 8080.

kubectl run custom-nginx --image=nginx --port=8080

5.Create a new deployment called redis-deploy in the dev-ns namespace with the redis image. It should have 2 replicas.
Use imperative commands.
kubectl create deployment redis-deploy --image=redis --replicas=2 -n dev-ns

7.Create a pod called httpd using the image httpd:alpine in the default namespace. Next, create a service of type ClusterIP by the same name (httpd). 
The target port for the service should be 80.
Try to do this with as few steps as possible.
'httpd' pod created with the correct image?
'httpd' service is of type 'ClusterIP'?
'httpd' service uses correct target port 80?
'httpd' service exposes the 'httpd' pod?

#create both service and pod with run,expose command
kubectl run httpd --image=httpd:alpine --port=80 --expose


####################################################################################################################################
####################################################################################################################################
*/--------------------------------------------------- 3. Logging and Monitoring -----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################

################################################## monitor-cluster-components ####################################################

controlplane ~ ➜  git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
Cloning into 'kubernetes-metrics-server'...
remote: Enumerating objects: 31, done.
remote: Counting objects: 100% (19/19), done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 31 (delta 8), reused 0 (delta 0), pack-reused 12
Receiving objects: 100% (31/31), 8.08 KiB | 8.08 MiB/s, done.
Resolving deltas: 100% (10/10), done.

controlplane ~ ✖ ls
kubernetes-metrics-server  sample.yaml

controlplane ~ ➜  cd kubernetes-metrics-server/

controlplane kubernetes-metrics-server on  master ➜  kubectl create -f .
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
serviceaccount/metrics-server created
deployment.apps/metrics-server created
service/metrics-server created
clusterrole.rbac.authorization.k8s.io/system:metrics-server created
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created

controlplane kubernetes-metrics-server on  master ➜ 

2.Identify the 'node' that consumes the most CPU(cores).

You can also use the --sort-by='cpu' flag like this:

root@controlplane:~# kubectl top node --sort-by='cpu' --no-headers | head -1                   
node01         234m   2%    515Mi   2%    
root@controlplane:~# 

#for cpu
kubectl top node --sort-by='cpu' --no-headers | head -1

#for memory
kubectl top node --sort-by='memory' --no-headers | head -1

4.Identify the POD that consumes the most 'Memory(bytes)' in default namespace.

kubectl top pod --sort-by='memory' --no-headers | head -1

5.Identify the POD that consumes the 'least CPU(cores)' in default namespace.
kubectl top pod --sort-by='memory' --no-headers | tail -1

################################################## managing-application-logs ####################################################
1.A user - USER5 - has expressed concerns accessing the application. Identify the cause of the issue.

Inspect the logs of the POD

kubectl logs webapp-1 

2.A user is reporting issues while trying to purchase an item. Identify the user and the cause of the issue.
Inspect the logs of the webapp in the POD

kubectl logs webapp-2

####################################################################################################################################
####################################################################################################################################
*/--------------------------------------------------- 4. Application Lifecycle Management -----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################

################################################## rolling-updates-and-rollbacks-3 ####################################################

#execute file
bash /root/file.yaml

################################################## Config Map Env ####################################################
1.Create a new ConfigMap for the webapp-color POD. Use the spec given below.

ConfigMap Name: webapp-config-map

Data: APP_COLOR=darkblue

Data: APP_OTHER=disregard

'kubectl create configmap NAME [--from-file=[key=]source] [--from-literal=key1=value1] [--dry-run=server|client|none]'

kubectl create cm webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=disregard

################################################## test-secrets ####################################################

kubectl get secrets 

kubectl get secrets dashboard-token -o

kubectl describe secrets dashboard-token

#format
kubectl create secret generic db-user-pass \
    --from-literal=username=admin \
    --from-literal=password='S!B\*d$zDsb='

1.The reason the application is failed is because we have not created the secrets yet. Create a new secret named db-secret with the data given below.

You may follow any one of the methods discussed in lecture to create the secret.

Secret Name: db-secret

Secret 1: DB_Host=sql01

Secret 2: DB_User=root

Secret 3: DB_Password=password123
	
	
kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123


2.
---
apiVersion: v1 
kind: Pod 
metadata:
  labels:
    name: webapp-pod
  name: webapp-pod
  namespace: default 
spec:
  containers:
  - image: kodekloud/simple-webapp-mysql
    imagePullPolicy: Always
    name: webapp
    envFrom:
    - secretRef:
        name: db-secret



https://www.youtube.com/watch?v=MTnQW9MxnRI

################################################## multiple pods ####################################################
1Create a multi-container pod with 2 containers.

Use the spec given below:

If the pod goes into the crashloopbackoff then add the command sleep 1000 in the lemon container.

Name: yellow

Container 1 Name: lemon

Container 1 Image: busybox

Container 2 Name: gold

Container 2 Image: redis

apiVersion: v1
kind: Pod
metadata:
  name: yellow
spec:
  containers:
  - name: lemon
    image: busybox
    command:
      - sleep
      - "1000"

  - name: gold
    image: redis


2.kubectl -n elastic-stack logs kibana 

3.The application outputs logs to the file /log/app.log. View the logs and try to identify the user having issues with Login.
Inspect the log file inside the pod.


kubectl -n elastic-stack exec -it app -- cat /log/app.log

4.Edit the pod in the elastic-stack namespace to add a sidecar container to send logs to Elastic Search. Mount the log volume to the sidecar container.

Only add a new container. Do not modify anything else. Use the spec provided below.



    Note: State persistence concepts are discussed in detail later in this course. For now please make use of the below documentation link for updating the concerning pod.



https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/

Name: app

Container Name: sidecar

Container Image: kodekloud/filebeat-configured

Volume Mount: log-volume

Mount Path: /var/log/event-simulator/

Existing Container Name: app

Existing Container Image: kodekloud/event-simulator
---
apiVersion: v1
kind: Pod
metadata:
  name: app
  namespace: elastic-stack
  labels:
    name: app
spec:
  containers:
  - name: app
    image: kodekloud/event-simulator
    volumeMounts:
    - mountPath: /log
      name: log-volume

  - name: sidecar
    image: kodekloud/filebeat-configured
    volumeMounts:
    - mountPath: /var/log/event-simulator/
      name: log-volume

  volumes:
  - name: log-volume
    hostPath:
      # directory location on host
      path: /var/log/webapp
      # this field is optional
      type: DirectoryOrCreate
	  
	  
################################################## init container ####################################################	  
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox
    command: ['sh', '-c', 'git clone <some-repository-that-will-be-used-by-application> ;']
	
---
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup myservice; do echo waiting for myservice; sleep 2; done;']
  - name: init-mydb
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup mydb; do echo waiting for mydb; sleep 2; done;']
	
	
-----------------
1.Run the command 'kubectl describe pod blue'. It has an InitContainer called 'init-myservice'

2.
Check the commands used in the 'initContainers'. The first one sleeps for 600 seconds (10 minutes) and the second one sleeps for 1200 seconds (20 minutes)

Adding the sleep times for both initContainers, the application will start after 1800 seconds or 30 minutes.

kubectl describe pod purple

3.Update the pod red to use an initContainer that uses the busybox image and sleeps for 20 seconds
Delete and re-create the pod if necessary. But make sure no other configurations change.

Pod: red
initContainer Configured Correctly

-----
apiVersion: v1
kind: Pod
metadata:
  name: red
  namespace: default
spec:
  containers:
  - command:
    - sh
    - -c
    - echo The app is running! && sleep 3600
    image: busybox:1.28
    name: red-container
  initContainers:
  - image: busybox
    name: red-initcontainer
    command: 
      - "sleep"
      - "20"
	  

kubectl get pod orange -o yaml> /root/orange.yaml

#check error
k logs orange
k logs orange -c init-myservice
k edit pod orange

k replace --force -f <temp-file.yaml>

####################################################################################################################################
####################################################################################################################################
*/--------------------------------------------------- 5. Cluster maintenance -----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################

################################################## os-upgrades ####################################################

1.
#checking which node is used in pod app 
kubectl get pods -o wide

kubectl drain to safely evict all of your pods from a node before you perform maintenance on the node (e.g. kernel upgrade, hardware maintenance, etc.)
2.We need to take 'node01' out for maintenance. Empty the node of all applications and mark it unschedulable.

Node node01 Unschedulable
Pods evicted from node01

kubectl drain node01 --ignore-daemonsets

kubectl uncordon allows you to optimize resource allocation in your Kubernetes cluster by making the node schedulable again
3.kubectl uncordon node01

4. #finding taint  
kubectl describe node controlplane | grep -i  taint

5.hr-app is a critical app and we do not want it to be removed and we do not want to schedule any more pods on node01.
Mark 'node01' as unschedulable so that no new pods are scheduled on this node.
Make sure that hr-app is not affected.

Node01 Unschedulable
hr-app still running on node01?

#unschedule node01 for maintenance
kubectl cordon node01

################################################## cluster-upgrade-process####################################################
1.This lab tests your skills on upgrading a kubernetes cluster. We have a production cluster with applications running on it. Let us explore the setup first.
What is the current version of the cluster?

kubectl version

2.How many nodes can host workloads in this cluster?
Inspect the applications and taints set on the nodes.


controlplane ~ ✖ kubectl describe node node01 | grep -i taints
Taints:             <none>

controlplane ~ ✖ kubectl describe node controlplane | grep -i taints
Taints:             <none>

3.What is the latest version available for an upgrade with the current version of the kubeadm tool installed?

Use the 'kubeadm' tool

kubeadm upgrade plan and check target

4.We will be upgrading the controlplane node first. Drain the controlplane node of workloads and mark it UnSchedulable
kubectl drain controlplane --ignore-daemonsets 

#Kubelet is a node-level agent that is in charge of executing pod requirements, managing resources, and guaranteeing cluster health.
5.Upgrade the controlplane components to exact version v1.29.0
Upgrade the kubeadm tool (if not already), then the controlplane components, and finally the kubelet. Practice referring to the Kubernetes documentation page.

Controlplane Node Upgraded to v1.29.0
Controlplane Kubelet Upgraded to v1.29.0

Make sure that the correct version of 'kubeadm' is installed and then proceed to upgrade the 'controlplane' node. Once this is done, upgrade the 'kubelet' on the node.

vim /etc/apt/sources.list.d/kubernetes.list

Update the version in the URL to the next available minor release, i.e v1.29.

deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /

After making changes, save the file and exit from your text editor. Proceed with the next instruction.

root@controlplane:~# apt update
root@controlplane:~# apt-cache madison kubeadm

Based on the version information displayed by apt-cache madison, it indicates that for Kubernetes version 1.29.0, the available package version is 1.29.0-1.1. Therefore, to install kubeadm for Kubernetes v1.29.0, use the following command:

root@controlplane:~# apt-get install kubeadm=1.29.0-1.1

Run the following command to upgrade the Kubernetes cluster.

root@controlplane:~# kubeadm upgrade plan v1.29.0
root@controlplane:~# kubeadm upgrade apply v1.29.0

    Note that the above steps can take a few minutes to complete.

Now, upgrade the version and restart Kubelet. Also, mark the node (in this case, the "controlplane" node) as schedulable.

root@controlplane:~# apt-get install kubelet=1.29.0-1.1
root@controlplane:~# systemctl daemon-reload
root@controlplane:~# systemctl restart kubelet
root@controlplane:~# kubectl uncordon controlplane

################################################## practice-test-backup-and-restore-methods####################################################
1.What is the version of ETCD running on the cluster?

Check the ETCD Pod or Process

kubectl describe pod etcd-controlplane  -n kube-system and look up image

2.At what address can you reach the ETCD cluster from the controlplane node?

Check the ETCD Service configuration in the ETCD POD

kubectl describe pod etcd-controlplane -n kube-system and look for --listen-client-urls

3.Where is the 'ETCD server certificate file' located?

Note this path down as you will need to use it later

kubectl describe pod etcd-controlplane -n kube-system | grep '\--cert-file'


4.Where is the 'ETCD CA Certificate file' located?

Note this path down as you will need to use it later.

kubectl describe pod etcd-controlplane -n kube-system | grep '\--trusted-ca-file'

5.The master node in our cluster is planned for a regular maintenance reboot tonight. While we do not anticipate anything to go wrong, we are required to take the necessary backups. Take a snapshot of the ETCD database using the built-in snapshot functionality.
Store the backup file at location '/opt/snapshot-pre-boot.db'
Backup ETCD to /opt/snapshot-pre-boot.db

Use the 'etcdctl snapshot save' command. You will have to make use of additional flags to connect to the ETCD server.

--endpoints: Optional Flag, points to the address where ETCD is running (127.0.0.1:2379)

--cacert: Mandatory Flag (Absolute Path to the CA certificate file)

--cert: Mandatory Flag (Absolute Path to the Server certificate file)

--key: Mandatory Flag (Absolute Path to the Key file)

Solution =>
root@controlplane:~# ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db

Snapshot saved at /opt/snapshot-pre-boot.db
root@controlplane:~# 

6.Luckily we took a backup. Restore the original state of the cluster using the backup file.

Deployments: 2
Services: 3

First Restore the snapshot:

root@controlplane:~# ETCDCTL_API=3 etcdctl  --data-dir /var/lib/etcd-from-backup \
snapshot restore /opt/snapshot-pre-boot.db


2022-03-25 09:19:27.175043 I | mvcc: restore compact to 2552
2022-03-25 09:19:27.266709 I | etcdserver/membership: added member 8e9e05c52164694d [http://localhost:2380] to cluster cdf818194e3a8c32
root@controlplane:~# 


Note: In this case, we are restoring the snapshot to a different directory but in the same server where we took the backup (the controlplane node) As a result, the only required option for the restore command is the --data-dir.


Next, update the /etc/kubernetes/manifests/etcd.yaml:

We have now restored the etcd snapshot to a new path on the controlplane - /var/lib/etcd-from-backup, so, the only change to be made in the YAML file, is to change the hostPath for the volume called etcd-data from old directory (/var/lib/etcd) to the new directory (/var/lib/etcd-from-backup).

  volumes:
  - hostPath:
      path: /var/lib/etcd-from-backup
      type: DirectoryOrCreate
    name: etcd-data

With this change, /var/lib/etcd on the container points to /var/lib/etcd-from-backup on the controlplane (which is what we want).

When this file is updated, the ETCD pod is automatically re-created as this is a static pod placed under the /etc/kubernetes/manifests directory.


    Note 1: As the ETCD pod has changed it will automatically restart, and also kube-controller-manager and kube-scheduler. Wait 1-2 to mins for this pods to restart. You can run the command: watch "crictl ps | grep etcd" to see when the ETCD pod is restarted.

    Note 2: If the etcd pod is not getting Ready 1/1, then restart it by kubectl delete pod -n kube-system etcd-controlplane and wait 1 minute.

    Note 3: This is the simplest way to make sure that ETCD uses the restored data after the ETCD pod is recreated. You dont have to change anything else.


If you do change --data-dir to /var/lib/etcd-from-backup in the ETCD YAML file, make sure that the volumeMounts for etcd-data is updated as well, with the mountPath pointing to /var/lib/etcd-from-backup (THIS COMPLETE STEP IS OPTIONAL AND NEED NOT BE DONE FOR COMPLETING THE RESTORE)



################################################## practice-test-backup-and-restore-methods 2####################################################
1.How many clusters are defined in the kubeconfig on the student-node?

You can make use of the kubectl config command.
#check the keyword like --help
kubectl config

kubectl config get-clusters

2.How many nodes (both controlplane and worker) are part of cluster1?

Make sure to switch the context to cluster1:

kubectl config use-context cluster1

student-node ~ ✖ kubectl config use-context cluster1
Switched to context "cluster1".

student-node ~ ➜  kubectl get nodes
NAME                    STATUS   ROLES           AGE    VERSION
cluster1-controlplane   Ready    control-plane   118m   v1.24.0
cluster1-node01         Ready    <none>          117m   v1.24.0

student-node ~ ➜  

-------------
3.What is the name of the controlplane node in cluster2?
Make sure to switch the context to cluster2:

kubectl config use-context cluster2



student-node ~ ✖ kubectl config use-context cluster2
Switched to context "cluster2".

student-node ~ ➜  kubectl get nodes
NAME                    STATUS   ROLES           AGE    VERSION
cluster2-controlplane   Ready    control-plane   120m   v1.24.0
cluster2-node01         Ready    <none>          120m   v1.24.0

student-node ~ ➜  

-------
4.student-node ~ ✖ ssh cluster1-controlplane

------
5.How is ETCD configured for cluster1?
Remember, you can access the clusters from student-node using the kubectl tool. You can also ssh to the cluster nodes from the student-node.
Make sure to switch the context to cluster1:

kubectl config use-context cluster1

kubectl get pods -n kube-system 
OR 
kubectl get pods -n kube-system | grep etcd


6.How is ETCD configured for cluster2?
Remember, you can access the clusters from student-node using the kubectl tool. You can also ssh to the cluster nodes from the student-node.
Make sure to switch the context to cluster2:

kubectl config use-context cluster2

No found pod in cluster2 so it mean external etcd


ps -ef | grep etcd
Running the ps -ef | grep etcd command will list the running processes on your system and filter out the lines containing "etcd".

---
7.What is the IP address of the 'External ETCD datastore' used in cluster2?

#check ip address
ps -ef | grep etcd
--etcd-servers=https://192.34.219.18:2379

----
8.What is the default data directory used the for ETCD datastore used in cluster1?
Remember, this cluster uses a Stacked ETCD topology.

Make sure to switch the context to cluster1:

kubectl config use-context cluster1

student-node ~ ➜  kubectl describe pods -n kube-system etcd-cluster1-controlplane | grep data-dir
      --data-dir=/var/lib/etcd
	  
---
9. for cluster2 data 

student-node ~ ➜  ssh etcd-server

etcd-server ~ ➜  ps -ef | grep etcd
etcd         816       1  0 15:16 ?        00:01:48 /usr/local/bin/etcd --name etcd-server --data-dir=/var/lib/etcd-data 

10. check member list in etcd server

etcd-server ~ ➜  ETCDCTL_API=3 etcdctl \
 --endpoints=https://127.0.0.1:2379 \
 --cacert=/etc/etcd/pki/ca.pem \
 --cert=/etc/etcd/pki/etcd.pem \
 --key=/etc/etcd/pki/etcd-key.pem \
  member list
  
---
11.Take a backup of etcd on cluster1 and save it on the student-node at the path /opt/cluster1.db


If needed, make sure to set the context to cluster1 (on the student-node):

student-node ~ ➜  kubectl config use-context cluster1
Switched to context "cluster1".

student-node ~ ➜  

student-node ~ ✖ kubectl describe  pods -n kube-system etcd-cluster1-controlplane  | grep advertise-client-urls
      --advertise-client-urls=https://10.1.218.16:2379

student-node ~ ➜  

student-node ~ ➜  kubectl describe  pods -n kube-system etcd-cluster1-controlplane  | grep pki
      --cert-file=/etc/kubernetes/pki/etcd/server.crt
      --key-file=/etc/kubernetes/pki/etcd/server.key
      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
      --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
      --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      /etc/kubernetes/pki/etcd from etcd-certs (rw)
    Path:          /etc/kubernetes/pki/etcd
	
	
	--cacert=/etc/kubernetes/pki/etcd/ca.crt 
	--cert=/etc/kubernetes/pki/etcd/server.crt 
	--key=/etc/kubernetes/pki/etcd/server.key 
	snapshot save /opt/cluster1.db
	
####################################################################################################################################
####################################################################################################################################
*/--------------------------------------------------- 6. Security -----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################

################################################## monitor-cluster-components ####################################################	
1.Identify the 'certificate file' used for the 'kube-api' server.
cat /etc/kubernetes/manifests/kube-apiserver.yaml and look for the line --tls-cert-file.

2.dentify the 'Certificate file used to authenticat'e kube-apiserver as a client to ETCD Server.
cat /etc/kubernetes/manifests/kube-apiserver.yaml and look for value of etcd-certfile flag

3.Identify the key used to authenticate kubeapi-server to the 'kubelet' server
Look for kubelet-client-key option in the file /etc/kubernetes/manifests/kube-apiserver.yaml.

4.Identify the ETCD Server Certificate used to host ETCD server.
Look for cert-file option in the file /etc/kubernetes/manifests/etcd.yaml.

5.Identify the ETCD Server CA Root Certificate used to serve ETCD Server.
ETCD can have its own CA. So this may be a different CA certificate than the one used by kube-api server.

Look for CA Certificate (trusted-ca-file) in file /etc/kubernetes/manifests/etcd.yaml.

6.What is the Common Name (CN) configured on the Kube API Server Certificate?

OpenSSL Syntax: openssl x509 -in file-path.crt -text -noout

openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text and look for Subject CN.

---
7.What is the name of the CA who issued the Kube API Server Certificate?
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text and look for issuer

10.Kubectl suddenly stops responding to your commands. Check it out! Someone recently modified the '/etc/kubernetes/manifests/etcd.yaml' file
You are asked to investigate and fix the issue. Once you fix the issue wait for sometime for kubectl to respond. Check the logs of the ETCD container.

The certificate file used here is incorrect. It is set to '/etc/kubernetes/pki/etcd/server-certificate.crt' which does not exist. 
As we saw in the previous questions the correct path should be '/etc/kubernetes/pki/etcd/server.crt'.

modified this '/etc/kubernetes/manifests/etcd.yaml' file of --cert-file option in the manifests file.
kubectl logs -n kube-system -l component=etcd
kubectl delete pod -n kube-system -l component=etcd



################################################## monitor-cluster-components ####################################################
1.Create a CertificateSigningRequest object with the name akshay with the contents of the akshay.csr file

As of kubernetes 1.19, the API to use for CSR is certificates.k8s.io/v1.

Please note that an additional field called signerName should also be added when creating CSR. For client authentication to the API server we will use the built-in signer kubernetes.io/kube-apiserver-client.

CSR akshay created
Right CSR is used

---
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: akshay
spec:
  groups:
  - system:authenticated
  request: <Paste the base64 encoded value of the CSR file>
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
  
  
####################################################################################################################################
####################################################################################################################################
*/---------------------------------------------------  Storage -----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################

################################################## storage ####################################################	

Using PVC in Pods
----
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
		
1.The application stores logs at location /log/app.log. View the logs.
You can exec in to the container and open the file:

kubectl exec webapp -- cat /log/app.log


2.

apiVersion: v1
kind: Pod
metadata:
  name: webapp
spec:
  containers:
  - name: event-simulator
    image: kodekloud/event-simulator
    env:
    - name: LOG_HANDLERS
      value: file
    volumeMounts:
    - mountPath: /log
      name: log-volume

  volumes:
  - name: log-volume
    hostPath:
      # directory location on host
      path: /var/log/webapp
      # this field is optional
      type: Directory
	  
3.
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  persistentVolumeReclaimPolicy: Retain
  accessModes:
    - ReadWriteMany
  capacity:
    storage: 100Mi
  hostPath:
    path: /pv/log
	
	
4.

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: claim-log-1
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Mi

5.kubectl get pvc, pv


kubectl delete pvc claim-log-1

7.
apiVersion: v1
kind: Pod
metadata:
  name: webapp
spec:
  containers:
  - name: event-simulator
    image: kodekloud/event-simulator
    env:
    - name: LOG_HANDLERS
      value: file
    volumeMounts:
    - mountPath: /log
      name: log-volume

  volumes:
  - name: log-volume
    persistentVolumeClaim:
      claimName: claim-log-1
	  
################################################## storage class ####################################################	
1.How many StorageClasses exist in the cluster right now?

kubectl get sc and count the number of Storage Classes available in the cluster.

2.What is the name of the Storage Class that does not support dynamic volume provisioning?
localstorage

3.What is the Volume Binding Mode used for this storage class (the one identified in the previous question)?

kubectl describe sc local-storage or kubectl get sc and look under the Volume Binding Mode section.

kubectl describe sc portworx-io-priority-high

4.
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: local-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: local-storage
  resources:
    requests:
      storage: 500Mi
	  
5.
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    volumeMounts:
      - name: local-persistent-storage
        mountPath: /var/www/html
  volumes:
    - name: local-persistent-storage
      persistentVolumeClaim:
        claimName: local-pvc
		
6.
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: delayed-volume-sc
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer

####################################################################################################################################
####################################################################################################################################
*/---------------------------------------------------  deploy-a-kubernetes-cluster-using-kubeadm -----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/	
--
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

---
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo mkdir -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

# To see the new version labels
sudo apt-cache madison kubeadm

sudo apt-get install -y kubelet=1.29.0-1.1 kubeadm=1.29.0-1.1 kubectl=1.29.0-1.1

sudo apt-mark hold kubelet kubeadm kubectl


2.Initialize Control Plane Node (Master Node). Use the following options:

    apiserver-advertise-address - Use the IP address allocated to eth0 on the controlplane node

    apiserver-cert-extra-sans - Set it to controlplane

    pod-network-cidr - Set to 10.244.0.0/16


Once done, set up the default kubeconfig file and wait for node to be part of the cluster.

Solution=>
You can use the below kubeadm init command to spin up the cluster:

IP_ADDR=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
kubeadm init --apiserver-cert-extra-sans=controlplane --apiserver-advertise-address $IP_ADDR --pod-network-cidr=10.244.0.0/16

Once the command has been run successfully, set up the kubeconfig:

root@controlplane:~> mkdir -p $HOME/.kube
root@controlplane:~> sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
root@controlplane:~> sudo chown $(id -u):$(id -g) $HOME/.kube/config
root@controlplane:~>

3.Join node01 to the cluster using the join token

root@controlplane:~> kubeadm token create --print-join-command
kubeadm join 192.83.79.10:6443 --token f4gugx.u9rfo93lz1qeiy32 --discovery-token-ca-cert-hash sha256:bf2c7531e52e959c02a63dbd6f9385bf2385d4d796667ff7f9a9386d01346289

root@node01:~> kubeadm join 192.83.79.10:6443 --token f4gugx.u9rfo93lz1qeiy32 --discovery-token-ca-cert-hash sha256:bf2c7531e52e959c02a63dbd6f9385bf2385d4d796667ff7f9a9386d01346289 


####################################################################################################################################
####################################################################################################################################
*/---------------------------------------------------  Troubleshooting-----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################
1.

---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: alpha
spec:
    ports:
    - port: 3306
      targetPort: 3306
    selector:
      name: mysql
	  
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: gamma
spec:
    ports:
    - port: 3306
      targetPort: 3306
    selector:
      name: mysql
	  
	  
3. 
kubectl edit deployments.apps webapp-mysql -n delta


####################################################################################################################################
####################################################################################################################################
*/---------------------------------------------------  control-plane-failure-----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################
1.Scale the deployment app to 2 pods.

Scale Deployment to 2 PODs

kubectl scale deploy app --replicas=2


################################################## node failure ####################################################
node01 ~ ➜  systemctl status containerd
node01 ~ ✖ systemctl start kubele

################################################## network troubleshooting ####################################################
1. Weave Net:

To install,

kubectl apply -f
https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

You can find details about the network plugins in the following documentation :

https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy

2. Flannel :

To install,

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

 

Note: As of now flannel does not support kubernetes network policies.

3. Calico :

 

To install,

curl https://docs.projectcalico.org/manifests/calico.yaml -O

Apply the manifest using the following command.

kubectl apply -f calico.yaml

Calico is said to have most advanced cni network plugin.

In CKA and CKAD exam, you won’t be asked to install the cni plugin. But if asked you will be provided with the exact url to install it.

Note: If there are multiple CNI configuration files in the directory, the kubelet uses the configuration file that comes first by name in lexicographic order.
DNS in Kubernetes
—————–

Kubernetes uses CoreDNS. CoreDNS is a flexible, extensible DNS server that can serve as the Kubernetes cluster DNS.

Memory and Pods

In large scale Kubernetes clusters, CoreDNS’s memory usage is predominantly affected by the number of Pods and Services in the cluster. Other factors include the size of the filled DNS answer cache, and the rate of queries received (QPS) per CoreDNS instance.

Kubernetes resources for coreDNS are:

    a service account named coredns,
    cluster-roles named coredns and kube-dns
    clusterrolebindings named coredns and kube-dns, 
    a deployment named coredns,
    a configmap named coredns and a
    service named kube-dns.

While analyzing the coreDNS deployment you can see that the the Corefile plugin consists of important configuration which is defined as a configmap.

Port 53 is used for for DNS resolution.

    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }

This is the backend to k8s for cluster.local and reverse domains.

proxy . /etc/resolv.conf

Forward out of cluster domains directly to right authoritative DNS server.
Troubleshooting issues related to coreDNS

1. If you find CoreDNS pods in pending state first check network plugin is installed.

2. coredns pods have CrashLoopBackOff or Error state

If you have nodes that are running SELinux with an older version of Docker you might experience a scenario where the coredns pods are not starting. To solve that you can try one of the following options:

a)Upgrade to a newer version of Docker.

b)Disable SELinux.

c)Modify the coredns deployment to set allowPrivilegeEscalation to true:

kubectl -n kube-system get deployment coredns -o yaml | \
  sed 's/allowPrivilegeEscalation: false/allowPrivilegeEscalation: true/g' | \
  kubectl apply -f -

d)Another cause for CoreDNS to have CrashLoopBackOff is when a CoreDNS Pod deployed in Kubernetes detects a loop.

There are many ways to work around this issue, some are listed here:

    Add the following to your kubelet config yaml: resolvConf: <path-to-your-real-resolv-conf-file> This flag tells kubelet to pass an alternate resolv.conf to Pods. For systems using systemd-resolved, /run/systemd/resolve/resolv.conf is typically the location of the “real” resolv.conf, although this can be different depending on your distribution.
    Disable the local DNS cache on host nodes, and restore /etc/resolv.conf to the original.
    A quick fix is to edit your Corefile, replacing forward . /etc/resolv.conf with the IP address of your upstream DNS, for example forward . 8.8.8.8. But this only fixes the issue for CoreDNS, kubelet will continue to forward the invalid resolv.conf to all default dnsPolicy Pods, leaving them unable to resolve DNS.

3. If CoreDNS pods and the kube-dns service is working fine, check the kube-dns service has valid endpoints.

kubectl -n kube-system get ep kube-dns

If there are no endpoints for the service, inspect the service and make sure it uses the correct selectors and ports.
Kube-Proxy
———

kube-proxy is a network proxy that runs on each node in the cluster. kube-proxy maintains network rules on nodes. These network rules allow network communication to the Pods from network sessions inside or outside of the cluster.

In a cluster configured with kubeadm, you can find kube-proxy as a daemonset.

kubeproxy is responsible for watching services and endpoint associated with each service. When the client is going to connect to the service using the virtual IP the kubeproxy is responsible for sending traffic to actual pods.

If you run a kubectl describe ds kube-proxy -n kube-system you can see that the kube-proxy binary runs with following command inside the kube-proxy container.

    Command:
      /usr/local/bin/kube-proxy
      --config=/var/lib/kube-proxy/config.conf
      --hostname-override=$(NODE_NAME)

 

So it fetches the configuration from a configuration file ie, /var/lib/kube-proxy/config.conf and we can override the hostname with the node name of at which the pod is running.

 

In the config file we define the clusterCIDR, kubeproxy mode, ipvs, iptables, bindaddress, kube-config etc.

 
Troubleshooting issues related to kube-proxy

1. Check kube-proxy pod in the kube-system namespace is running.

2. Check kube-proxy logs.

3. Check configmap is correctly defined and the config file for running kube-proxy binary is correct.

4. kube-config is defined in the config map.

5. check kube-proxy is running inside the container

# netstat -plan | grep kube-proxy
tcp        0      0 0.0.0.0:30081           0.0.0.0:*               LISTEN      1/kube-proxy
tcp        0      0 127.0.0.1:10249         0.0.0.0:*               LISTEN      1/kube-proxy
tcp        0      0 172.17.0.12:33706       172.17.0.12:6443        ESTABLISHED 1/kube-proxy
tcp6       0      0 :::10256                :::*                    LISTEN      1/kube-proxy

References:

Debug Service issues:

https://kubernetes.io/docs/tasks/debug-application-cluster/debug-service/

DNS Troubleshooting:

https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/


####################################################################################################################################
####################################################################################################################################
*/--------------------------------------------------- other topics-----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################

1.Get the list of nodes in JSON format and store it in a file at '/opt/outputs/nodes.json'.

kubectl get nodes -o json > /opt/outputs/nodes.json

2.Get the details of the node node01 in json format and store it in the file '/opt/outputs/node01.json'.

kubectl get node node01 -o json > /opt/outputs/node01.json

3.Use JSON PATH query to fetch node names and store them in '/opt/outputs/node_names.txt'.
Remember the file should only have node names.

kubectl get nodes -o=jsonpath='{.items[*].metadata.name}' > /opt/outputs/node_names.txt

4.Use JSON PATH query to retrieve the osImages of all the nodes and store it in a file /opt/outputs/nodes_os.txt.
The osImages are under the nodeInfo section under status of each node.

 kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os.txt
 
 5.A kube-config file is present at /root/my-kube-config. Get the user names from it and store it in a file /opt/outputs/users.txt.

Use the command kubectl config view --kubeconfig=/root/my-kube-config to view the custom kube-config.


kubectl config view --kubeconfig=my-kube-config  -o jsonpath="{.users[*].name}" > /opt/outputs/users.txt

6.A set of Persistent Volumes are available. Sort them based on their capacity and store the result in the file '/opt/outputs/storage-capacity-sorted.txt'.
kubectl get pv --sort-by=.spec.capacity.storage > /opt/outputs/storage-capacity-sorted.txt

7.That was good, but we dont need all the extra details. Retrieve just the first 2 columns of output and store it in /opt/outputs/pv-and-capacity-sorted.txt.
The columns should be named NAME and CAPACITY. Use the custom-columns option and remember, it should still be sorted as in the previous question.

kubectl get pv --sort-by=.spec.capacity.storage -o=custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage > /opt/outputs/pv-and-capacity-sorted.txt

8.Use a JSON PATH query to identify the context configured for the aws-user in the my-kube-config context file and store the result in /opt/outputs/aws-context-name.

kubectl config view --kubeconfig=my-kube-config -o jsonpath="{.contexts[?(@.context.user=='aws-user')].name}" > /opt/outputs/aws-context-name


####################################################################################################################################
####################################################################################################################################
*/--------------------------------------------------- Lighting-----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################
