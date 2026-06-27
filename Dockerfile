FROM rust:1.85-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs npm curl ca-certificates git jq zip python3 \
    && rm -rf /var/lib/apt/lists/*

# OpenCode via npm
RUN npm install -g opencode-ai

# Forgejo runner binary
COPY --from=code.forgejo.org/forgejo/runner:6.2.2 /bin/forgejo-runner /usr/local/bin/forgejo-runner

# OpenCode config pointing to your Ollama instance
RUN mkdir -p /root/.config/opencode
COPY opencode-config/config.json /root/.config/opencode/config.json

WORKDIR /data

RUN node --version && npm --version && cargo --version && \
    opencode --version && forgejo-runner --version
