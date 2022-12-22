FROM kudobuilder/kuttl:v0.14.0

ENV VERSION="v0.3.20"

#RUN echo "Installing goss and kgoss version ${VERSION}" ; \
#    curl -L "https://github.com/goss-org/goss/releases/download/${VERSION}/goss-linux-amd64" -o /usr/local/bin/goss && \
#    chmod +rx /usr/local/bin/goss && \
#    curl -L "https://raw.githubusercontent.com/goss-org/goss/${VERSION}/extras/kgoss/kgoss" -o /usr/local/bin/kgoss && \
#    chmod +rx /usr/local/bin/kgoss && \
#    /usr/local/bin/goss -v && \
#    /usr/local/bin/kgoss || echo "Installation done."

# Pending merge of https://github.com/goss-org/goss/pull/792 and https://github.com/kudobuilder/kuttl/pull/448
RUN echo "Installing goss and kgoss version ${VERSION}" ; \
    curl -L "https://github.com/goss-org/goss/releases/download/${VERSION}/goss-linux-amd64" -o /usr/local/bin/goss && \
    chmod +rx /usr/local/bin/goss && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.26.0/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -LO https://raw.githubusercontent.com/orange-cloudfoundry/goss/kgoss-kubectl-opts/extras/kgoss/kgoss -o /usr/local/bin/kgoss && \
    chmod +rx /usr/local/bin/kgoss && \
    /usr/local/bin/goss -v && \
    /usr/local/bin/kubectl version && \
    /usr/local/bin/kgoss || echo "Installation done."

