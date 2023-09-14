https://kubernetes.github.io/ingress-nginx/deploy/#network-load-balancer-nlb

## Key Concepts

### MasterNodes and WorkerNodes in Kubernetes

In a Kubernetes cluster, the master nodes are responsible for managing the state of the cluster and coordinating the
work of the worker nodes. The worker nodes are responsible for running the containers that make up the applications and
services deployed in the cluster.

In a cluster running on EC2 servers, the master nodes can run on a separate EC2 instance or instances from the worker
nodes. This allows for better control over the resources and performance of the cluster, and provides a level of
redundancy in case one of the instances fails.

The master nodes typically need more resources and a more robust network connection than the worker nodes, as they are
responsible for maintaining the state of the cluster, scheduling pods, and serving the API. Running the master nodes on
separate EC2 instances helps to ensure that they have the resources they need to perform their tasks, and that any
failures of the worker nodes will not affect the performance of the master nodes.

The worker nodes can run on different EC2 instances for a number of reasons. For example, you might want to separate the
worker nodes onto different instances to better manage resource usage, or to provide redundancy in case one of the
instances fails. Running worker nodes on different instances also allows you to scale the number of worker nodes up or
down as needed, to accommodate changes in the workload.

In summary, the master and worker nodes in a Kubernetes cluster running on EC2 servers can run on different instances to
better manage resources, provide redundancy, and allow for scalability. The configuration of the cluster depends on the
specific needs and requirements of the deployment.

### Pod

Pod is a running application (replica) of a deployment

### Service

Exposes a port for deployment (Nodeport=deployment available from outside the cluster, ClusterIp=internal communication
for deployments only , Loadbalancer)

### Daemonset

A daemonset exposes the deployment to all nodes. This behavior is especially useful for deploying system-level
operations
across each node, such as log collectors and collecting metrics. E.g Ingress controller (rather than using nodeport),
Prometheus Node Exporter.

### Deployment

A Deployment is a higher-level API object in Kubernetes that manages the desired state for Pods and ReplicaSets.

### Replicaset

A ReplicaSet ensures that a specified number of Pod replicas are running at any given time. It's often used by
Deployments to handle Pod scaling and updates.

### Statefulset

A StatefulSet manages the deployment and scaling of a set of Pods and provides guarantees about the ordering and
uniqueness of these Pods. It's used for stateful applications like databases.

### Kops resources

[]: #

Kops creates several resources in an Amazon Web Services (AWS) account when spinning up a Kubernetes cluster. These
resources include:

- EC2 instances: Kops creates EC2 instances for the nodes in the cluster, which run the Kubernetes components and host
  the containers.

- VPC: Kops creates a Virtual Private Cloud (VPC) to contain the resources for the cluster.

- Security Groups: Kops creates security groups to control network access to the instances in the cluster.

- Auto Scaling groups: Kops creates Auto Scaling groups to manage the number of nodes in the cluster, ensuring that the
  cluster has the desired number of nodes even in the case of node failures.

- Load Balancers: Kops creates load balancers to distribute incoming traffic to the nodes in the cluster, ensuring that
  the cluster is highly available.

- DNS records: Kops creates DNS records in Amazon Route 53 to associate domain names with the load balancers in the
  cluster.

- IAM roles: Kops creates IAM roles to control access to AWS resources from the instances in the cluster.

In addition to these resources, Kops also creates S3 buckets to store cluster configuration and state information, as
well as other resources as required by the cluster. The exact set of resources created by Kops depends on the specific
configuration of the cluster.

### NodePort

Allowed range of 30000 to 32767 ports

### Helm

- [Artifacthub](https://artifacthub.io/)
- Package manager for Kubernetes (similar to docker hub)

## Kops

### change fields use ALB/NLB

```
proxy-real-ip-cidr: XXX.XXX.XXX/XX
service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:us-west-2:XXXXXXXX:certificate/XXXXXX-XXXXXXX-XXXXXXX-XXXXXXXX
service.beta.kubernetes.io/aws-load-balancer-type: nlb -> alb
```

### Setup aws

https://kops.sigs.k8s.io/getting_started/aws/

```
aws iam create-group --group-name kops

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess --group-name kops
aws iam create-user --user-name kops
aws iam add-user-to-group --user-name kops --group-name kops
aws iam create-access-key --user-name kops

# create s3
aws s3api create-bucket --bucket cluster-com-state-store --region us-east-1
aws s3api put-bucket-versioning --bucket cluster-com-state-store --versioning-configuration Status=Enabled
aws s3api create-bucket --bucket cluster-com-oidc-store --region us-east-1 --acl public-read
aws s3api put-bucket-encryption --bucket cluster-com-state-store --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

aws ec2 describe-availability-zones --region us-east-1
```

### Setup k8s

```
# Server info 
Creates two ec2 instances of type: t3.medium
Creates two Auto Scaling Groups 
t2.medium = 2 cpu 4GiB Memory = $0.0464 per hour
t3.medium = 2 cpu 4GiB Memory = $0.0416 per hour = (0.43kr * 24) * 30 = 309.6 * 2 = 619kr month

# Aws setup
aws configure

# Install kops
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops
kops version

# Create Cluster
# Test valid domain
dig ns example.com

export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export NAME=example.com
export KOPS_STATE_STORE=s3://example-com-state-store

kops create cluster \
  --name=${NAME} \
  --cloud=aws \
  --zones=us-east-1a \
  --discovery-store=s3://example-com-oidc-store/${NAME}/discovery \
  --dns-zone=example.com

kops get clusters
kops edit cluster --name ${NAME}
kops update cluster --name ${NAME} --yes --admin

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

kubectl get nodes
kops validate cluster --wait 10m
kubectl -n kube-system get po
```

### Delete Cluster

```
# Delete cluster (cost money)
kops get clusters
kops delete cluster --name ${NAME}
kops delete cluster --name ${NAME} --yes
```

### Useful kops commands

```
kops get cluster chainqt3.com -o yaml
```

### Test route53 dns

```
dig ns chainqt3.com
```

## cert-manager

### Install

- Issuer
- Certificate
- Secret

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml
kubectl get pods --namespace cert-manager

apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}

---

apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: selfsigned-cert
spec:
  commonName: teacher-portal.minikube
  secretName: selfsigned-cert-tls
  issuerRef:
    name: selfsigned-issuer

```
