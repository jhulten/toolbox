# Toolbox Devcontainer

A development container image with git, SSH, GPG, and locale support. Built on the [toolbox base image](../base), which uses Debian 13 (slim) as its foundation.

## Image Details

- **Registry**: `ghcr.io/jhulten/toolbox/devcontainer`
- **Base Image**: `ghcr.io/jhulten/toolbox/base`
- **User**: `toolsmith`
- **Working Directory**: `/home/toolsmith`

## Included Tools

- **git** - Version control
- **openssh-client** - SSH client for remote connections
- **gnupg** - GPG for signing commits and encryption
- **mise** - Polyglot tool version manager (inherited from base image)
- **Locale Support** - UTF-8 locale configured (`en_US.UTF-8`)

## Usage

### VS Code Dev Containers

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Copy the `devcontainer.json` file to your project's `.devcontainer/` directory:

   ```bash
   mkdir -p .devcontainer
   cp devcontainer.json .devcontainer/
   ```

3. Modify the `devcontainer.json` to reference the pre-built image instead of building locally (replace the `build` section with `image`):

   ```json
   {
     "name": "Toolbox Development Container",
     "image": "ghcr.io/jhulten/toolbox/devcontainer:latest",
     "remoteUser": "toolsmith",
     "containerUser": "toolsmith",
     "updateRemoteUserUID": true,
     "customizations": {
       "vscode": {
         "settings": {
           "terminal.integrated.defaultProfile.linux": "bash"
         },
         "extensions": []
       }
     }
   }
   ```

   Alternatively, keep the original `devcontainer.json` to build the image locally from the Dockerfile.

4. Open the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`) and select **Dev Containers: Reopen in Container**

### GitHub Codespaces

Create a `.devcontainer/devcontainer.json` file in your repository:

```json
{
  "name": "Toolbox Development Container",
  "image": "ghcr.io/jhulten/toolbox/devcontainer:latest",
  "remoteUser": "toolsmith",
  "containerUser": "toolsmith",
  "updateRemoteUserUID": true
}
```

Then open your repository in GitHub Codespaces.

### Docker CLI

Pull and run the image directly:

```bash
# Pull the latest image
docker pull ghcr.io/jhulten/toolbox/devcontainer:latest

# Run interactively
docker run -it --rm ghcr.io/jhulten/toolbox/devcontainer:latest bash

# Mount a local directory
docker run -it --rm -v "$(pwd):/workspace" -w /workspace ghcr.io/jhulten/toolbox/devcontainer:latest bash
```

## Image Tags

- `latest` - Built from the main branch
- `sha-<commit>` - Built from a specific commit

## Customization

### Adding VS Code Extensions

Add extensions to the `customizations.vscode.extensions` array in your `devcontainer.json`:

```json
{
  "customizations": {
    "vscode": {
      "extensions": [
        "GitHub.copilot",
        "eamodio.gitlens"
      ]
    }
  }
}
```

### Installing Additional Tools with mise

The base image includes [mise](https://mise.jdx.dev/) for managing tool versions. Add a `.mise.toml` file to your project:

```toml
[tools]
node = "22"
python = "3.12"
go = "1.23"
```

Then run `mise install` in your dev container to install the specified tools.

## License

MIT - See [LICENSE](../LICENSE) for details.
