FROM kudobuilder/kuttl:v0.15.0

ENV GOSS_VERSION="v0.3.21"
ENV YTT_VERSION="v0.44.3"

#    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.26.0/bin/linux/amd64/kubectl && \
#    chmod +x ./kubectl && \
#    mv ./kubectl /usr/local/bin/kubectl && \


# Pending merge of https://github.com/goss-org/goss/pull/792 and https://github.com/kudobuilder/kuttl/pull/448
RUN echo "Installing carvel ytt version ${YTT_VERSION}" ; \
    curl -L "https://github.com/vmware-tanzu/carvel-ytt/releases/download/${YTT_VERSION}/ytt-linux-amd64" -o /usr/local/bin/ytt && \
    chmod +rx /usr/local/bin/ytt && \
    echo "Installing goss and kgoss version ${GOSS_VERSION}" ; \
    curl -L "https://github.com/goss-org/goss/releases/download/${GOSS_VERSION}/goss-linux-amd64" -o /usr/local/bin/goss && \
    chmod +rx /usr/local/bin/goss && \
    curl -L https://raw.githubusercontent.com/orange-cloudfoundry/goss/kgoss-kubectl-opts/extras/kgoss/kgoss -o /usr/local/bin/kgoss && \
    chmod +rx /usr/local/bin/kgoss && \
    /usr/local/bin/ytt --version && \
    /usr/local/bin/goss -v && \
    /usr/local/bin/kubectl version && \
    /usr/local/bin/kgoss || echo "Installation done."

