FROM minio/mc

LABEL maintainer="Daniel Giribet - dani [at] calidos [dot] cat"

# add cleanup script
ADD cleanup.sh /
RUN ["chmod", "a+x", "/cleanup.sh"]

# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
ENTRYPOINT ["/cleanup.sh"]