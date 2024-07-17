# https://argoproj.github.io/argo-cd/getting_started/
kubectl create namespace argocd
wget https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -O argocd/install.yaml
sed -E 's/type: RuntimeDefault/type: Unconfined/g' < argocd/install.yaml > argocd/install-patched.yaml
kubectl apply -n argocd -f argocd/install-patched.yaml

#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
brew install argocd

# ingress for dashboard
kubectl apply -f argocd/argocd-ingress.yaml

# run this locally in the k8s machine
kubectl port-forward svc/argocd-server -n argocd --address 192.168.1.30 8080:443
# https://argocd.local.test:8080/

# find out if we need the ingress, the port forwarding or both


# password (not add to history with the space in the beginning)
# PASSWORD=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
# this is what the latest instructions 
 PASSWORD=$(argocd admin initial-password -n argocd|head -1)

# CLI
brew install argocd
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
argocd login 192.168.1.30:8080
# username: admin and password the above