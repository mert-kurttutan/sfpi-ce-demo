ARG NODE_MAJOR_VERSION=22

FROM mcr.microsoft.com/devcontainers/javascript-node:${NODE_MAJOR_VERSION}

ENV DEBIAN_FRONTEND=noninteractive \
    EDITOR="code -w" \
    VISUAL="code -w" \
    CE_SOURCE_ROOT=/opt/compiler-explorer-src \
    CE_INFRA_ROOT=/opt/compiler-explorer-infra \
    CE_COMPILERS_ROOT=/opt/compiler-explorer \
    CE_PORT=10240

# System packages required by Compiler Explorer development/runtime and
# Cypress-related dependencies documented by the CE devcontainer.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    make \
    python3 \
    python3-pip \
    python3-venv \
    xauth \
    xvfb \
    libasound2 \
    libgbm-dev \
    libgtk-3-0 \
    libgtk2.0-0 \
    libnotify-dev \
    libnss3 \
    libxss1 \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/*

ARG CE_REPO=https://github.com/mert-kurttutan/compiler-explorer.git
ARG CE_REF=tenstorrent-support
ARG INFRA_REPO=https://github.com/mert-kurttutan/infra.git
ARG INFRA_REF=sfpi-support
ARG CE_INSTALL_ARGS=""

RUN git clone --depth 1 --branch "${CE_REF}" "${CE_REPO}" "${CE_SOURCE_ROOT}" \
    && git clone --depth 1 --branch "${INFRA_REF}" "${INFRA_REPO}" "${CE_INFRA_ROOT}" \
    && mkdir -p "${CE_COMPILERS_ROOT}"

WORKDIR ${CE_SOURCE_ROOT}
RUN npm ci

WORKDIR ${CE_INFRA_ROOT}
RUN make ce

# Optional compiler installation through the infra branch. The exact install
# selection can be passed at build time, for example:
#   --build-arg CE_INSTALL_ARGS="--enable nightly"
# or:
#   --build-arg CE_INSTALL_ARGS="sfpi"
RUN if [ -n "${CE_INSTALL_ARGS}" ]; then \
        ./bin/ce_install install compilers ${CE_INSTALL_ARGS}; \
    fi

RUN chown -R node:node "${CE_SOURCE_ROOT}" "${CE_INFRA_ROOT}" "${CE_COMPILERS_ROOT}"

USER node
WORKDIR ${CE_SOURCE_ROOT}

EXPOSE 10240

CMD ["make"]
