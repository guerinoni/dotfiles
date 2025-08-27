#! /bin/sh

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Preferences" to quit'



# Dock

# speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.12

# remove launch animation
defaults write com.apple.dock launchanim -bool false

# set to dock position
defaults write com.apple.dock "orientation" -string "bottom"

# set 36 of icon size
defaults write com.apple.dock "tilesize" -int "36"

# autohide
defaults write com.apple.dock "autohide" -bool "true"

# faster autohide animation
defaults write com.apple.dock "autohide-delay" -float "0"
defaults write com.apple.dock "autohide-time-modifier" -float "0.4"

# remove recents from dock
defaults write com.apple.dock "show-recents" -bool "false"

# show active applications only
defaults write com.apple.dock "static-only" -bool "true"

# minimize windows into their application icon
defaults write com.apple.dock minimize-to-application -bool true

# don't show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true



# Finder

# list view in all Finder windows
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# show extension of files
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"

# show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"

# show path in a bar
defaults write com.apple.finder "ShowPathbar" -bool "true"

# show status bar
defaults write com.apple.finder "ShowStatusBar" -bool "true"

# show tab bar
defaults write com.apple.finder "ShowTabView" -bool "true"

# deafult search in current folder
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

# save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# disable warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# use column view in all Finder windows by default (better for developers)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"



# Thouchpad

# three finger drag
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

# enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1



# Developer Tools & Terminal

# faster Terminal.app window resizing
defaults write com.apple.Terminal WindowResizeTime -float 0.001

# disable warning when quitting Terminal
defaults write com.apple.Terminal NSQuitAlwaysKeepsWindows -bool false



# Keyboard

# fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# disable held down menu when keep press a letter
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"

# disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# disable smart quotes (important for code)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# disable smart dashes (important for code)
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false


# Screen and Screenshots

# save screenshots to Desktop (or change to ~/Pictures/Screenshots)
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0



# Activity Monitor

# show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0



# System Preferences / System Settings

# increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Kill all apps affected

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Mail" \
	"Messages" \
	"Photos" \
	"Safari" \
	"SystemUIServer" \
	"Terminal" \
	"iCal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

