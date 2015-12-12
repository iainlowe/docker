# Run Hashicorp's vault from a container
#
# docker run -ti --rm --net=host -v ~/:/vault -e VAULT_ADDR=$VAULT_ADDR ilowe/vault $@

FROM alpine:edge

ENV VAULT_VER 0.4.0

ADD https://releases.hashicorp.com/vault/${VAULT_VER}/vault_${VAULT_VER}_linux_amd64.zip /

RUN unzip /vault* && mv vault /usr/bin && mkdir /vault

ENV HOME /vault

ENTRYPOINT ["vault"]