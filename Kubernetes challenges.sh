

######################################## Kubernetes challenges 2 ############################################################


######################################## Control plane ##########
#checking cluster is run or fail
kubectl get nodes

#change the port in config file
vi .kube/config

edit controlplane no to 6443

kubectl get nodes

#checking docker running container
docker ps

#checking logs of kube api
docker ps -a | grep -i  api

#checking why kube api is exit
#read the error 
docker logs <container-id>

#have static pods defintion file
cd /etc/kubernetes/mainfests/

ls

vi kube-apiserver.yaml

#not fount crt file
ls /etc/kubernetes/pki/ca-*.crt

ls /etc/kubernetes/pki/ca*

#so we edit again
vi kube-apiserver.yaml

#change path 
--client-ca-file=/etc/kubernetes/pki/ca.crt

#finding image under kube-system and show deployment
kubectl get deployment -n kube-system

kubectl edit deployment -n kube-system <deployment-name>

edit image name

#checking cluster is ready or not
kubectl get deployment -n kube-system

######################################## node01 ##########
docker ps

#enable node01
kubectl uncordon node01

kubectl get nodes

######################################## /web ##########

cd /media

scp kodekloud-ckad.png node01:/web
scp kodekloud-cka.png node01:/web
scp kodekloud-cks.png node01:/web

cd ..

######################################## data-pv pvc##########
vi pvc.yaml
paste from github

kubectl apply -f pvc.yaml

#status to bound
kubectl get pvc

######################################## port and service##########
vi pod.yaml
kubectl apply -f pod.yaml

#pod is running now
kubectl get all




######################################## Kubernetes challenges 4 ############################################################
#check kubectl config map is have or not
kubectl get cm
kubectl describe cm redis-cluster-configmap

vi pv.yaml
kubectl apply -f pv.yaml

#validate
kubectl get pv

kubectl get all


