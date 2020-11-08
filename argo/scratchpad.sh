# https://argoproj.github.io/argo/quick-start/
# bootstrap

kubectl create ns argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/stable/manifests/quick-start-postgres.yaml


argocd app create argo \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path argo \
	--dest-namespace argo \
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	--sync-policy automated