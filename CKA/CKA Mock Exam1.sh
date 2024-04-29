
https://kubernetes.io/docs/reference/kubectl/quick-reference/

1.
#create pods with image
kubectl run nginx-pod --image=nginx:alpine
kubectl get pods

2.
#create pods with image and labels
kubectl run messaging --image=redis:alpine --labels="tier=msg"
kubectl get pods

3.
#create namespace
k create namespace <name>

4.
#list of node with JSON format and store in particular file
k get nodes -o json > <filepath>.json
cat <filepath>.json

5.
#create a service
k expose --help
k expose pod messaging --port 6379 --name messaging-service
k get svc

6.
#create a deployment
k create deployment <deployment-name> --image=<image-name> --replicas=2
k get deployment

7.
#create static pod on controlplane node with image and sleep
k run <pod-name> --image=<image-name> --dry-run=client -o yaml --command -- sleep 1000
k run <pod-name> --image=<image-name> --dry-run=client -o yaml --command -- sleep 1000 >static-busybox.yaml
mv static-busybox.yaml /etc/kubernetes/manifests/

8.
#create pod under namespace with image
k run  <[pod-name> --image=<image-name> -n <namespace-name>
k get pod -n <namespace-name>

9.
#fix new app 'orange' issue.
Init container issue
k describe pod orange
k logs orange init-myservice
k edit pod orange

#force save
k replace --force -f <tmp-file>.yaml
k get pods

10.
#create expose deployment service with port,nodeport,endpoint 
k get deployment
k expose deployment <deployment-name> --name=<service-name> --type NodePort --port 8080
#change Nodeport no
k edit svc <service-name>

11.
#file lookup json format and store in mentioned file-path
k get node -o json
k get nodes -o jsonpath='{.item[*].status.nodeInfo.osImage}'
k get nodes -o jsonpath='{.item[*].status.nodeInfo.osImage}' > <file-path>.txt

kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os_x43kj56.txt
cat <file-path>.txt

# Get ExternalIPs of all nodes
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}'

12.
#create persistant volume with storage,accesmode,hostpath

