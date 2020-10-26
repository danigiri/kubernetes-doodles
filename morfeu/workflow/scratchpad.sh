# console for CD
kubectl port-forward svc/argocd-server -n argocd --address 192.168.1.30 8080:443
argocd app create morfeu-deployment \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path morfeu \
	--dest-namespace morfeu 
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	-sync-policy automated \
	--sync-option CreateNamespace=true

# list actions
argocd app actions list morfeu-deploy --namespace morfeu --group apps --kind Deployment --insecure

# workflow for CI
# secret
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
kubectl -n argo create secret generic argocd-secret --from-literal=admin.password=
# workflow
argo -v cron create morfeu-workflow.yaml
