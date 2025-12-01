#!/usr/bin/env bash
set -euo pipefail

# Entrypoint for dotfiles toolbox
# Behavior:
# - Clone DOTFILES_REPO into DOTFILES_DIR on first run
# - On subsequent runs, fetch & fast-forward update the repo
# - If repo contains an install/bootstrap script, run it as the unprivileged user
# - Finally exec into the requested command as the unprivileged user (default bash)

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/jhulten/dotfiles.git}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_DIR="${DOTFILES_DIR:-/home/toolbox/.dotfiles}"
USER="toolbox"
HOME_DIR="/home/${USER}"

# Helper to run commands as non-root user
run_as_user() {
  # Use su to run commands as the unprivileged user
  su - "${USER}" -s /bin/bash -c "$*"
}

info() { echo ">> $*"; }

# Ensure home dir ownership
chown -R "${USER}:${USER}" "${HOME_DIR}" || true

if [ -d "${DOTFILES_DIR}/.git" ]; then
  info "Dotfiles repo exists, updating..."
  # fetch and try a fast-forward pull
  run_as_user "cd ${DOTFILES_DIR} && git fetch --all --tags --prune"
  # attempt to checkout requested branch (ignore failures)
  run_as_user "cd ${DOTFILES_DIR} && git checkout ${DOTFILES_BRANCH} || true"
  # try fast-forward pull only to avoid unexpected merges
  run_as_user "cd ${DOTFILES_DIR} && git pull --ff-only || (echo 'Non-fast-forward or no changes to pull; skipping pull')"
else
  info "Cloning dotfiles from ${DOTFILES_REPO} (branch ${DOTFILES_BRANCH}) into ${DOTFILES_DIR}..."
  run_as_user "git clone --depth 1 --branch ${DOTFILES_BRANCH} '${DOTFILES_REPO}' '${DOTFILES_DIR}'"
fi

# Run install/bootstrap steps if present
# Preference order: install.sh, bootstrap.sh, setup.sh, makefile target 'install', or 'fresh' if installed
if run_as_user "[ -x '${DOTFILES_DIR}/install.sh' ]"; then
  info "Running install.sh from dotfiles..."
  run_as_user "cd ${DOTFILES_DIR} && ./install.sh"
elif run_as_user "[ -x '${DOTFILES_DIR}/bootstrap.sh' ]"; then
  info "Running bootstrap.sh from dotfiles..."
  run_as_user "cd ${DOTFILES_DIR} && ./bootstrap.sh"
elif run_as_user "[ -x '${DOTFILES_DIR}/setup.sh' ]"; then
  info "Running setup.sh from dotfiles..."
  run_as_user "cd ${DOTFILES_DIR} && ./setup.sh"
elif run_as_user "command -v fresh >/dev/null 2>&1"; then
  info "Running 'fresh install' (fresh detected)..."
  run_as_user "cd ${DOTFILES_DIR} && fresh install"
elif run_as_user "[ -f '${DOTFILES_DIR}/Makefile' ]" && run_as_user "make -C ${DOTFILES_DIR} -n install >/dev/null 2>&1"; then
  info "Running 'make -C ${DOTFILES_DIR} install'..."
  run_as_user "cd ${DOTFILES_DIR} && make install"
else
  info "No recognized install/bootstrap script found. You can add install.sh or bootstrap.sh in your dotfiles repo to automate setup."
fi

# Ensure ownership again (in case installer created files)
chown -R "${USER}:${USER}" "${HOME_DIR}" || true

# Exec the requested command (or default) as the unprivileged user
if [ "${#}" -gt 0 ]; then
  # run provided command
  exec su - "${USER}" -s /bin/bash -c "$*"
else
  # default to interactive shell
  exec su - "${USER}" -s /bin/bash -c "exec bash --login"
fi
