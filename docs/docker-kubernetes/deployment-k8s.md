https://kubernetes.github.io/ingress-nginx/deploy/#network-load-balancer-nlb

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
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export NAME=example.com
export KOPS_STATE_STORE=s3://example-com-state-store

# Install kops
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops
kops version

kops create cluster \
--name=${NAME} \
--cloud=aws \
--zones=us-east-1a \
--discovery-store=s3://example-com-oidc-store/${NAME}/discovery
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

# Delete cluster (cost money)
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
