####################################################################################################################################
####################################################################################################################################
*/--------------------------------------------------- Security -----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################

test kube config


####################################################################################################################################
####################################################################################################################################
*/--------------------------------------------------- Networking -----------------------------------------------------/*
####################################################################################################################################
####################################################################################################################################

*/-----------------------------------------------------------------------------------------------------------------------------------*/
*/------------------------------------------------  Explore Environment -------------------------------------------------------------*/
*/-----------------------------------------------------------------------------------------------------------------------------------*/

While testing the Network Namespaces, if you come across issues where you can’t ping one namespace from the other, make sure you set the NETMASK while setting IP Address. ie: 192.168.1.10/24

ip -n red addr add 192.168.1.10/24 dev veth-red

--------
Important Note about CNI and CKA Exam

An important tip about deploying Network Addons in a Kubernetes cluster.

In the upcoming labs, we will work with Network Addons. This includes installing a network plugin in the cluster. While we have used weave-net as an example, please bear in mind that you can use any of the plugins which are described here:

https://kubernetes.io/docs/concepts/cluster-administration/addons/

https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model


1.What is the network interface configured for cluster connectivity on the controlplane node?
node-to-node communication


controlplane:~# kubectl get nodes controlplane -o wide
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
controlplane   Ready    control-plane   7m    v1.29.0   192.23.97.3   <none>        Ubuntu 22.04.3 LTS   5.4.0-1106-gcp   containerd://1.6.26

controlplane ~ ✖ ip a | grep -B2 192.23.97.3
13582: eth0@if13583: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
    link/ether 02:42:c0:25:1a:06 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.37.26.6/24 brd 192.37.26.255 scope global eth0
	
2. What is the MAC address of the interface on the 'controlplane node'?

controlplane ~ ➜  ip link show eth0
13582: eth0@if13583: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 02:42:c0:25:1a:06 brd ff:ff:ff:ff:ff:ff link-netnsid 0
	
3. What is the MAC address of the interface on the 'node01'?
node01 ~ ➜  ip link show eth0
11159: eth0@if11160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 02:42:c0:25:1a:09 brd ff:ff:ff:ff:ff:ff link-netnsid 0

4.We use Containerd as our container runtime. What is the interface/bridge created by Containerd on the controlplane node?
ip link 

5.If you were to ping google from the controlplane node, which route does it take?
What is the IP address of the Default Gateway?

controlplane ~  ip route show default
default via 172.25.0.1 dev eth1 

6.

Here is a sample result of using the netstat command and searching for the scheduler process:

root@controlplane:~# netstat -nplt | grep scheduler
tcp        0      0 127.0.0.1:10259         0.0.0.0:*               LISTEN      3665/kube-scheduler 
root@controlplane:~# 

We can see that the kube-scheduler process binds to the port 10259 on the controlplane node.

7.Notice that ETCD is listening on two ports. Which of these have more client connections established?

8. etcd more connection

controlplane ~ ➜  netstat -nplt | grep etcd
tcp        0      0 192.37.26.6:2379        0.0.0.0:*               LISTEN      3725/etcd           
tcp        0      0 127.0.0.1:2379          0.0.0.0:*               LISTEN      3725/etcd           
tcp        0      0 192.37.26.6:2380        0.0.0.0:*               LISTEN      3725/etcd           
tcp        0      0 127.0.0.1:2381          0.0.0.0:*               LISTEN      3725/etcd   

controlplane ~ ✖ netstat -nplt | grep etcd | grep 2380 | wc -l
1

controlplane ~ ➜  netstat -nplt | grep etcd | grep 2379 | wc -l
2

controlplane ~ ➜  netstat -nplt | grep etcd | grep 2381 | wc -l
1

*/-----------------------------------------------------------------------------------------------------------------------------------*/
*/------------------------------------------------  CNI -------------------------------------------------------------*/
*/-----------------------------------------------------------------------------------------------------------------------------------*/
1.Inspect the kubelet service and identify the container runtime endpoint value is set for Kubernetes.

controlplane ~ ➜  ps -aux | grep kubelet | grep --color container-runtime-endpoint
root        4285  0.0  0.0 4148204 103976 ?      Ssl  17:12   0:06 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf 
--kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml 
--container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.9

