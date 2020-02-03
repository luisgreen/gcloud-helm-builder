FROM gcr.io/cloud-builders/gcloud

ARG HELM_VERSION=v2.14.3
ARG ssh_prv_key
ARG ssh_pub_key

ENV HELM_VERSION=$HELM_VERSION

COPY helm.bash /builder/helm.bash

RUN chmod +x /builder/helm.bash && \
  mkdir -p /builder/helm && \
  apt-get update && \
  apt-get install -y curl git && \
  curl -SL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz && \
  tar zxvf helm.tar.gz --strip-components=1 -C /builder/helm linux-amd64 && \
  rm helm.tar.gz && \
  apt-get --purge -y autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir -p ~/.helm/plugins

RUN mkdir -p /root/.ssh && \
  chmod 0700 /root/.ssh && \
  ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
  echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
  chmod 600 /root/.ssh/id_rsa && \
  chmod 600 /root/.ssh/id_rsa.pub

USER builder

ENV PATH=/builder/helm/:$PATH

RUN helm init --client-only && \
  helm plugin install https://github.com/aslafy-z/helm-git.git && \
  helm repo add gorilla git+ssh://git@github.com/luisgreen/gorilla-helm-charts@?ref=master

ENTRYPOINT ["/builder/helm.bash"]
