FROM registry.fedoraproject.org/fedora-minimal:39
LABEL maintainer="Red Hat"

WORKDIR /src
RUN microdnf -y install \
    --setopt install_weak_deps=0 \
    --nodocs \
    gcc \
    golang \
    git-core \
    nodejs \
    nodejs-npm \
    python3 \
    python3-devel \
    python3-pip \
    && microdnf clean all

COPY . .

RUN source /tmp/cachi2.env && \
    pip3 install -r requirements.txt --no-deps --no-cache-dir --require-hashes && \
    pip3 install --no-cache-dir . && \
    # the git folder is only needed to determine the package version
    rm -rf .git

WORKDIR /src/js-deps
RUN source /tmp/cachi2.env && \
    npm install && \
    ln -s "${PWD}/node_modules/.bin/corepack" /usr/local/bin/corepack && \
    corepack enable yarn && \
    microdnf -y remove nodejs-npm

ENTRYPOINT ["cachi2"]
