# INSTALLATION
# https://argo-workflows.readthedocs.io/en/latest/
# https://github.com/argoproj/argo-workflows/releases

#install argocd first then proceed with the instructions below

kubectl create ns argo
export ARGO_WORKFLOWS_VERSION=v3.5.8
kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"

# either
kubectl apply -f argo/ingress/argo-ingress.yaml
# or
# port forward so we can access argo from outside the cluster 
# kubectl -n argo port-forward service/argo-server --address 192.168.1.30 2746:2746

# install argocd now

# this is the initial password, it should be changed
 PASSWORD=$(argocd admin initial-password -n argocd|head -1)
# create secret in 'argo' namespace to access argocd so we can deploy applications using argocd
kubectl -n argo create secret generic argocd-secret --from-literal=admin.password="$PASSWORD"

sleep 1

argocd login argocd-grpc.h0local.test --username admin --password $PASSWORD --insecure
argocd app create argo \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path argo \
	--dest-namespace argo \
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	--sync-policy automated


# default s3 artifact repository (minio)
kubectl apply -f argo/configmaps/artifact-repositories.yaml

# add build template so it can be reused by workflows
argo -v template create argo/workflows/build-workflow-template.yaml

# cleanup
argo -v cron create argo/workflows/minio-cleanup-workflow.yaml

# INSTALLATION ENDS HERE

# DIAGNOSTICS, CONSOLE AND OTHER TOOLING

# UI at https://192.168.1.30:2746/ or https://argo.local.test depending on the option chosen


# list workflows
argo list -n argo

# change controller with a patch
kubectl -n argo patch configmaps workflow-controller-configmap --patch "$(cat config/workflow-controller-configmap-patch.yaml)"


# minio access (http://minio.local.test:9001/login)
kubectl apply -f argo/ingress/minio-ingress.yaml
# or
kubectl port-forward --address 192.168.1.30  service/minio 9000 9001 -n argo


# run minio shell
kubectl run -n argo -i --tty --rm debug --image minio/mc --restart=Never --command /bin/sh
mc alias set minio http://minio:9000 admin password
# list buckets
mc ls minio
mc mb  minio maven-repository
# run directly
kubectl run -n argo -i --rm debug --image minio/mc --restart=Never \
  --command -- /bin/sh -c '/bin/mc alias set minio http://minio:9000 admin password && /bin/mc ls minio'
