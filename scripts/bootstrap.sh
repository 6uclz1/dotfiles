#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly FLAKE_REF="path:${REPO_ROOT}"
readonly REQUIRED_USER="6uclz1"
readonly DARWIN_HOST="MacBook-Air-M4"
readonly WSL_CONFIG="6uclz1@wsl-arch"
readonly NIX_FLAGS=(--extra-experimental-features "nix-command flakes")

log() {
  printf '[bootstrap] %s\n' "$*"
}

die() {
  printf '[bootstrap] ERROR: %s\n' "$*" >&2
  exit 1
}

have() {
  command -v "$1" >/dev/null 2>&1
}

source_nix_env() {
  local candidates=(
    "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    "/nix/var/nix/profiles/default/etc/profile.d/nix.sh"
    "${HOME}/.nix-profile/etc/profile.d/nix.sh"
    "${HOME}/.nix-profile/etc/profile.d/nix-daemon.sh"
  )
  local candidate

  for candidate in "${candidates[@]}"; do
    if [[ -f "${candidate}" ]]; then
      # shellcheck disable=SC1090
      . "${candidate}"
      return 0
    fi
  done

  return 1
}

ensure_user() {
  local current_user
  current_user="$(id -un)"

  [[ "${current_user}" == "${REQUIRED_USER}" ]] || die "unsupported user: ${current_user} (expected ${REQUIRED_USER})"
}

detect_platform() {
  local uname_s
  uname_s="$(uname -s)"

  case "${uname_s}" in
    Darwin)
      local current_host
      current_host="$(scutil --get LocalHostName 2>/dev/null || hostname -s)"
      [[ "${current_host}" == "${DARWIN_HOST}" ]] || die "unsupported macOS host: ${current_host} (expected ${DARWIN_HOST})"
      printf 'darwin\n'
      ;;
    Linux)
      if [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/sys/kernel/osrelease; then
        printf 'wsl\n'
      else
        die "linux is supported only inside WSL for this repository"
      fi
      ;;
    *)
      die "unsupported platform: ${uname_s}"
      ;;
  esac
}

install_nix_if_needed() {
  if have nix; then
    return 0
  fi

  have curl || die "curl is required"

  log "installing Lix"
  curl -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm

  source_nix_env || true
  have nix || die "nix command is still unavailable after installation; restart the shell and retry"
}

ensure_lock_file() {
  if [[ -f "${REPO_ROOT}/flake.lock" ]]; then
    return 0
  fi

  log "generating flake.lock"
  nix "${NIX_FLAGS[@]}" flake lock --flake "${FLAKE_REF}"
}

run_checks() {
  log "running nix flake check"
  nix "${NIX_FLAGS[@]}" flake check --flake "${FLAKE_REF}"
}

apply_darwin() {
  local nix_bin
  nix_bin="$(command -v nix)"

  log "applying darwin configuration ${DARWIN_HOST}"
  sudo "${nix_bin}" "${NIX_FLAGS[@]}" run \
    nix-darwin/nix-darwin-25.11#darwin-rebuild -- \
    switch --flake "${FLAKE_REF}#${DARWIN_HOST}"
}

apply_wsl() {
  log "applying home-manager configuration ${WSL_CONFIG}"
  nix "${NIX_FLAGS[@]}" run \
    github:nix-community/home-manager/release-25.11 -- \
    switch --flake "${FLAKE_REF}#${WSL_CONFIG}"
}

main() {
  local platform

  ensure_user
  install_nix_if_needed
  source_nix_env || true
  have nix || die "nix command is unavailable"

  platform="$(detect_platform)"

  ensure_lock_file
  run_checks

  case "${platform}" in
    darwin)
      apply_darwin
      ;;
    wsl)
      apply_wsl
      ;;
    *)
      die "unexpected platform state: ${platform}"
      ;;
  esac

  log "bootstrap finished"
}

main "$@"
