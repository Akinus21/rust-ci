FROM rust:1.85-slim

# Install all dependencies needed for GTK4/Webkit browser projects (Iron)
# plus the standard CI toolchain
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs npm curl ca-certificates git jq zip python3 \
    # GTK4 and Webkit6 dependencies
    cmake ninja-build \
    libgtk-4-dev \
    libadwaita-1-dev \
    libwebkitgtk-6.0-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libgdk-pixbuf-2.0-dev \
    libsoup-3.0-dev \
    libjavascriptcoregtk-6.0-dev \
    libgbm-dev \
    libwayland-dev \
    libxkbcommon-dev \
    libssl-dev \
    libayatana-appindicator3-dev \
    libayatana-indicator3-dev \
    # Cross-compilation toolchains (for bottles job)
    gcc-aarch64-linux-gnu \
    libc6-dev-arm64-cross \
    && rm -rf /var/lib/apt/lists/*

# OpenCode via npm
RUN npm install -g opencode-ai

# Install opencode-workspace plugin
# The plugin is installed as a local package via git clone
RUN git clone https://github.com/kdcokenny/opencode-workspace.git /tmp/opencode-workspace \
    && npm install -g /tmp/opencode-workspace \
    && rm -rf /tmp/opencode-workspace

# Forgejo runner binary
COPY --from=code.forgejo.org/forgejo/runner:6.2.2 /bin/forgejo-runner /usr/local/bin/forgejo-runner

# OpenCode config pointing to your Ollama instance
RUN mkdir -p /root/.config/opencode
COPY opencode-config/opencode.json /root/.config/opencode/opencode.json

WORKDIR /data

RUN node --version && npm --version && cargo --version && \
    opencode --version && forgejo-runner --version
