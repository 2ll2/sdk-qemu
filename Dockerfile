FROM 2ll2/repo-sdk:v3.7-6ad8ce5-x86_64 AS repo-sdk

FROM alpine:3.7 AS alpine

COPY --from=repo-sdk /home/builder/repo/sdk/ /tmp/docker-build/repo-sdk/

COPY [ \
  "./docker-extras/*", \
  "/tmp/docker-build/" \
]

RUN \
  # apk
  cp /tmp/docker-build/etc-apk-keys-Builder-59ffc9b9.rsa.pub /etc/apk/keys/Builder-59ffc9b9.rsa.pub && \
  echo "@repo-sdk /tmp/docker-build/repo-sdk/v3.7/main" >> /etc/apk/repositories && \
  apk update && \
  apk add \
    qemu-system-aarch64@repo-sdk \
    qemu-system-x86_64@repo-sdk \
    qemu@repo-sdk && \
  \
  # remove @repo-sdk from apk
  sed -i -e 's/@repo-sdk//' /etc/apk/world && \
  sed -i -e '/@repo-sdk/d' /etc/apk/repositories && \
  \
  # cleanup
  rm -f /etc/apk/keys/Builder-59ffc9b9.rsa.pub && \
  rm -rf /tmp/* && \
  rm -f /var/cache/apk/*
