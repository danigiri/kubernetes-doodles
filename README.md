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
First install argocd following the installation instructions in `argocd/scratchpad.sh`
Secondly install argo workflows following the scratchpad at `argo/scratchpad.sh`
Next, create the target namespace, for instance:
	`kubectl create namespace morfeu`


## Main workflow
There are the following steps
  * load-source
  * checkout
  * build
  * redeploy

### load-source step

