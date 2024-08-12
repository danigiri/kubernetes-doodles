# ARGOCD INSTALLATION
# https://argoproj.github.io/argo-cd/getting_started/

export ARGOCD_HOST=argocd-grpc.h0.local.test

kubectl create namespace argocd
wget https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -O argocd/install.yaml
# patch the install
sed -E 's/type: RuntimeDefault/type: Unconfined/g' < argocd/install.yaml > argocd/install-patched.yaml
kubectl apply -n argocd -f argocd/install-patched.yaml
sleep 1

# expose argo cd, two options:
# A) either ingress (https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/)
# in this case, going for two ingress controller entries
kubectl apply -f argocd/ingress/argocd-ingress.yaml
kubectl apply -f argocd/ingress/argocd-grpc-ingress.yaml
# this means we terminate TLS at the ingress and boot argocd without TLS
# which means we also need to patch argocd to load without TLS (config map: argocd-cmd-params-cm)
# https://kubernetes.io/docs/tasks/manage-kubernetes-objects/update-api-object-kubectl-patch/
kubectl patch configmap argocd-cmd-params-cm -n argocd -p $'data:\n server.insecure: "true"'
kubectl -n argocd scale deployment argocd-server --replicas=0
# give some time to shutdown the pod
sleep 10
kubectl -n argocd scale deployment argocd-server --replicas=1

# B) run this locally in the k8s machine
# kubectl port-forward svc/argocd-server -n argocd --address 192.168.1.30 8080:443
# https://argocd.local.test:8080/

# make sure the initial-password secret is available
sleep 10  
# password (not add to history with the space in the beginning), change as needed
 ARGOCD_PASSWORD=$(argocd admin initial-password -n argocd|head -1)
# use `argocd account update-password` to change

# brew install argocd

# new password, adding some chars at the end of existing password, but feel free to modify
argocd login "$ARGOCD_HOST" --username admin --password "$ARGOCD_PASSWORD" --insecure
 export ARGOCD_PASSWORD="$ARGOCD_PASSWORD"xx
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "'$(argocd account bcrypt --password $ARGOCD_PASSWORD)'",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

# to get it
# kubectl -n argocd get secret argocd-secret -o jsonpath='{.data.admin\.password}' | base64 --decode

# argocd is now ready


# INSTALLATION INSTRUCTIONS END HERE

