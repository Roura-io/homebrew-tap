class Flacoai < Formula
  desc "flacoAi — local AI assistant powered by Ollama with Claude validation"
  homepage "https://github.com/Roura-io/flaco"
  version "0.8.3"

  on_macos do
    on_arm do
      url "https://github.com/Roura-io/flaco/releases/download/v0.8.3/flaco-0.8.3-arm64-apple-darwin.tar.gz"
      sha256 "250989e0cd8f83e7674182129f9a7f8e6288e7ca301f0d6e9db9b3cfabf03517"
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
