

# kubectl -n container-registry  get pods| grep registry | awk '{print $1}'

# /bin/registry garbage-collect /etc/docker/registry/config.yml -m

kubectl -n container-registry exec $(kubectl -n container-registry  get pods| grep registry | awk '{print $1}') \
  -- /bin/registry garbage-collect /etc/docker/registry/config.yml -m