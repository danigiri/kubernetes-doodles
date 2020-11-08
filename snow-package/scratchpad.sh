argocd app create snow-package-deployment \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path snow-package \
	--dest-namespace snow-package \
	--dest-server https://kubernetes.default.svc \
	--auto-prune \
	--sync-policy automated \
	--sync-option CreateNamespace=true


# configure morfeu to point at the snow package service
argocd app set morfeu -p image.args='{-D__RESOURCES_PREFIX=http://snow-package-service.snowpackage-site.svc.cluster.local:8990/,-D__PROXY_PREFIX=http://snow-package-service.snowpackage-site.svc.cluster.local:8990}'

