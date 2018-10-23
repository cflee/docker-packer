FROM moexmen/alpine:3.8

ENV PACKER_VERSION 1.2.5
ENV ANSIBLE_VERSION 2.6.6

RUN \
# Packer is a single statically-linked binary
    curl -OL https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /app \
    && rm -f packer_${PACKER_VERSION}_linux_amd64.zip \
# both libffi-dev and openssl-dev are required for the python cffi module (for paramiko)
# but we need to upgrade pip as pip 10 somehow will fail with an error:
#   Could not find a version that satisfies the requirement cffi >=1.4.1 (from version: )
#   No matching distribution found for cffi>=1.4.1
# even if we install cffi separately with `pip3 install cffi`.
    && apk add --no-cache --update python3 py3-pip \
    && apk add --no-cache --virtual .build-dependencies build-base python3-dev libffi-dev openssl-dev \
    && pip3 install --upgrade pip \
    && pip3 install ansible==${ANSIBLE_VERSION} \
    && apk del --no-cache .build-dependencies

ENTRYPOINT ["/app/packer"]
