FROM kudobuilder/kuttl:v0.13.0

ENV VERSION="v0.3.20"

RUN echo "Installing goss and kgoss version ${VERSION}" ; \
    curl -L "https://github.com/goss-org/goss/releases/download/${VERSION}/goss-linux-amd64" -o /usr/local/bin/goss && \
    chmod +rx /usr/local/bin/goss && \
    curl -L "https://raw.githubusercontent.com/goss-org/goss/${VERSION}/extras/kgoss/kgoss" -o /usr/local/bin/kgoss && \
    chmod +rx /usr/local/bin/kgoss && \
    /usr/local/bin/goss -v && \
    /usr/local/bin/kgoss -v

