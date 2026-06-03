# typed: false
# frozen_string_literal: true

cask "magic-accessories-connector" do
  version "1.1.0"
  sha256 "5bec4aa90a3d9e44e2c59f7c40f4d2658ebe9e089c1bd0d7b9b36f06ce586154"

  url "https://github.com/Radixen-Dev/MagicAccessoriesConnector/releases/download/v#{version}/MagicAccessoriesConnector-#{version}.zip"
  name "Magic Accessories Connector"
  desc "Auto-reconnect Magic Mouse & Keyboard between Macs from the menu bar"
  homepage "https://github.com/Radixen-Dev/MagicAccessoriesConnector"

  depends_on formula: "blueutil"
  depends_on macos: ">= :monterey"

  # The app is not notarized. Without this flag Homebrew stamps the quarantine
  # xattr on install, which triggers the "can't be verified / Move to Trash"
  # Gatekeeper dialog on macOS 13+. Skipping quarantine is safe here because
  # the user explicitly ran `brew install` — intent is already established.
  disable_quarantine true

  app "MagicAccessoriesConnector.app"

  # Quit the running app before uninstalling so files are not locked.
  uninstall quit: "dev.radixen.magic-accessories-connector"

  # --zap removes all user-created data: preferences and the Start-at-Login
  # LaunchAgent (created when the user enables it from the menu).
  zap trash: [
    "~/Library/Application Support/MagicAccessoriesConnector",
    "~/Library/LaunchAgents/dev.radixen.magic-accessories-connector.plist",
  ]

  caveats <<~EOS
    Magic Accessories Connector is a menu bar app. After installation, launch it:
      open /Applications/MagicAccessoriesConnector.app

    To start automatically at login, click "Start at Login" in the MAC menu bar icon.

    To fully uninstall and leave zero trace on your machine:
      1. Click Quit in the MAC menu
      2. brew uninstall --cask --zap magic-accessories-connector
      3. brew uninstall blueutil   # only if nothing else uses it
  EOS
end
