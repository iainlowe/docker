# Run Hashicorp's vault from a container
#
# docker run -ti --rm \
#		--net=host \
# 		-v ~/:/vault \
#       -e VAULT_ADDR=$VAULT_ADDR \
#       --memory-swap=-1 \
#       ilowe/vault $@

FROM ilowe/base

ENV VAULT_VER 0.4.0
ENV GOPATH /go

RUN apt-get install -yq ca-certificates unzip locales curl \
	&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ADD https://releases.hashicorp.com/vault/${VAULT_VER}/vault_${VAULT_VER}_linux_amd64.zip /

RUN unzip /vault* && mv vault /usr/bin && mkdir /vault

ENV HOME /vault

ADD helium.crt /usr/local/share/ca-certificates/helium.crt

RUN update-ca-certificates

ENTRYPOINT ["vault"]