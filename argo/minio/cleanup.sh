#!/bin/bash

# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
# WARNING this nukes the content of all the bucket WARNING
for i in $(mc ls minio-local/my-bucket/ | awk -e '{print $5}'); do
	mc rm --recursive --force minio-local/my-bucket/$i
done