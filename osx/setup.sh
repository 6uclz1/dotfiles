#!/bin/bash

sh ./install.sh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sh ./symboliclink.sh

sh ./apps/serum_presets.sh

sh ./apps/sketch_plugin.sh

git clone https://github.com/6uclz1/Fonts

mv ./Fonts/*.ttf ~/Library/Fonts/

rm -r ./Fonts
