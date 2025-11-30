# Copilot Instructions for Toolbox Repository

This repository contains various special purpose toolboxes as container images.

## Repository Structure

- `base/` - Base Docker image with common dependencies
- Each toolbox directory contains its own `Dockerfile` and configuration files

## Guidelines for Contributing

### Dockerfiles

- Use slim base images when possible (e.g., `debian:13-slim`)
- Pin package versions explicitly for reproducibility
- Use `--no-install-recommends` with `apt-get install` to minimize image size
- Clean up apt caches after installation (`apt-get clean -y && rm -rf /var/lib/apt/lists/*`)
- Prefer HTTPS over HTTP for package sources and downloads
- Group related RUN commands to reduce image layers
- Set `ENV DEBIAN_FRONTEND=noninteractive` for automated builds

### Security

- Always verify GPG keys for external package repositories
- Use signed packages where available
- Keep base images and dependencies up to date

### Code Style

- Use uppercase for Dockerfile instructions (e.g., `FROM`, `RUN`, `COPY`)
- Add comments for complex or non-obvious configurations
- Keep files clean and well-organized
