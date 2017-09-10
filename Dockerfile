FROM alpine:latest

ENV GCLOUD_SDK_VERSION="170.0.1"
ENV KUBERNETES_VERSION="v1.7.4"

# install awscli, nodejs
RUN apk --no-cache update && \
    apk --no-cache add py-pip nodejs ca-certificates curl curl-dev openssl groff less && \
    pip --no-cache-dir install awscli && \
    rm -rf /var/cache/apk/*

# install kubectl
RUN curl -o /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl

# install gcloud
RUN curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz" | tar -xz -C /usr/local && \
        /usr/local/google-cloud-sdk/install.sh -q

ENV PATH /usr/local/google-cloud-sdk/bin/:$PATH
