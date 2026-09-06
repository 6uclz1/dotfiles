#!/bin/bash
# Compatibility entry point; only the new minimal Zsh configuration is managed.
exec /bin/bash "$(cd "$(dirname "$0")" && pwd)/setup.sh" --only shell "$@"
