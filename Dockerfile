FROM alpine as build
ARG HELM_VERSION
ARG KUBERNETES_VERSION
ENV HELM_VERSION ${HELM_VERSION:-2.14.3}
ENV KUBERNETES_VERSION ${KUBERNETES_VERSION:-1.13.7}
RUN apk add -U openssl curl tar gzip bash ca-certificates git && \
        curl -sSL -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
        curl -sSL -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk && \
        apk add glibc-2.28-r0.apk && \
        rm glibc-2.28-r0.apk && \
        \
        curl -sS "https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar zx && \
        mv linux-amd64/helm /usr/bin/ && \
        mv linux-amd64/tiller /usr/bin/ && \
        helm version --client  && \
        tiller -version && \
        \
        curl -sSL -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl" && \
        chmod +x /usr/bin/kubectl && \
        kubectl version --client
