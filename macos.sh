#!/bin/sh

set -euo pipefail

log() {
  printf "\033[1;34m==>\033[0m %s\n" "$1"
}

# Close System Settings to prevent overriding changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

log "Configuring Dock..."

# Icon size (pixels)
defaults write com.apple.dock tilesize -int 36
# Position: left, bottom, right
defaults write com.apple.dock orientation -string "bottom"
# Auto-hide dock
defaults write com.apple.dock autohide -bool true
# No delay before showing
defaults write com.apple.dock autohide-delay -float 0
# Animation speed (lower = faster)
defaults write com.apple.dock autohide-time-modifier -float 0.4
# Disable launch bounce animation
defaults write com.apple.dock launchanim -bool false
# Faster Mission Control animation
defaults write com.apple.dock expose-animation-duration -float 0.12
# Hide recent apps section
defaults write com.apple.dock show-recents -bool false
# Only show running apps
defaults write com.apple.dock static-only -bool true
# Minimize windows into app icon
defaults write com.apple.dock minimize-to-application -bool true
# Minimize effect: genie, scale, suck
defaults write com.apple.dock mineffect -string "scale"
# Dim hidden apps
defaults write com.apple.dock showhidden -bool true

# Top-left: disabled
defaults write com.apple.dock wvous-tl-corner -int 0
# Top-right: disabled
defaults write com.apple.dock wvous-tr-corner -int 0
# Bottom-left: disabled
defaults write com.apple.dock wvous-bl-corner -int 0
# Bottom-right: disabled
defaults write com.apple.dock wvous-br-corner -int 0

log "Configuring Finder..."

# Default view: icnv, Nlsv, clmv, glyv
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show path bar at bottom
defaults write com.apple.finder ShowPathbar -bool true
# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Show tab bar
defaults write com.apple.finder ShowTabView -bool true
# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# No warning when changing extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Show full path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Keep folders on top when sorting
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Auto-remove trash items after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true
# Save to disk, not iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Avoid .DS_Store files
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Desktop icons
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# AirDrop over all interfaces
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

log "Configuring Keyboard..."

# Fast key repeat (lower = faster, min 1)
defaults write NSGlobalDomain KeyRepeat -int 1
# Delay before repeat (lower = faster, min 10)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable accent menu, enable key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Full keyboard access (tab through all controls)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable auto-corrections (important for coding)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false

log "Configuring Trackpad..."

# Three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

log "Configuring Screenshots..."

# Save location
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
# Format: png, jpg, gif, pdf, tiff
defaults write com.apple.screencapture type -string "png"
# No window shadow
defaults write com.apple.screencapture disable-shadow -bool true
# Include date in filename
defaults write com.apple.screencapture include-date -bool true
# Show floating thumbnail
defaults write com.apple.screencapture show-thumbnail -bool true

log "Configuring Screen & Security..."

# Require password after screensaver
defaults write com.apple.screensaver askForPassword -int 1
# Immediately (0 seconds)
defaults write com.apple.screensaver askForPasswordDelay -int 0
# Font smoothing on non-Apple displays
defaults write NSGlobalDomain AppleFontSmoothing -int 1

log "Configuring Window Performance..."

# Faster window resize
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# Faster Terminal resize
defaults write com.apple.Terminal WindowResizeTime -float 0.001
# Don't auto-terminate inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
# Disable Finder animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Expand save/print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

log "Configuring Activity Monitor..."

# Show main window on launch
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
# Dock icon shows CPU usage
defaults write com.apple.ActivityMonitor IconType -int 5
# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0
# Sort by CPU
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
# Descending order
defaults write com.apple.ActivityMonitor SortDirection -int 0

log "Configuring Terminal..."

# Don't reopen windows on quit
defaults write com.apple.Terminal NSQuitAlwaysKeepsWindows -bool false
# Secure keyboard entry
defaults write com.apple.Terminal SecureKeyboardEntry -bool true

log "Configuring TextEdit..."

# Plain text mode by default
defaults write com.apple.TextEdit RichText -int 0
# UTF-8 for plain text
defaults write com.apple.TextEdit PlainTextEncoding -int 4
# UTF-8 for saving
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

log "Configuring Photos..."

# Don't open Photos when device is connected
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

log "Configuring Software Update..."

# Auto-check for updates
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Auto-download updates
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true
# Install security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
# Auto-update apps from App Store
defaults write com.apple.commerce AutoUpdate -bool true

log "Configuring Menu Bar..."

# Day, date, time format
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"

log "Configuring Sound..."

# No feedback sound on volume change
defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool false
# No screen flash on alert
defaults write com.apple.sound.beep.flash -bool false

log "Restarting affected applications..."

for app in "Activity Monitor" \
  "cfprefsd" \
  "Dock" \
  "Finder" \
  "Photos" \
  "SystemUIServer" \
  "Terminal"; do
  killall "${app}" &>/dev/null || true
done

log "Done! Some changes may require logout/restart to take effect."
