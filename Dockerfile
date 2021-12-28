## -*- dockerfile-image-name: "cdktf-python" -*-

FROM node:gallium-alpine

RUN apk update && apk add -U --no-cache terraform --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN npm install -g --upgrade typescript
RUN npm install -g --upgrade cdktf-cli

RUN apk add -U --no-cache gcc build-base linux-headers ca-certificates libffi-dev libressl-dev libxslt-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main
RUN apk add python3 python3-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main && \
    python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# now preinstall providers
RUN mkdir -p "/usr/local/lib/terraform"

ENV TF_PLUGIN_CACHE_DIR "/usr/local/lib/terraform"
WORKDIR /temp/provider_download
COPY main.tf .
RUN terraform init
# done installing providers

WORKDIR /cdktf
ENV HOME /cdktf

# future init calls will ONLY look at locally present providers
ENV TF_PLUGIN_CACHE_DIR ""
COPY .terraformrc $HOME/.terraformrc

WORKDIR /cdktf
CMD ["cdktf"]
