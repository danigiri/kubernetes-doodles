# INSTALLATION
# https://reposilite.com/guide/kubernetes#installing-with-custom-values

kubectl create namespace reposilite

helm repo add reposilite https://helm.reposilite.com/
helm repo update


# this creates a bucket (note the default user and password in minio)
kubectl run -n argo -i --rm debug --image minio/mc --restart=Never \
--command -- /bin/sh -c '/bin/mc alias set minio http://minio:9000 admin password && /bin/mc mb minio/maven-repo'

kubectl apply -f reposilite/ingress/reposilite-ingress.yaml

# for some reason the ingress here does not apply
helm install reposilite reposilite/reposilite -n reposilite -f reposilite/helm/values.yaml
# give time to the service to start
sleep 10

kubectl run --quiet -n reposilite -i --rm getconfig --image alpine/httpie --restart=Never --command -- /usr/local/bin/http --auth root:root-secret --auth-type basic --ignore-stdin GET http://reposilite.reposilite:8080/api/settings/domain/maven | \
jq '.repositories[.repositories |length] |= . + {
      "id": "maven-central",
      "visibility": "PUBLIC",
      "redeployment": false,
      "preserveSnapshots": false,
      "storageProvider": {
        "type": "s3",
        "bucketName": "maven-repo",
        "endpoint": "http://minio.argo:9000",
        "accessKey": "admin",
        "secretKey": "password",
        "region": "us-east-1"
      },
      "storagePolicy": "PRIORITIZE_UPSTREAM_METADATA",
      "metadataMaxAge": 0,
      "proxied": [
        {
          "reference": "https://repo.maven.apache.org/maven2/",
          "store": true,
          "allowedGroups": [],
          "allowedExtensions": [
            ".jar",
            ".war",
            ".pom",
            ".xml",
            ".module",
            ".md5",
            ".sha1",
            ".sha256",
            ".sha512",
            ".asc",
            ".zip"
          ],
          "connectTimeout": 3,
          "readTimeout": 15,
          "httpProxy": ""
        }
      ]
    }' \
| kubectl run --quiet -n reposilite -i --rm putconfig --image alpine/httpie --restart=Never --command -- /usr/local/bin/http --auth root:root-secret --auth-type basic PUT http://reposilite.reposilite:8080/api/settings/domain/maven
