argocd app create snow-package \
	--repo https://github.com/danigiri/kubernetes-doodles.git \
	--path snow-package \
	--dest-namespace snowpackage-site \
	--dest-server https://kubernetes.default.svc


# configure morfeu to point at the snow package service
argocd app set morfeu -p image.args='{-D__RESOURCES_PREFIX=http://snow-package-service.snowpackage-site.svc.cluster.local:8990/,-D__PROXY_PREFIX=http://snow-package-service.snowpackage-site.svc.cluster.local:8990}'

# setup the workflow to build and deploy snow package
argo -v cron create workflow/snow-package-workflow.yaml

# sync the app
argocd app sync snow-package