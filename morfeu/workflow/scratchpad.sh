# console for CD
kubectl port-forward svc/argocd-server -n argocd --address 192.168.1.30 8080:443


# workflow for CI
# secret
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
kubectl -n argo create secret generic argocd-secret --from-literal=admin.password=
# workflow
argo -v cron create morfeu-workflow.yaml
