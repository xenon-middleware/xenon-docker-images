FROM minio/minio:latest
MAINTAINER Atze van der Ploeg (a.vanderploeg@esciencecenter.nl)
ENV MINIO_ACCESS_KEY xenon
ENV MINIO_SECRET_KEY javagat01

RUN apk add --no-cache curl

# Xenon's filesystem integration tests expect certain directory structure, create it here:
# make directory that user xenon can write in
RUN mkdir /var/s3 && \
cd /var/s3 && \
mkdir -p filesystem-test-fixture/links && \
echo "Hello World" > filesystem-test-fixture/links/file0 && \
touch filesystem-test-fixture/links/file1 && \
ln -s /var/s3/filesystem-test-fixture/links/file0 /var/s3/filesystem-test-fixture/links/link0 && \
ln -s /var/s3/filesystem-test-fixture/links/file1 /var/s3/filesystem-test-fixture/links/link1 && \
ln -s /var/s3/filesystem-test-fixture/links/file2 /var/s3/filesystem-test-fixture/links/link2 

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["server","/var/s3"]


HEALTHCHECK --interval=1s CMD curl -f http://localhost:9000/minio/login || exit 1
