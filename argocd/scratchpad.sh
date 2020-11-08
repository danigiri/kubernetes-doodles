# https://argoproj.github.io/argo-cd/getting_started/
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
brew install argocd

# dashboard
 kubectl port-forward svc/argocd-server -n argocd --address 192.168.1.30 8080:443
 

# CLI
brew install argocd
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
argocd login 192.168.1.30:8080
