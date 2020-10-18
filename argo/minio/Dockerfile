FROM minio/mc

LABEL maintainer="Daniel Giribet - dani [at] calidos [dot] cat"

# local service name from the argo namespace
ARG MINIO_SERVICE_URL=http://minio:9000 

# default user and password of the argo workflows manifest, change to k8s for production
ENV ACCESS_KEY=admin
ENV SECRET_KEY=password

# add the minio service to the configuration
RUN mc alias set minio-local ${MINIO_SERVICE_URL} ${ACCESS_KEY} ${SECRET_KEY}

# add cleanup script
ADD cleanup.sh /
RUN ["chmod", "a+x", "/cleanup.sh"]

# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
ENTRYPOINT ["/cleanup.sh"]