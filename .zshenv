# Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export GHC_DOT_APP="/Applications/ghc-7.10.2.app"
if [ -d "$GHC_DOT_APP" ]; then
  export PATH="${HOME}/.local/bin:${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi
