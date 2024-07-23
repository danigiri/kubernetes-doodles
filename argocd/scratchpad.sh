# INSTALLATION
# https://argoproj.github.io/argo-cd/getting_started/
kubectl create namespace argocd
wget https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -O argocd/install.yaml
# patch the install
sed -E 's/type: RuntimeDefault/type: Unconfined/g' < argocd/install.yaml > argocd/install-patched.yaml
kubectl apply -n argocd -f argocd/install-patched.yaml


# expose argo cd, two options:
# A) either ingress (https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/)
# in this case, going for two ingress controller entries
kubectl apply -f argocd/argocd-ingress.yaml
kubectl apply -f argocd/argocd-grpc-ingress.yaml
# this means we terminate TLS at the ingress and boot argocd without TLS
# which means we also need to patch argocd to load without TLS (config map: argocd-cmd-params-cm)
# https://kubernetes.io/docs/tasks/manage-kubernetes-objects/update-api-object-kubectl-patch/
kubectl patch configmap argocd-cmd-params-cm -n argocd -p $'data:\n server.insecure: "true"'
kubectl -n argocd scale deployment argocd-server --replicas=0
sleep 30 # give some time to shutdown
kubectl -n argocd scale deployment argocd-server --replicas=1


# B) run this locally in the k8s machine
# kubectl port-forward svc/argocd-server -n argocd --address 192.168.1.30 8080:443
# https://argocd.local.test:8080/

# INSTALLATION INSTRUCTIONS END HERE

# password (not add to history with the space in the beginning)
 PASSWORD=$(argocd admin initial-password -n argocd|head -1)
# use `argocd account update-password` to change

# CLI
brew install argocd
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
# username: admin and password the above
argocd login argocd-grpc.local.test --username admin --password $PASSWORD --insecure --grpc-web


# debugging argocd with interactive session
kubectl run -n argo -i --tty --rm debug --image argoproj/argocd --restart=Never sh
