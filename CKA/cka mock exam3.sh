1.
#create serviceaccount and grant list access all persistent volume and create role binding
sa
k create serviceaccount --help
k create serviceaccount pvviewer

k create clusterrole --help
k create clusterrole pvviewer-role --verb=list --respurce=persistentvolumes

k get clusterrole
k get clusterrole pvviewer-role

#rolebinding
k create clusterrolebinding --help
k create clusterrolebinding pvviewer-role-binding --clusterrole=pvviewer-role --serviceaccount=default:pvviewer

k run pvviewer --image=redis --dry-run -o yaml
k run pvviewer --image=redis --dry-run -o yaml > pvviewer.yaml

vi pvviewer.yaml
!add serviceAccountName: pvviewer under spec:

k apply -f pvviewer.yaml
k get pods
k describe pod pvviewer | grep i service

2.
#list InternalIP of all nodes and save to mentioned path
k get node -o wide

k get nodes -o json | jq | grep -i internalip
k get nodes -o json | jq | grep -i internalip -B 100

k get nodes -o json | jq -c 'paths'
k get nodes -o json | jq -c 'paths' | grep type
k get nodes -o json | jq -c 'paths' | grep type | grep -v condition

k get nodes -o jsonpath='{.items}'

k get nodes -o json | jq -c 'paths' | grep type | grep -v condition

k get nodes -o jsonpath='{.item[0].status.address}' | jq
k get nodes -o jsonpath='{.item[0].status.address[?(@.type=="InternalIP"0]]}' | jq

#only one file
kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'
#all file
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > /root/CKA/node_ips


cat /root/CKA/node_ips

3.
#create multi-pod with 2 container
k run multi-pod --image=nginx --dry-run=client -o yaml
k run multi-pod --image=nginx --dry-run=client -o yaml > multi-pod.yaml

vi multi-pod.yaml

spec:
  container:
  - image: nginx
    name: alpha
	env:
	  - name: "name"
	    value: "alpha"
  - image: busybox
    name: beta
	env:
	  - name: "name"
	    value: "beta"
	command: 
	  - sleep
	  - "4800"

k apply -f multi-pod.yaml
k get po

4.
#create pod with image ,runAsUser and fsGrop
k run non-root-pod --image=redis:alpine --dry-run=client -o yaml > non-root-pod.yaml

vi non-root-pod.yaml

type security Context in cheatsheet and paste it under spec:

securityContext:
    runAsUser: 1000
    fsGroup: 2000
	
k apply -f non-root-pod
k get po

5.
#recently created pod and service are not work, has to fix
#create network policy allow incoming conn to the service over port 80

k get po
k get svc

k run curl --image=alpine/curl --rm -it -- sh
curl
curl np-test-service
#final test
curl ingress-to-nptest

#cretae new terminal
k get pod --show-labels

vi network-policy.yaml

type Network policy in cheatsheet and copy resource

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-to-nptest
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: np-test-1
  policyTypes:
  - Ingress
  ingress:
  -
    ports:
    - protocol: TCP
      port: 80

k apply -f network-policy.yaml
k get networkpolicy

25:46

6.
#workernode taint unschedulable. create pods with image, workload are not schedule
k get nodes
k taint nodes node01 env_type=production:NoSchedule
k describe node node01

k run dev-redos --image=redis:alpine
k get po -o wide

k run prod-redis --image=redis:alpine --dry-run=client -o yaml > prod-redis.yaml

vi prod-redis.yaml

type tolerations in cheatsheet and copy resource

tolerations:
  - key: "env_type"
    operator: "Equal"
	value: "production"
    effect: "NoSchedule"

k apply -f prod-redis.yaml

k describe pod prod-redis
k get pods -o wide

7.
#create pod in namespace and belong to production environment and frontend tier
k create ns hr
k run hr-pod -n hr --image=redis:alpine --labels="environment=production,tier=frontend"
k get pod -n hr

8.
#kubeconfig file create under /root/CKA. fix it
k get nodes --kubeconfig /root/CKA/super.kubeconfig

vi /root/CKA/super.kubeconfig

#check config
cat .kube/config

vi /root/CKA/super.kubeconfig
change server:https://controlplane:6443

k get nodes --kubeconfig /root/CKA/super.kubeconfig

9.
#create deployment scale replica. fix

k scale deployment nginx-deploy --replicas=3 

k get deployment

#nothing change, so we go to controllermanager
k get po -n kube-system

cd /etc/kubernetes/manifests/kube-controller-manager.yaml
change 1 to l

k get po -n kube-system --watch

k get deployment