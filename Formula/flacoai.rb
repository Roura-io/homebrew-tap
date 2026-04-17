class Flacoai < Formula
  desc "flacoAi — local AI assistant powered by Ollama with Claude validation"
  homepage "https://github.com/Roura-io/flaco"
  version "0.4.0"

  on_macos do
    on_arm do
      url "https://github.com/Roura-io/flaco/releases/download/v0.4.0/flaco-0.4.0-arm64-apple-darwin.tar.gz"
      sha256 "215142e37a102168ec6a93f5d1533f59ad0762646c2ee360c72c90e5aeed4974"
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

  def post_install
    config_dir = Pathname.new("#{Dir.home}/.config/flaco")
    config_dir.mkpath
    config_file = config_dir/"config"
    unless config_file.exist?
      cp etc/"flaco.conf", config_file
    end
  end

  def caveats
    <<~EOS
      Edit ~/.config/flaco/config with your Ollama URL and API keys, then run:
        flaco
    EOS
  end
end
