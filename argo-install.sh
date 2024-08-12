# INSTALLATION
# https://argo-workflows.readthedocs.io/en/latest/
# https://github.com/argoproj/argo-workflows/releases

kubectl create ns argo
export ARGO_WORKFLOWS_VERSION=v3.5.8
kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"
sleep 10
# either
# kubectl apply -f argo/ingress/argo-ingress.yaml
# or
# port forward so we can access argo from outside the cluster 
# kubectl -n argo port-forward service/argo-server --address 192.168.1.30 2746:2746


# assuming env vars are set
# kubectl -n argocd get secret argocd-secret -o jsonpath='{.data.admin\.password}' | base64 --decode
kubectl -n argo create secret generic argocd-secret --from-literal=admin.password="$ARGOCD_PASSWORD"

# assuming logged in
# argocd login "$ARGOCD_HOST" --username admin --password "$ARGOCD_PASSWORD" --insecure
argocd app create argo \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path argo \
	--directory-recurse \
	--directory-include "{configmaps/*,ingress/*}" \
	--dest-namespace argo \
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	--sync-policy automated


# default s3 artifact repository (minio)
# kubectl apply -f argo/configmaps/artifact-repositories.yaml

# add build template so it can be reused by workflows
argo -v template create argo/workflows/build-workflow-template.yaml

# registry cleanup
argo -v cron create container-registry/workflows/container-registry-cleanup-workflow.yaml