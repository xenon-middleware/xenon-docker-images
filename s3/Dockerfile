# Use multistage build to get image with both mc and minio executables
FROM minio/mc as mcsrc

FROM minio/minio
COPY --from=mcsrc /usr/bin/mc /usr/bin/mc

LABEL maintainer=s.verhoeven@esciencecenter.nl

ENV MINIO_ACCESS_KEY xenon
ENV MINIO_SECRET_KEY javagat01

# Fill minio server with the test fixtures
# We use mc (minio client) to create files, because creating file on the filesytem caused
# minio to give errors (when accessing via rest), presumably because some minio
# meta-info was not present that is generate when using the s3 protocol.
RUN \
    mkdir /var/s3 && \
    chmod a+rx /var/s3 && \
    minio server /var/s3 & \
    sleep 1s && \
    mc config host add hier http://localhost:9000 xenon javagat01 && \
    mc mb hier/filesystem-test-fixture && \
    echo "Hello World" | mc pipe hier/filesystem-test-fixture/links/file0 && \
    echo "" | mc pipe hier/filesystem-test-fixture/links/file1 && \
    mc mb hier/filesystem-test-fixture2 && \
    echo "Hello World" | mc pipe hier/filesystem-test-fixture2/links/file0 && \
    echo "" | mc pipe hier/filesystem-test-fixture2/links/file1 && \
    mc policy public hier/filesystem-test-fixture2 && \
		sleep 1s && \
		killall minio

CMD ["server", "/var/s3"]

HEALTHCHECK --interval=1s CMD mc ls hier || exit 1
