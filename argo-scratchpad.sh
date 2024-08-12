
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