2.What is the path configured with all binaries of CNI supported plugins?

The CNI binaries are located under '/opt/cni/bin' by default.

3.dentify which of the below plugins is not available in the list of available CNI plugins on this host?
 ls /opt/cni/bin/
 
 4.
 ls /etc/cni/net.d/
 
 5.What binary executable file will be run by kubelet after a container and its associated namespace are created?
 
 vi /etc/cni/net.d/10-flannel.conflist  and look type field
 
*/-----------------------------------------------------------------------------------------------------------------------------------*/
*/------------------------------------------------  deploy-network-solution -------------------------------------------------------------*/
*/-----------------------------------------------------------------------------------------------------------------------------------*/
1.Deploy weave-net networking solution to the cluster.
NOTE: - We already have provided a weave manifest file under the /root/weave directory. 

controlplane ~ ➜  kubectl apply -f /root/weave/weave-daemonset-k8s.yaml
serviceaccount/weave-net created
clusterrole.rbac.authorization.k8s.io/weave-net created
clusterrolebinding.rbac.authorization.k8s.io/weave-net created
role.rbac.authorization.k8s.io/weave-net created
rolebinding.rbac.authorization.k8s.io/weave-net created
daemonset.apps/weave-net created

controlplane ~ ➜  kubectl get pods -A | grep weave
kube-system   weave-net-2p8tr                        2/2     Running             0          14s


*/-----------------------------------------------------------------------------------------------------------------------------------*/
*/------------------------------------------------  networking-weave -------------------------------------------------------------*/
*/-----------------------------------------------------------------------------------------------------------------------------------*/

1.

/etc/cni/net.d/

2.How many weave agents/peers are deployed in this cluster?
 k get pods -n kube-system 
 
 3.On which nodes are the weave peers present?
controlplane ~ ✖ k get po -owide -n kube-system | grep weave
weave-net-pth68                        2/2     Running   1 (84m ago)   84m   192.36.163.3   controlplane   <none>           <none>
weave-net-swlm9                        2/2     Running   0             83m   192.36.163.6   node01         <none>           <none>

3.Identify the name of the bridge network/interface created by weave on each node.
ip link

4.What is the POD IP address range configured by weave?
ip addr show weave

5.
What is the default gateway configured on the PODs scheduled on node01?
Try scheduling a pod on node01 and check ip route output

ip route

*/-----------------------------------------------------------------------------------------------------------------------------------*/
*/------------------------------------------------  service-networking -------------------------------------------------------------*/
*/-----------------------------------------------------------------------------------------------------------------------------------*/
1.What network range are the nodes in the cluster part of?

ip addr and look at the IP address assigned to the eth0 interfaces

ip addr | grep eth0

2.What is the range of IP addresses configured for PODs on this cluster?

 kubectl logs weave-net-gn8m6 weave -n kube-system | grep ipalloc-range
 
3.What is the IP Range configured for the services within the cluster?
cat /etc/kubernetes/manifests/kube-apiserver.yaml   | grep cluster-ip-range

4.How many kube-proxy pods are deployed in this cluster?

kubectl get po -n kube-system | grep kube-proxy

5.What type of proxy is the kube-proxy configured to use?
kubectl get po -n kube-system

6.How does this Kubernetes cluster ensure that a kube-proxy pod runs on all nodes in the cluster?
Inspect the kube-proxy pods and try to identify how they are deployed.

kubectl get ds -n kube-system 

*/-----------------------------------------------------------------------------------------------------------------------------------*/
*/------------------------------------------------  core-dns -------------------------------------------------------------*/
*/-----------------------------------------------------------------------------------------------------------------------------------*/
1.Identify the DNS solution implemented in this cluster.
kubectl get pods -n kube-system

2.What is the name of the service created for accessing CoreDNS?
kubectl get service -n kube-system

3.What is the IP of the CoreDNS server that should be configured on PODs to resolve services?
kubectl get service -n kube-system

4.Where is the configuration file located for configuring the CoreDNS service?
kubectl -n kube-system describe deployments.apps coredns | grep -A2 Args | grep Corefile

