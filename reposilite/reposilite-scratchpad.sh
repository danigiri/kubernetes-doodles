
kubectl create namespace reposilite


apk -q add git curl helm
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
ARGOCD_HOST=argocd-server.argocd.svc.cluster.local:443
ARGOCD_PASSWORD=
argocd login "$ARGOCD_HOST" --username admin --password "$ARGOCD_PASSWORD" --insecure --plaintext

argocd app create reposilite \
  --repo https://github.com/danigiri/kubernetes-doodles.git \
  --path reposilite \
  --directory-recurse \
  --directory-exclude '{workflows/*,helm/*}' \
  --dest-namespace reposilite \
  --dest-server https://kubernetes.default.svc


git clone -q https://github.com/danigiri/kubernetes-doodles.git
cd kubernetes-doodles/
git checkout -q master

helm repo add reposilite https://helm.reposilite.com/
helm repo update
helm install reposilite reposilite/reposilite -n reposilite -f reposilite/helm/values.yaml


# see tag of removing PVC to recover the PVC definition