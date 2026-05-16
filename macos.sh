#!/bin/bash

set -euo pipefail

log() {
  printf "\033[1;34m==>\033[0m %s\n" "$1"
}

warn() {
  printf "\033[1;33m!!\033[0m %s\n" "$1" >&2
}

# Sandboxed app prefs (Safari, Terminal, etc.) live in
# ~/Library/Containers/<bundle-id>/Data/Library/Preferences/. Writing them via
# `defaults` requires the calling terminal to have Full Disk Access. Probe by
# attempting a no-op read; if it fails, skip those blocks instead of aborting
# under `set -e`.
has_fda() {
  defaults read com.apple.Safari >/dev/null 2>&1
}

# Sanity check: macOS only
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is macOS only." >&2
  exit 1
fi

# Close System Settings so it doesn't overwrite changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# Ask for sudo upfront and keep alive (a couple of settings need it)
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &

###############################################################################
# Dock + Mission Control
###############################################################################
log "Configuring Dock..."

defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock show-recents -bool false

# WARNING: hides all pinned apps that aren't running. Comment out if you want
# the classic Dock behavior with pinned shortcuts.
defaults write com.apple.dock static-only -bool true

defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock showhidden -bool true

# don't auto-rearrange Spaces by recent use (kills muscle memory otherwise)
defaults write com.apple.dock mru-spaces -bool false
# don't group windows by app in Mission Control — show every window
defaults write com.apple.dock expose-group-apps -bool false

# Hot corners all disabled (set to 0 to enable, 2/3/4/5 for various actions)
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0

###############################################################################
# Finder
###############################################################################
log "Configuring Finder..."

defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# WARNING: auto-deletes trash items after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# No .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Desktop icons
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# AirDrop over all interfaces (Ethernet too, not just Wi-Fi)
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# unhide ~/Library and /Volumes
chflags nohidden ~/Library 2>/dev/null || true
sudo chflags nohidden /Volumes 2>/dev/null || true

###############################################################################
# Keyboard
###############################################################################
log "Configuring Keyboard..."

defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable auto-corrections
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false

###############################################################################
# Trackpad
###############################################################################
log "Configuring Trackpad..."

defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Screenshots
###############################################################################
log "Configuring Screenshots..."

defaults write com.apple.screencapture location -string "${HOME}/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture include-date -bool true
defaults write com.apple.screencapture show-thumbnail -bool true

###############################################################################
# Screen & Security
###############################################################################
log "Configuring Screen & Security..."

defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# don't auto-open "safe" files after download (Safari will obey)
if has_fda; then
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
else
  warn "Skipping Safari AutoOpenSafeDownloads — terminal lacks Full Disk Access."
fi

###############################################################################
# Window & system performance
###############################################################################
log "Configuring Window Performance..."

defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write com.apple.Terminal WindowResizeTime -float 0.001
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Expand save/print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

###############################################################################
# Activity Monitor
###############################################################################
log "Configuring Activity Monitor..."

defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Terminal
###############################################################################
log "Configuring Terminal..."

if has_fda; then
  defaults write com.apple.Terminal NSQuitAlwaysKeepsWindows -bool false
  defaults write com.apple.Terminal SecureKeyboardEntry -bool true
else
  warn "Skipping Terminal prefs — terminal lacks Full Disk Access."
fi

###############################################################################
# TextEdit
###############################################################################
log "Configuring TextEdit..."

defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Safari (developer)
###############################################################################
log "Configuring Safari (developer)..."

if has_fda; then
  # Develop menu + Web Inspector
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  # Show full URL in address bar (no domain-only display)
  defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

  # Disable autofill, passwords/cards belong in a real password manager
  defaults write com.apple.Safari AutoFillFromAddressBook -bool false
  defaults write com.apple.Safari AutoFillPasswords -bool false
  defaults write com.apple.Safari AutoFillCreditCardData -bool false
  defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

  # Don't preload top hit (saves bandwidth + reduces tracking surface)
  defaults write com.apple.Safari PreloadTopHit -bool false
else
  warn "Skipping Safari developer prefs — grant Full Disk Access to your terminal in"
  warn "System Settings → Privacy & Security → Full Disk Access, then rerun."
fi

###############################################################################
# Mac App Store (developer)
###############################################################################
log "Configuring Mac App Store..."

defaults write com.apple.appstore WebKitDeveloperExtras -bool true
defaults write com.apple.appstore ShowDebugMenu -bool true

###############################################################################
# Photos
###############################################################################
log "Configuring Photos..."

defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Software Update
###############################################################################
log "Configuring Software Update..."

defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
defaults write com.apple.commerce AutoUpdate -bool true

###############################################################################
# Menu bar
###############################################################################
log "Configuring Menu Bar..."

defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"

# show battery percentage
defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool true 2>/dev/null || true

###############################################################################
# Sound
###############################################################################
log "Configuring Sound..."

defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool false
defaults write NSGlobalDomain com.apple.sound.beep.flash -bool false

###############################################################################
# Crash reporter / diagnostics
###############################################################################
log "Configuring Crash Reporter..."

# No popup dialogs when an app crashes (still logs to ~/Library/Logs)
defaults write com.apple.CrashReporter DialogType -string "none"

###############################################################################
# Restart affected apps
###############################################################################
log "Restarting affected applications..."

# NOTE: Safari + TextEdit are NOT killed here on purpose — losing open tabs or
# unsaved drafts would be rude.
for app in "Activity Monitor" \
  "cfprefsd" \
  "Dock" \
  "Finder" \
  "Photos" \
  "SystemUIServer" \
  "Terminal"; do
  killall "${app}" &>/dev/null || true
done

log "Done. A few changes need a logout or full restart to apply."
