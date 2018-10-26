# FROM golang:1.8-alpine
FROM golang:1.11.1-alpine3.8 AS BUILD

WORKDIR /go/src/app

# We use mc (minio client) to create files, because creating file on the filesytem caused
# minio to give errors (when accessing via rest), presumably because some minio
# meta-info was not present that is generate when using the s3 protocol.

RUN \
    apk add --no-cache git musl-dev ca-certificates && \
		go get -v github.com/minio/mc && \
    go get -v github.com/minio/minio

FROM alpine:3.8
LABEL maintainer="Stefan Verhoeven s.verhoeven@esciencecenter.nl>"

ENV MINIO_ACCESS_KEY xenon
ENV MINIO_SECRET_KEY javagat01

COPY --from=build /go/bin/mc /usr/bin/mc
COPY --from=build /go/bin/minio /usr/bin/minio

RUN \
    # Data dir
    mkdir /var/s3 && \
		chmod a+rx /var/s3 && \
    # Enable mdns4
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    # Populate server
    minio server /var/s3 & \
    sleep 1s && \
    mc config host add hier "http://localhost:9000" xenon javagat01 && \
    mc mb hier/filesystem-test-fixture && \
    echo "Hello World" | mc pipe hier/filesystem-test-fixture/links/file0 && \
    echo "" | mc pipe hier/filesystem-test-fixture/links/file1 && \
    mc mb hier/filesystem-test-fixture2 && \
    echo "Hello World" | mc pipe hier/filesystem-test-fixture2/links/file0 && \
    echo "" | mc pipe hier/filesystem-test-fixture2/links/file1 && \
    mc policy public hier/filesystem-test-fixture2 && \
		sleep 1s && \
		killall minio

EXPOSE 9000

CMD ["minio", "server", "/var/s3"]

HEALTHCHECK --interval=1s CMD mc ls hier || exit 1
