# https://argoproj.github.io/argo/quick-start/
# bootstrap

kubectl create ns argo
# https://github.com/argoproj/argo-workflows/releases
export ARGO_WORKFLOWS_VERSION=v3.5.8
kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"

# this will have created all the necessary pods, this includes minio
#      accessKeySecret:
#        name: my-minio-cred
#        key: accesskey
#      secretKeySecret:
#        name: my-minio-cred
#        key: secretkey

# list workflows
argo list -n argo

# port forward, it shows UI https://192.168.1.30:2746/
kubectl -n argo port-forward service/argo-server --address 192.168.1.30 2746:2746


argocd app create argo \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path argo \
	--dest-namespace argo \
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	--sync-policy automated

# change controller with a patch
kubectl -n argo patch configmaps workflow-controller-configmap --patch "$(cat config/workflow-controller-configmap-patch.yaml)"


# create secret to access
kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
kubectl -n argo create secret generic argocd-secret --from-literal=admin.password="$PASSWORD"

# add build template
argo -v template create workflows/build-workflow-template.yaml