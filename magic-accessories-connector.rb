# typed: false
# frozen_string_literal: true

class MagicAccessoriesConnector < Formula
  include Language::Python::Virtualenv

  desc "Auto-reconnect Magic Mouse & Keyboard between Macs from the menu bar"
  homepage "https://github.com/Radixen-Dev/MagicAccessoriesConnector"
  url "https://github.com/Radixen-Dev/MagicAccessoriesConnector/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d986f8df3aa99b719a791bd9d8056ffc0261c3caad915a7b839224503bf5a187"
  license "MIT"
  head "https://github.com/Radixen-Dev/MagicAccessoriesConnector.git", branch: "main"

  depends_on "blueutil"
  depends_on "python@3.13"

  resource "rumps" do
    url "https://files.pythonhosted.org/packages/b2/e2/2e6a47951290bd1a2831dcc50aec4b25d104c0cf00e8b7868cbd29cf3bfe/rumps-0.4.0.tar.gz"
    sha256 "17fb33c21b54b1e25db0d71d1d793dc19dc3c0b7d8c79dc6d833d0cffc8b1596"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  def install
    libexec.install "app.py", "bluetooth.py"

    venv = virtualenv_create(libexec/"venv", "python@3.13")
    venv.pip_install resources

    (bin/"magic-accessories-connector").write <<~BASH
      #!/bin/bash
      export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
      exec "#{libexec}/venv/bin/python3" "#{libexec}/app.py" "$@"
    BASH
    chmod 0755, bin/"magic-accessories-connector"
  end

  service do
    run [opt_bin/"magic-accessories-connector"]
    keep_alive true
    environment_variables OBJC_DISABLE_INITIALIZE_FORK_SAFETY: "YES"
    log_path var/"log/magic-accessories-connector.log"
    error_log_path var/"log/magic-accessories-connector.log"
  end

  def caveats
    <<~EOS
      To start MagicAccessoriesConnector at login (recommended):
        brew services start magic-accessories-connector

      To run once without registering as a login item:
        magic-accessories-connector

      Preferences are stored at:
        ~/Library/Application Support/MagicAccessoriesConnector/prefs.json

      To fully uninstall, including saved preferences:
        brew services stop magic-accessories-connector
        brew uninstall magic-accessories-connector
        rm -rf ~/Library/Application\\ Support/MagicAccessoriesConnector
    EOS
  end

  test do
    system libexec/"venv/bin/python3", "-c", "import rumps; print('ok')"
  end
end
