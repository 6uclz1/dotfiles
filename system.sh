#!/bin/bash
# Compatibility entry point; legacy system-wide changes are no longer applied.
exec /bin/bash "$(cd "$(dirname "$0")" && pwd)/setup.sh" --only macos "$@"
