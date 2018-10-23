FROM moexmen/alpine:3.8

ENV PACKER_VERSION 1.2.5
ENV ANSIBLE_VERSION 2.6.6

RUN \
# Packer is a single statically-linked binary
    curl -OL https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /app \
    && rm -f packer_${PACKER_VERSION}_linux_amd64.zip \
# both libffi-dev and openssl-dev are required at build/install time for the
# python cffi module (for paramiko), while openssl-dev is required at run time
# for the connections to AWS EC2 API.
    && apk add --no-cache --update python3 py3-pip openssl-dev \
    && apk add --no-cache --virtual .build-dependencies build-base python3-dev libffi-dev \
# we need to upgrade pip as pip 10 will fail and be unable to satisfy cffi >=1.4.1
# even if we install cffi separately with `pip3 install cffi`.
    && pip3 install --upgrade pip \
    && pip3 install ansible==${ANSIBLE_VERSION} \
    && apk del --no-cache .build-dependencies

ENTRYPOINT ["/app/packer"]
