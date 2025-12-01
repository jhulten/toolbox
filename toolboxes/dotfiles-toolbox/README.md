# Dotfiles toolbox image

This toolbox image clones and keeps your dotfiles repo up-to-date at container startup, then runs any setup scripts found in the repo and drops you into an interactive shell as an unprivileged user.

Key points:
- Uses a non-root user `toolsmith` to own dotfiles and run the shell.
- Default dotfiles repo: `https://github.com/jhulten/dotfiles.git` (you can override at build/run time).
- Supports typical bootstrap file names: `install.sh`, `bootstrap.sh`, `setup.sh`, `Makefile` `install` target, or `fresh install` if `fresh` is available in the image.
- On subsequent container runs, the repo will be `git fetch`ed and `git pull --ff-only` will be attempted to update the checkout.

How to build
------------
From the directory containing the Dockerfile and entrypoint.sh:
```
docker build -t toolbox-dotfiles .
```
You can override the default repo/branch during build:
```
docker build --build-arg DOTFILES_REPO=https://github.com/youruser/dotfiles.git \
             --build-arg DOTFILES_BRANCH=main \
             -t toolbox-dotfiles .
```

How to run
----------
For a public repo:
```
docker run --rm -it \
  -v ~/.gitconfig:/home/toolsmith/.gitconfig:ro \
  toolbox-dotfiles
```

For a private repo (recommended approach):
- Use an SSH key with read-only access and mount it at runtime. Example (use with care):
```
docker run --rm -it \
  -v ~/.ssh/id_rsa:/home/toolsmith/.ssh/id_rsa:ro \
  -e GIT_SSH_COMMAND="ssh -i /home/toolsmith/.ssh/id_rsa -o IdentitiesOnly=yes" \
  toolbox-dotfiles
```
Alternative: use a deploy key or a GitHub access token in the DOTFILES_REPO URL (`https://token@github.com/owner/repo.git`) but be careful with secrets.

Development notes / suggestions
-------------------------------
- If your dotfiles use `freshshell` specifically, place a top-level `install.sh` that runs `fresh install` so the image works generically.
- For reproducible images you could bake the dotfiles into the image at build time (git clone during build), but keeping the clone/update at runtime makes it easier to iterate without rebuilding.
- If you want a more secure runtime for private keys, consider using SSH agent forwarding (`-v $SSH_AUTH_SOCK`) instead of mounting the private key into the container.

Security
--------
- Don't mount secrets into untrusted images. Prefer read-only mounts and minimal privileges.
- If you must use tokens/keys, scope them minimally (deploy key with read-only access is best).

Troubleshooting
---------------
- If the container fails to update due to merge conflicts, the entrypoint intentionally avoids forced merges. Inspect the repo state by running an interactive shell and resolving conflicts manually, or add logic to your install script to handle your preferred merge strategy.
- If your install requires additional packages (e.g., a language runtime), add them to the Dockerfile following the repo guidelines (slim base, pin versions, --no-install-recommends, apt-get clean).
