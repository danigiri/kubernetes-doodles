argocd app create snow-package-deployment \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path snow-package \
	--dest-namespace snow-packlage 
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	-sync-policy automated \
	--sync-option CreateNamespace=true
