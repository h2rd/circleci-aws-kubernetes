FROM php:7.4-alpine

ENV CLOUDSDK_CORE_DISABLE_PROMPTS=true
ENV PATH=/google-cloud-sdk/bin:$PATH
ARG GCLOUD_SDK_VERSION="486.0.0"
ARG KUBERNETES_VERSION="v1.29.2"

# install packages
RUN apk --no-cache update \
        && apk --no-cache add \
                docker \
                git \
                openssh-client \
                tar \
                gzip \
                ca-certificates \
                python3 \
                py3-pip \
                curl \
                openssl \
                groff \
                less \
        && rm -rf /var/cache/apk/*

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# install kubectl
RUN curl -o /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl" \
        && chmod +x /usr/local/bin/kubectl

# install gcloud
RUN curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz" | tar xz \
        && gcloud config set core/disable_usage_reporting true \
        && gcloud config set component_manager/disable_update_check true \
        && gcloud components install gke-gcloud-auth-plugin