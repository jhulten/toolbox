# AGENTS.md - Agent Guidelines for Toolbox Repository

This document provides guidelines for agentic coding agents operating in this repository.

## Project Overview

This repository contains various special purpose toolboxes as container images. It consists of:
- `base/` - Base Docker image with common dependencies (Debian-based, zsh, mise)
- `devcontainer/` - Development container extending the base image with git, SSH, GPG, and locale support
- `.github/workflows/` - CI/CD workflows for building and testing images

## Build Commands

### Building Docker Images

```bash
# Build the base image
docker build -t ghcr.io/jhulten/toolbox/base:local base/

# Build the devcontainer image (requires base to be built first)
docker build -t ghcr.io/jhulten/toolbox/devcontainer:local --build-arg BASE_IMAGE_TAG=local devcontainer/

# Build with specific tag
docker build -t ghcr.io/jhulten/toolbox/base:latest base/
docker build -t ghcr.io/jhulten/toolbox/devcontainer:latest --build-arg BASE_IMAGE_TAG=latest devcontainer/
```

### Running Images

```bash
# Run base image interactively
docker run -it ghcr.io/jhulten/toolbox/base:local

# Run devcontainer image
docker run -it ghcr.io/jhulten/toolbox/devcontainer:local
```

### CI/CD Workflows

Workflows are in `.github/workflows/`:
- `build-base-image.yml` - Builds and pushes base image on push to main or PRs
- `build-devcontainer-image.yml` - Builds and pushes devcontainer image
- `check-apt-updates.yml` - Checks for APT package updates (runs weekly or manually)

```bash
# Trigger workflows via GitHub CLI
gh workflow run build-base-image.yml
gh workflow run build-devcontainer-image.yml
gh workflow run check-apt-updates.yml
```

### No Traditional Tests

This is a Docker-focused project with no unit tests. The primary "test" is building images successfully.

## Code Style Guidelines

### Dockerfiles

Follow these conventions for all Dockerfiles in this repository:

1. **Base Images**
   - Use slim base images when possible (e.g., `debian:13-slim`)
   - Always pin base image tags explicitly (avoid `latest` in FROM statements for reproducibility)

2. **Package Management**
   - Pin package versions explicitly for reproducibility (format: `package=version`)
   - Use `--no-install-recommends` with `apt-get install` to minimize image size
   - Clean up apt caches after installation: `apt-get clean -y && rm -rf /var/lib/apt/lists/*`
   - Prefer HTTPS over HTTP for package sources and downloads
   - Group related RUN commands to reduce image layers
   - Set `ENV DEBIAN_FRONTEND=noninteractive` for automated builds

3. **Security**
   - Always verify GPG keys for external package repositories
   - Use signed packages where available
   - Keep base images and dependencies up to date

4. **Syntax**
   - Use uppercase for Dockerfile instructions (e.g., `FROM`, `RUN`, `COPY`, `ADD`)
   - Use `ADD --chmod=755 --chown=root:root` for executable scripts
   - Add comments for complex or non-obvious configurations

5. **Structure**
   - Keep files clean and well-organized
   - Order instructions: FROM, ENV, RUN (installs), RUN (configuration), ADD, USER, WORKDIR
   - Use multi-line RUN commands with `&& \` for better layer caching

### Example Dockerfile Pattern

```dockerfile
FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
  apt-get install --no-install-recommends -y \
  package1=version1 \
  package2=version2 &&\
  apt-get clean -y &&\
  rm -rf /var/lib/apt/lists/*

RUN some-configuration-command

ADD --chmod=755 --chown=root:root scripts/* /usr/local/bin/

USER username
WORKDIR /home/username
```

### Shell Scripts

- Use `set -e` for error handling in shell scripts
- Use `#!/bin/zsh` or `#!/bin/bash` shebang appropriately
- Quote variables: `"$VAR"` not `$VAR`
- Use `--` to separate options from arguments

### GitHub Actions Workflows

- Use pinned action versions (e.g., `actions/checkout@v4`, not `@v4.2.2`)
- Follow the pattern in existing workflows for triggers and permissions
- Use Docker buildx with GitHub Actions cache for efficient builds

## Error Handling

- In shell scripts: use `set -euo pipefail` for strict error handling
- In Dockerfile RUN commands: chain with `&&` so failures stop the build
- In workflows: check exit codes explicitly when needed

## Naming Conventions

- Dockerfiles: `Dockerfile` (no extension)
- Directories: lowercase with hyphens (e.g., `base/`, `devcontainer/`)
- Scripts: lowercase with hyphens (e.g., `install-packages.sh`)
- Workflows: descriptive names with hyphens (e.g., `build-base-image.yml`)

## Existing Copilot Instructions

The repository has `.github/copilot-instructions.md` with Copilot-specific guidance. Key points:
- Use slim base images
- Pin package versions explicitly
- Use `--no-install-recommends` with apt-get
- Clean up apt caches
- Prefer HTTPS for package sources
- Group related RUN commands
- Set `DEBIAN_FRONTEND=noninteractive`
- Verify GPG keys for external repositories
- Use signed packages
- Keep base images and dependencies up to date
- Use uppercase for Dockerfile instructions
- Add comments for complex configurations

## Key Files

- `base/Dockerfile` - Base image definition
- `base/scripts/mise` - mise installation script
- `base/mise.toml` - mise configuration (currently empty)
- `devcontainer/Dockerfile` - Devcontainer image extending base
- `.github/workflows/build-base-image.yml` - Base image CI
- `.github/workflows/build-devcontainer-image.yml` - Devcontainer CI
- `.github/workflows/check-apt-updates.yml` - Package update checker

## Common Tasks

### Adding a new package to base image
1. Edit `base/Dockerfile`
2. Add package with pinned version: `packagename=version`
3. Test: `docker build -t ghcr.io/jhulten/toolbox/base:test base/`
4. Verify: `docker run --rm ghcr.io/jhulten/toolbox/base:test which packagename`

### Adding a new package to devcontainer
1. Edit `devcontainer/Dockerfile`
2. Add package with pinned version (check against base image's available packages)
3. Test: `docker build -t ghcr.io/jhulten/toolbox/devcontainer:test --build-arg BASE_IMAGE_TAG=local devcontainer/`

### Running the APT update checker locally
```bash
docker build -t ghcr.io/jhulten/toolbox/base:local base/
# Then run the check script from .github/workflows/check-apt-updates.yml manually
```
