FROM alpine:3.20

ARG BUILD_NUMBER=local
LABEL org.ncc-training.example="jenkins-docker-build" \
      org.ncc-training.build-number="$BUILD_NUMBER"

RUN printf 'Jenkins Docker build example\nBuild: %s\n' "$BUILD_NUMBER" > /build-info.txt

CMD ["/bin/sh", "-c", "cat /build-info.txt"]
