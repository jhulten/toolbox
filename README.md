# toolbox
Various special purpose toolboxes as container images

## Available Toolboxes

### Base
Base toolbox image with common dependencies (curl, zsh, mise).

### Devcontainer
Development container image with git, SSH, GPG, and locale support.

### Chezmoi
Container image with chezmoi for dotfiles management. Supports optional initialization with a dotfiles repository.

#### Usage

Build without initializing a dotfiles repo:
```bash
docker build -t my-chezmoi ./chezmoi
```

Build and initialize with a dotfiles repo:
```bash
docker build --build-arg CHEZMOI_REPO=https://github.com/username/dotfiles.git -t my-chezmoi ./chezmoi
```

Run the container:
```bash
docker run -it my-chezmoi zsh
```

