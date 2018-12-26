FROM alpine:3.8

ENV CLOUDSDK_CORE_DISABLE_PROMPTS true
ENV PATH /google-cloud-sdk/bin:$PATH
ENV GCLOUD_SDK_VERSION="228.0.0"
ENV KUBERNETES_VERSION="v1.8.4"

# install packages
RUN apk --no-cache update \
        && apk --no-cache add \
                docker \
                git \
                openssh-client \
                tar \
                gzip \
                ca-certificates \
                php5 \
                php5-json \
                php5-phar \
                php5-openssl \
                php5-zlib \
                php5-mcrypt \
                php5-bcmath \
                php5-curl \
                php5-sockets \
                py-pip \
                nodejs \
                nodejs-npm \
                curl \
                openssl \
                groff \
                less \
        && pip --no-cache-dir install awscli \
        && ln -s /usr/bin/php5 /usr/bin/php \
        && rm -rf /var/cache/apk/*

# install composer
RUN curl -sS https://getcomposer.org/installer | php5 -- --install-dir=/usr/bin --filename=composer

# install kubectl
RUN curl -o /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl" \
        && chmod +x /usr/local/bin/kubectl

# install gcloud
RUN curl "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz" | tar xz \
        && gcloud config set core/disable_usage_reporting true \
        && gcloud config set component_manager/disable_update_check true