1.
#backup of etcd cluster and save in filepath

type etcdctl backup in cheatsheet and copy command

#format
ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save snapshot.db
ETCDCTL_API=3 etcdctl snapshot save -h

cat /etc/kubernetes/manifests/etcd.yaml | grep file

vi /etc/kubernetes/manifests/etcd.yaml

ETCDCTL_API=3 etcdctl --endpoints 127.0.0.1:2379 snapshot save <filepath>.db \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \ (#copy from --trusted-ca-file)
--cert= \ (#copy from cert-file)
--key= (#copy from key-file)

ls /opt/etcd-backup.db
-------------
2.

# create pod with image and volume type
k run redis-storage --image=redis:alpine --dry-run=client -o yaml
k run redis-storage --image=redis:alpine --dry-run=client -o yaml > redis-storage.yaml

type pod volume in cheatsheet and choose emptyDir and copy code 

#format we only use volume and volumeMounts
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: registry.k8s.io/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
  volumes:
  - name: cache-volume
    emptyDir: {}

	  
	  
!volume is add in end
!volumeMounts is under resources: {}

k apply -f redis-storage.yaml

k get pods --watch

3.
#create pod wih image and pod can set time, container should sleep 4800 sec
k run super-user-pod --image=busybox:1.2.88 --dry-run=client -o yaml
k run super-user-pod --image=busybox:1.2.88 --dry-run=client -o yaml > super-user-pod.yaml
vi super-user-pod


type security capabilities in cheatsheet and choose emptyDir and copy code
!add under container > name:super-user-pod
command: [ "sleep", "4800" ]

!add under resources: {} and it only need system time
    securityContext:
      capabilities:
        add: ["SYS_TIME"]
		
k apply -f super-user-pod.yaml
k get pods


4.
#edit pod created yaml file to mount pv
cat /root/CKA/use-pv.yaml

k get pvc
k get pv

type 'persistent volume' in cheatsheet and choose volume claims and copy code

vi pvc.yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Mi

k create -f pvc.yaml
kget pvc

#edit
vi /root/CKA/use-pv.yaml

type in cheatsheet. claims as volume

!paste under of restartPolicy: Always
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: my-pvc
		
!paste under resources: {}	
      volumeMounts:
      - mountPath: "/data"
        name: mypd

k create -f /root/CKA/use-pv.yaml
k get pod


14:55

5.
#create deployment with image and replica and version upgrade with rolling upgrade
k create deploy nginx-deploy --image=nginx:1.16 --replicas=1
k get deploy
k describe deploy nginx-deploy
k set --help

k set image deployment/nginx-deploy nginx=nginx:1.17
k describe deploy nginx-deploy

6.
#create new user and grant permission in the namespace
ls /root/CKA/
cd /root/CKA/
ls
cat john.csr

type role binding in cheatsheet. click certificate signing request

cat john.csr
vi john-csr.yaml

apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john-developer
spec:
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZqQ0NBVDRDQVFBd0VURVBNQTBHQTFVRUF3d0dZVzVuWld4aE1JSUJJakFOQmdrcWhraUc5dzBCQVFFRgpBQU9DQVE4QU1JSUJDZ0tDQVFFQTByczhJTHRHdTYxakx2dHhWTTJSVlRWMDNHWlJTWWw0dWluVWo4RElaWjBOCnR2MUZtRVFSd3VoaUZsOFEzcWl0Qm0wMUFSMkNJVXBGd2ZzSjZ4MXF3ckJzVkhZbGlBNVhwRVpZM3ExcGswSDQKM3Z3aGJlK1o2MVNrVHF5SVBYUUwrTWM5T1Nsbm0xb0R2N0NtSkZNMUlMRVI3QTVGZnZKOEdFRjJ6dHBoaUlFMwpub1dtdHNZb3JuT2wzc2lHQ2ZGZzR4Zmd4eW8ybmlneFNVekl1bXNnVm9PM2ttT0x1RVF6cXpkakJ3TFJXbWlECklmMXBMWnoyalVnald4UkhCM1gyWnVVV1d1T09PZnpXM01LaE8ybHEvZi9DdS8wYk83c0x0MCt3U2ZMSU91TFcKcW90blZtRmxMMytqTy82WDNDKzBERHk5aUtwbXJjVDBnWGZLemE1dHJRSURBUUFCb0FBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnRUJBR05WdmVIOGR4ZzNvK21VeVRkbmFjVmQ1N24zSkExdnZEU1JWREkyQTZ1eXN3ZFp1L1BVCkkwZXpZWFV0RVNnSk1IRmQycVVNMjNuNVJsSXJ3R0xuUXFISUh5VStWWHhsdnZsRnpNOVpEWllSTmU3QlJvYXgKQVlEdUI5STZXT3FYbkFvczFqRmxNUG5NbFpqdU5kSGxpT1BjTU1oNndLaTZzZFhpVStHYTJ2RUVLY01jSVUyRgpvU2djUWdMYTk0aEpacGk3ZnNMdm1OQUxoT045UHdNMGM1dVJVejV4T0dGMUtCbWRSeEgvbUNOS2JKYjFRQm1HCkkwYitEUEdaTktXTU0xMzhIQXdoV0tkNjVoVHdYOWl4V3ZHMkh4TG1WQzg0L1BHT0tWQW9FNkpsYWFHdTlQVmkKdjlOSjVaZlZrcXdCd0hKbzZXdk9xVlA3SVFjZmg3d0drWm89Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
  
#for 64base user
cat john.csr | base64 | tr -d "\n"

copy all of file before root

vi john-csr.yaml
request: paste in here

k create -f john-csr.yaml

#certificate signing request
k get csr

#csr is pending state, need approval
k certificate approve john-developer

k get csr

#2nd part
k create role --help

k create role developer --verb=create,get,list,update,delete --resource=pods -n development

k get role -n development

k describe role -n development

k auth --help

#after role binding, it should say to yes
k auth can-i get pods --namespace=development --as john

k create rolebinding --help
k create rolebinding john-developer --role=developer --user=john -n development
k get <status>.io -n development

#check
k describe <status>.io -n development

#it say yes now for roles
k auth can-i get pods --namespace=development --as john
k auth can-i create pods --namespace=development --as john

7.
#create pods with image and expose interanlly service and record result in mentioned path
k run nginx-resolver --image=nginx
k get pods
k expose pod nginx-resolver --name=nginx-resolver-service --port=80

k describe svc nginx-resolver-service

#add sleep to run in background
k run busybox --image=busybox:1.28 -- sleep 4000
k get pods

k exec busybox -- nslookup nginx-resolver-service
k exec busybox -- nslookup nginx-resolver-service > /root/CKA/nginx.svc

type DSN for service and pods in cheatsheet. click pods

#to get ip look nginx-resolver
k get pods -o wide
k exec busybox -- nslookup 10-244-192-4.default.pod.cluster.local
k exec busybox -- nslookup 10-244-192-4.default.pod.cluster.local > /root/CKA/nginx.svc

8.
#create static pod on node01 with image and static pod path
ssh node01

controlplane
k run nginx-critical --image=nginx --restart=Always --dry-run=client -o yaml

node01
cat > /etc/kubernetes/manifests/nginx-critical.yaml
k get pods
