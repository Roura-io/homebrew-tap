class Flacoai < Formula
  desc "flacoAi — local AI assistant powered by Ollama with Claude validation"
  homepage "https://github.com/Roura-io/flaco"
  version "0.8.4"

  on_macos do
    on_arm do
      url "https://github.com/Roura-io/flaco/releases/download/v0.8.4/flaco-0.8.4-arm64-apple-darwin.tar.gz"
      sha256 "39a5fa110c1110d12cc107640253e7b3dd5aeaf6959e1f54955f21be45327345"
    end
  end

  def install
    libexec.install "flaco-tui"
    libexec.install "flaco-repl"
    etc.install "flaco.conf" unless (etc/"flaco.conf").exist?

    (share/"flaco").install "agents"
    (share/"flaco").install "commands"
    (share/"flaco").install "rules"
    (share/"flaco").install "skills"

    # flaco → full TUI (daily driver)
    (bin/"flaco").write <<~EOS
      #!/bin/bash
      CONF="${HOME}/.config/flaco/config"
      if [ -f "$CONF" ]; then
        set -a; source "$CONF"; set +a
      elif [ -f "#{etc}/flaco.conf" ]; then
        set -a; source "#{etc}/flaco.conf"; set +a
      fi
      FLACO_HOME="${HOME}/.flaco"
      if [ ! -d "$FLACO_HOME/agents" ]; then
        mkdir -p "$FLACO_HOME"
        ln -sf "#{share}/flaco/agents" "$FLACO_HOME/agents"
        ln -sf "#{share}/flaco/commands" "$FLACO_HOME/commands"
        ln -sf "#{share}/flaco/rules" "$FLACO_HOME/rules"
        ln -sf "#{share}/flaco/skills" "$FLACO_HOME/skills"
      fi
      if [ "$1" = "--repl" ]; then
        exec "#{libexec}/flaco-repl" --repl "${@:2}"
      else
        exec "#{libexec}/flaco-tui" "$@"
      fi
    EOS
  end

  def caveats
    <<~EOS
      Edit ~/.config/flaco/config then run:
        flaco          # Full TUI (daily driver)
        flaco --repl   # Basic REPL (remote/mobile)
    EOS
  end
end
