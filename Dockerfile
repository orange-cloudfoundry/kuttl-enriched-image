FROM ubuntu:22.04

ENV KUTTL_VERSION="0.15.0"
ENV GOSS_VERSION="v0.3.23"
ENV YTT_VERSION="v0.45.3"
ENV YQ_VERSION="v4.34.1"

#    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.26.0/bin/linux/amd64/kubectl && \
#    chmod +x ./kubectl && \
#    mv ./kubectl /usr/local/bin/kubectl && \


#--- Clis versions
ENV JQ_VERSION="1.6" \
    KUBECTL_VERSION="1.24.9" \
    KUBECTX_VERSION="0.9.4" \
    MYSQL_SHELL_VERSION="8.0.33-1"

#--- Packages list, ruby env and plugins
ENV INIT_PACKAGES="apt-transport-https ca-certificates curl openssl sudo unzip" \
    TOOLS_PACKAGES="bash-completion colordiff git-core gnupg htop less locales vim" \
    OS_ARCH_1="x86_64" \
    OS_ARCH_2="amd64"

ADD tools/* /tmp/tools/
ADD tools/completion/* /tmp/tools/completion/

RUN installBinary() { printf "\n=> Add $1 CLI\n" ; curl -sSLo /usr/local/bin/$2 "$3" ; chmod 755 /usr/local/bin/$2 } && \
    installZip() { printf "\n=> Add $1 CLI\n" ; curl -sSL "$3" | gunzip > /usr/local/bin/$2 ; } && \
    installTar() { printf "\n=> Add $1 CLI\n" ; curl -sSL "$3" | tar -x -C /tmp && mv /tmp/$4 /usr/local/bin/$2 ; } && \
    installTargz() { printf "\n=> Add $1 CLI\n" ; curl -sSL "$3" | tar -xz -C /tmp && mv /tmp/$4 /usr/local/bin/$2 ; } && \
    addCompletion() { printf "\n=> Add $1 CLI completion\n" ; chmod 755 /usr/local/bin/$2 ; /usr/local/bin/$2 $3 > /etc/bash_completion.d/$2 | true ; } && \
    printf '\n=====================================================\n Install system packages\n=====================================================\n' && \
    apt-get update && apt-get install -y --no-install-recommends apt-utils dialog && \
    apt-get install -y --no-install-recommends ${INIT_PACKAGES} ${TOOLS_PACKAGES} && \
    locale-gen en_US.UTF-8 && \
    printf '\n=====================================================\n Install clis and tools\n=====================================================\n' && \
    printf '\n=> Add GCLOUD CLI\n' && echo "deb https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list && chmod 1777 /tmp && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && apt-get update && apt-get install -y --no-install-recommends google-cloud-cli && \
    installBinary "JQ" "jq" "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" && \
    installBinary "KUBECTL" "kubectl" "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${OS_ARCH_2}/kubectl" && \
    addCompletion "KUBECTL" "kubectl" "completion bash" && sed -i "s+__start_kubectl kubectl+__start_kubectl kubectl k+g" /etc/bash_completion.d/kubectl && \
    installTargz  "KUBECTX" "kubectx" "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_${OS_ARCH_1}.tar.gz" "kubectx" && \
    installTargz  "KUBENS" "kubens" "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v${KUBECTX_VERSION}_linux_${OS_ARCH_1}.tar.gz" "kubens" && \
    printf '\n=> Add MYSQL-SHELL CLI\n' && curl -sSLo /tmp/mysql-shell.deb "https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell_${MYSQL_SHELL_VERSION}ubuntu22.04_${OS_ARCH_2}.deb" && dpkg -i /tmp/mysql-shell.deb



# Pending merge of https://github.com/goss-org/goss/pull/792 and https://github.com/kudobuilder/kuttl/pull/448
RUN echo "Installing yq version ${YQ_VERSION}" ; \
    curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +rx /usr/local/bin/yq && \
    echo "Installing kuttl version ${KUTTL_VERSION}" ; \
    curl -L "https://github.com/kudobuilder/kuttl/releases/download/v${KUTTL_VERSION}/kubectl-kuttl_${KUTTL_VERSION}_linux_x86_64" -o /usr/local/bin/kubectl-kuttl && \
    chmod +rx /usr/local/bin/kubectl-kuttl && \
    echo "Installing ytt version ${YTT_VERSION}" ; \
    curl -L "https://github.com/vmware-tanzu/carvel-ytt/releases/download/${YTT_VERSION}/ytt-linux-amd64" -o /usr/local/bin/ytt && \
    chmod +rx /usr/local/bin/ytt && \
    echo "Installing goss and kgoss version ${GOSS_VERSION}" ; \
    curl -L "https://github.com/goss-org/goss/releases/download/${GOSS_VERSION}/goss-linux-amd64" -o /usr/local/bin/goss && \
    chmod +rx /usr/local/bin/goss && \
    /usr/local/bin/kubectl-kuttl --version && \
    /usr/local/bin/ytt --version && \
    /usr/local/bin/yq --version && \
    /usr/local/bin/jq --version && \
    /usr/local/bin/goss -v && \
    /usr/local/bin/kubectl version \
    || echo "Installation done."

