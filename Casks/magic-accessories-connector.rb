# typed: false
# frozen_string_literal: true

cask "magic-accessories-connector" do
  version "1.2.0"
  sha256 "492cca670f6a215f915f7eb37fc56c69fb70b67e1963c91c586d7dd962f98ca0"

  url "https://github.com/Radixen-Dev/MagicAccessoriesConnector/releases/download/v#{version}/MagicAccessoriesConnector-#{version}.zip"
  name "Magic Accessories Connector"
  desc "Auto-reconnect Magic Mouse & Keyboard between Macs from the menu bar"
  homepage "https://github.com/Radixen-Dev/MagicAccessoriesConnector"

  depends_on formula: "blueutil"
  depends_on macos: ">= :monterey"

  app "MagicAccessoriesConnector.app"

  # The app is not notarized. Homebrew stamps com.apple.quarantine on install,
  # which triggers the "can't be verified / Move to Trash" Gatekeeper dialog on
  # macOS 13+. Removing the xattr postflight is safe — the user already ran
  # `brew install` so intent is established.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/MagicAccessoriesConnector.app"]
  end

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