5.How is the Corefile passed into the CoreDNS POD?
k get cm -n kube-system

6.What is the root domain/zone configured for this kubernetes cluster?
kubectl describe configmap coredns -n kube-system

7.What name can be used to access the hr web server from the test Application?
You can execute a curl command on the test pod to test. Alternatively, the test Application also has a UI. Access it using the tab at the top of your terminal named test-app.

8.What name can be used to access the hr web server from the test Application?
You can execute a curl command on the test pod to test. Alternatively, the test Application also has a UI. Access it using the tab at the top of your terminal named test-app.
k get svc

9.
We just deployed a web server - webapp - that accesses a database mysql - server. However the web server is failing to connect to the database server. Troubleshoot and fix the issue.

They could be in different namespaces. First locate the applications. The web server interface can be seen by clicking the tab Web Server at the top of your terminal.

Web Server: webapp

Uses the right DB_Host name

kubectl edit deploy webapp and correct the DB_Host value.

10.From the hr pod nslookup the mysql service and redirect the output to a file /root/CKA/nslookup.out
kubectl exec -it hr -- nslookup mysql.payroll > /root/CKA/nslookup.out

*/-----------------------------------------------------------------------------------------------------------------------------------*/
*/------------------------------------------------  Ingress -------------------------------------------------------------*/
*/-----------------------------------------------------------------------------------------------------------------------------------*/
Like in apiVersion, serviceName and servicePort etc.

Format - kubectl create ingress <ingress-name> --rule="host/path=service:port"

Example - kubectl create ingress ingress-test --rule="wear.my-online-store.com/wear*=wear-service:80"

*/-----------------------------------------------------------------------------------------------------------------------------------*/
*/------------------------------------------------  cka-ingress-networking-1 -------------------------------------------------------------*/
*/-----------------------------------------------------------------------------------------------------------------------------------*/
1.Which namespace is the Ingress Controller deployed in?

kubectl get all -A and identify the namespace of Ingress Controller.

2.What is the name of the Ingress Controller Deployment?

kubectl get deploy -A or kubectl get deploy --all-namespaces and identify the name of Ingress Controller.

3.k get pods -n app-space

4.Which namespace is the Ingress Resource deployed in?
kubectl get ingress --all-namespaces

5.What backend is the /wear path on the Ingress configured with?
kubectl describe ingress --namespace app-space and look under the Rules section.

6.If the requirement does not match any of the configured paths in the Ingress, to which service are the requests forwarded?
kubectl get deploy ingress-nginx-controller -n ingress-nginx -o yaml. In the manifest, search for the argument --default-backend-service

7.You are requested to change the URLs at which the applications are made available.

Make the video application available at /stream.
Ingress: ingress-wear-watch
Path: /stream
Backend Service: video-service
Backend Service Port: 8080

kubectl edit ingress --namespace app-space and change the path to the video streaming application to /stream.


8.You are requested to add a new path to your ingress to make the food delivery application available to your customers.

Make the new application available at /eat.


kubectl edit ingress --namespace app-space

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
  name: ingress-wear-watch
  namespace: app-space
spec:
  rules:
  - http:
      paths:
      - backend:
          service:
            name: wear-service
            port: 
              number: 8080
        path: /wear
        pathType: Prefix
      - backend:
          service:
            name: video-service
            port: 
              number: 8080
        path: /stream
        pathType: Prefix
      - backend:
          service:
            name: food-service
            port: 
              number: 8080
        path: /eat
        pathType: Prefix

9.A new payment service has been introduced. Since it is critical, the new application is deployed in its own namespace.
Identify the namespace in which the new application is deployed.

kubectl get deployments.apps --all-namespaces

10.You are requested to make the new application available at /pay.
Identify and implement the best approach to making this application available on the ingress controller and test to make sure its working. Look into annotations: rewrite-target as well.

Ingress Created
Path: /pay
Configure correct backend service
Configure correct backend port


 kubectl apply -f test-ingress.yaml 
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  namespace: critical-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /pay
        pathType: Prefix
        backend:
          service:
           name: pay-service
           port:
            number: 8282


