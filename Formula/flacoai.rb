class Flacoai < Formula
  desc "flacoAi — local AI assistant powered by Ollama with Claude validation"
  homepage "https://github.com/Roura-io/flaco"
  version "0.4.1"

  on_macos do
    on_arm do
      url "https://github.com/Roura-io/flaco/releases/download/v0.4.1/flaco-0.4.1-arm64-apple-darwin.tar.gz"
      sha256 "53e5f6c26cb4e43dc57c48c53b4a86add8118c2981748b0c5567cea433e63687"
    end
  end

  def install
    libexec.install "flaco" => "flaco-bin"
    etc.install "flaco.conf" unless (etc/"flaco.conf").exist?

    (bin/"flaco").write <<~EOS
      #!/bin/bash
      CONF="${HOME}/.config/flaco/config"
      if [ -f "$CONF" ]; then
        set -a; source "$CONF"; set +a
      elif [ -f "#{etc}/flaco.conf" ]; then
        set -a; source "#{etc}/flaco.conf"; set +a
      fi
      exec "#{libexec}/flaco-bin" --repl "$@"
    EOS
  end

  def caveats
    <<~EOS
      Edit ~/.config/flaco/config with your Ollama URL and API keys, then run:
        flaco
    EOS
  end
end
