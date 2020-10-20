#!/bin/sh

mc alias set minio-local ${MINIO_SERVICE_URL} ${ACCESS_KEY} ${SECRET_KEY}
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
for i in $(mc ls minio-local/my-bucket/ | awk -e '{print $5}' | grep workflow); do
	mc rm --recursive --force minio-local/my-bucket/"$i"
done