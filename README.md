kubernetes-morfeu
=================

Deploy Morfeu in Kubernetes, using argo and argocd, tested on microk8s. Heavily leveraging workflow templates in Argo

# Kubernetes configuration
To deploy on Kubernetes, using MicroK8s (https://microk8s.io/) on Ubuntu (v1.20.13), but it should work in any other
Kubernetes setup.

Make sure the basic add-ons like dns, storage, registry and ingress are enabled. For reference, this is the list of add-ons:

	`microk8s enable dashboard dns ha-cluster ingress metrics-server registry hostpath-storage`

# Installing argo and argocd

First install argocd following the installation instructions in `argocd/scratchpad.sh`

Secondly install Argo workflows following the scratchpad at `argo/scratchpad.sh`


# Main argo deployment workflow


## Main workflow
There are the following steps
  * load-source
  * checkout
  * buildld
  * redeploy

### Workflow configuration parameters


### load-source step

In this step, we use the artifact configuration to load the source folder from S3 (Minio) into a volume mount `/source`

The first time it will be empty and we create a `/source/{{workflow.parameters.appName}}-source` path inside, in
this way, we can support multiple application builds, though this can be changed if more separation of concerns is
needed.

The second time the workflow is executed, the source will already be there which we can re-use to just do a `git pull`
on and update the source as needed (see next step).

# Building Morfeu


Make sure you create the target namespace first, namely:
	`kubectl create namespace morfeu`

