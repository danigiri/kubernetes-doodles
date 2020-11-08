
kubectl create namespace snowpackage-site

argocd app create snowpackage-site \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path snowpackage-site \
	--dest-namespace snowpackage-site \
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	--sync-policy automated