*/-----------------------------------------------------------------------------------------------------------------------------------*/
*/------------------------------------------------  cka-ingress-networking-2 -------------------------------------------------------------*/
*/-----------------------------------------------------------------------------------------------------------------------------------*/

controlplane ~ ➜  kubectl create namespace ingress-nginx
namespace/ingress-nginx created

controlplane ~ ➜  kubectl create configmap ingress-nginx-controller --namespace ingress-nginx 
configmap/ingress-nginx-controller created

3.The NGINX Ingress Controller requires two ServiceAccounts. Create both ServiceAccount with name ingress-nginx and ingress-nginx-admission in the ingress-nginx namespace.

Use the spec provided below.

Name: ingress-nginx
Name: ingress-nginx-admission

kubectl create serviceaccount ingress-nginx --namespace ingress-nginx
kubectl create serviceaccount ingress-nginx-admission --namespace ingress-nginx

4.Let us now deploy the Ingress Controller. Create the Kubernetes objects using the given file.

The Deployment and its service configuration is given at /root/ingress-controller.yaml. There are several issues with it. Try to fix them.

    Note: Do not edit the default image provided in the given file. The image validation check passes when other issues are resolved.

Deployed in the correct namespace.
Replicas: 1
Use the right image

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.1.2
    helm.sh/chart: ingress-nginx-4.0.18
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  minReadySeconds: 0
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app.kubernetes.io/component: controller
      app.kubernetes.io/instance: ingress-nginx
      app.kubernetes.io/name: ingress-nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/name: ingress-nginx
    spec:
      containers:
      - args:
        - /nginx-ingress-controller
        - --publish-service=$(POD_NAMESPACE)/ingress-nginx-controller
        - --election-id=ingress-controller-leader
        - --watch-ingress-without-class=true
        - --default-backend-service=app-space/default-http-backend
        - --controller-class=k8s.io/ingress-nginx
        - --ingress-class=nginx
        - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
        - --validating-webhook=:8443
        - --validating-webhook-certificate=/usr/local/certificates/cert
        - --validating-webhook-key=/usr/local/certificates/key
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: LD_PRELOAD
          value: /usr/local/lib/libmimalloc.so
        image: registry.k8s.io/ingress-nginx/controller:v1.1.2@sha256:28b11ce69e57843de44e3db6413e98d09de0f6688e33d4bd384002a44f78405c
        imagePullPolicy: IfNotPresent
        lifecycle:
          preStop:
            exec:
              command:
              - /wait-shutdown
        livenessProbe:
          failureThreshold: 5
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        name: controller
        ports:
        - name: http
          containerPort: 80
          protocol: TCP
        - containerPort: 443
          name: https
          protocol: TCP
        - containerPort: 8443
          name: webhook
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        resources:
          requests:
            cpu: 100m
            memory: 90Mi
        securityContext:
          allowPrivilegeEscalation: true
          capabilities:
            add:
            - NET_BIND_SERVICE
            drop:
            - ALL
          runAsUser: 101
        volumeMounts:
        - mountPath: /usr/local/certificates/
          name: webhook-cert
          readOnly: true
      dnsPolicy: ClusterFirst
      nodeSelector:
        kubernetes.io/os: linux
      serviceAccountName: ingress-nginx
      terminationGracePeriodSeconds: 300
      volumes:
      - name: webhook-cert
        secret:
          secretName: ingress-nginx-admission

---

apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.1.2
    helm.sh/chart: ingress-nginx-4.0.18
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 30080
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  type: NodePort
  
  
5.Create the ingress resource to make the applications available at /wear and /watch on the Ingress service.

Also, make use of rewrite-target annotation field: -

nginx.ingress.kubernetes.io/rewrite-target: /




Ingress resource comes under the namespace scoped, so dont forget to create the ingress in the app-space namespace.

Ingress Created
Path: /wear
Path: /watch
Configure correct backend service for /wear
Configure correct backend service for /watch
Configure correct backend port for /wear service
Configure correct backend port for /watch service

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear-watch
  namespace: app-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /wear
        pathType: Prefix
        backend:
          service:
           name: wear-service
           port: 
            number: 8080
      - path: /watch
        pathType: Prefix
        backend:
          service:
           name: video-service
           port:
            number: 8080



