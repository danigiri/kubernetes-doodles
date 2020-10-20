FROM minio/mc

LABEL maintainer="Daniel Giribet - dani [at] calidos [dot] cat"

# local service name from the argo namespace
ARG MINIO_SERVICE_URL=http://minio:9000 
ENV MINIO_SERVICE_URL ${MINIO_SERVICE_URL}

# add cleanup script
ADD cleanup.sh /
RUN ["chmod", "a+x", "/cleanup.sh"]

# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
CMD ["/cleanup.sh", ${MINIO_SERVICE_URL}]