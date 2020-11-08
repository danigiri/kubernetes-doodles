# console for CD
kubectl create namespace morfeu
argocd app create morfeu \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path morfeu/helm \
	--dest-namespace morfeu \
	--dest-server https://kubernetes.default.svc

# syncing argocd app sync guestbook


# list actions
argocd app actions list morfeu-deploy --namespace morfeu --group apps --kind Deployment --insecure

# workflow for CI
# secret
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
kubectl -n argo create secret generic argocd-secret --from-literal=admin.password=
# workflow
argo -v cron create morfeu-workflow.yaml
