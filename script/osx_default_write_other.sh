# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Avoid creating `.DS_Store` files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
