#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
for file in bootstrap.sh setup.sh system.sh makelinks.sh scripts/*.sh tests/run.sh; do
    /bin/bash -n "$file"
done
shellcheck -x bootstrap.sh setup.sh system.sh makelinks.sh scripts/*.sh tests/run.sh
if command -v zsh >/dev/null 2>&1; then
    for file in shell/*.zsh; do zsh -n "$file"; done
fi
python3 -m unittest discover -s tests -v
