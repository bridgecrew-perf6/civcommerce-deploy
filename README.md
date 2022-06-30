# civcommerce-deploy

### For single step deploy
```
take a look at deploy.sh
```

### For local kind
kind create cluster
kind load docker-image <img>

### create namespace
```
kubectl create namespace ingress
```

### if not already added -->
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

### install nginx
```
helm install nginx-ingress ingress-nginx/ingress-nginx \
     --namespace ingress \
     --set controller.replicaCount=2 \
     --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
     --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
```

### apply ymls
```
kubectl apply -f backend.yml --namespace ingress
```
```
kubectl apply -f frontend.yml --namespace ingress
```
```
kubectl apply -f ingress.yml --namespace ingress
```
### check the deployment and visit the website on external IP
```
kubectl get service/nginx-ingress-ingress-nginx-controller -o wide --namespace ingress
```
