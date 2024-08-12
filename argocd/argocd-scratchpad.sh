
# CLI
brew install argocd
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
# username: admin and password the above


# debugging argocd with interactive session
kubectl run -n argo -i --tty --rm debug --image argoproj/argocd --restart=Never sh


