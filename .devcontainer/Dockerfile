FROM rust:slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g pnpm



RUN npm install -g @slidev/cli

RUN rustup update && cargo install mdbook mdbook-admonish mdbook-mermaid --locked

WORKDIR /workspaces/STIC

EXPOSE 3000 3001 3030