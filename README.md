# kubernetes-doodles
Various Kubernetes playground files

# microk8s notes
Make sure the basic add-ons like dns, storage, registry and ingress are enabled

	`microk8s enable dns`
	`microk8s enable ingress`
	`microk8s enable storage`
	`microk8s enable registry`

# Building Morfeu

## Install main components
First install argo workflows following the scratchpad at `argo/scratchpad.sh`
Next install argocd following the scratchpad at `argocd/scratchpad.sh`


## Main workflow
There are the following steps
  * load-source
  * checkout
  * buiold
  * redeploy

### load-source step

