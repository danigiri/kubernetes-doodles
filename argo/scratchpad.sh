# INSTALLATION
# https://argoproj.github.io/argo/quick-start/
# https://github.com/argoproj/argo-workflows/releases

kubectl create ns argo
export ARGO_WORKFLOWS_VERSION=v3.5.8
kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"


# port forward so we can access argo from outside the cluster (it also makes UI accessible) 
kubectl -n argo port-forward service/argo-server --address 192.168.1.30 2746:2746


argocd app create argo \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path argo \
	--dest-namespace argo \
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	--sync-policy automated

# create secret in 'argo' namespace to access argocd so we can deploy applications using argocd
# this is the initial password, it should be changed
 PASSWORD=$(argocd admin initial-password -n argocd|head -1)
kubectl -n argo create secret generic argocd-secret --from-literal=admin.password="$PASSWORD"

# add build template so it can be reused by workflows
argo -v template create workflows/build-workflow-template.yaml

# INSTALLATION ENDS HERE

# DIAGNOSTICS, CONSOLE AND OTHER TOOLING

# UI at https://192.168.1.30:2746/, just make sure you have done the port forwarding

# list workflows
argo list -n argo

# change controller with a patch
kubectl -n argo patch configmaps workflow-controller-configmap --patch "$(cat config/workflow-controller-configmap-patch.yaml)"

