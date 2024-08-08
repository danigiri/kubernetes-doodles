# create the namespace morefeu, indicate that the path for the application is the morfeu/helm folder
kubectl create namespace morfeu
argocd app create morfeu \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path morfeu/helm \
	--dest-namespace morfeu \
	--dest-server https://kubernetes.default.svc

# default s3 artifact repository (minio)
kubectl apply -f argo/configmaps/artifact-repositories.yaml

# we need to make sure argo can access argocd
# password (not add to history with the space in the beginning)
 PASSWORD=$(argocd admin initial-password -n argocd|head -1)
# use `argocd account update-password` to change
kubectl -n argo create secret generic argocd-secret --from-literal=admin.password=$PASSWORD

# workflows
argo -v cron create morfeu/workflow/morfeu-workflow.yaml

# and sync
argocd app sync morfeu


# list actions
argocd app actions list morfeu-deploy --namespace morfeu --group apps --kind Deployment --insecure
