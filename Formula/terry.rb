class Terry < Formula
  desc "terry — local AI coding assistant powered by Ollama"
  homepage "https://github.com/Roura-io/terry"
  version "0.1.2"

  on_macos do
    on_arm do
      url "https://github.com/Roura-io/terry/releases/download/v0.1.2/terry-0.1.2-arm64-apple-darwin.tar.gz"
      sha256 "c9b6464dc1de9960ffe10fa82b5d293f84e88aa75d7f18cf3cca402e66f4c550"
    end
  end

  def install
    libexec.install "terry"

    etc.install "terry.conf" unless (etc/"terry.conf").exist?

    (bin/"terry").write <<~EOS
      #!/bin/bash
      CONF="${HOME}/.config/terry/config"
      if [ -f "$CONF" ]; then
        set -a; source "$CONF"; set +a
      elif [ -f "#{etc}/terry.conf" ]; then
        set -a; source "#{etc}/terry.conf"; set +a
      fi
      exec "#{libexec}/terry" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Requires Ollama running at OLLAMA_URL (default: http://10.0.1.3:11434/v1).

      To override model or URL, create ~/.config/terry/config:
        OLLAMA_URL=http://10.0.1.3:11434/v1
        MODEL=qwen3-coder-next:latest

      Run: terry
    EOS
  end
end
