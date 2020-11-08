# create namespace and PVC
kubectl create namespace snowpackage-site
kubectl apply -f storage/snowpackage-site-pvc.yaml

argocd app create snowpackage-site \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path snowpackage-site \
	--dest-namespace snowpackage-site \
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	--sync-policy automated