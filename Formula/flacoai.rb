class Flacoai < Formula
  desc "flacoAi — local AI assistant powered by Ollama with Claude validation"
  homepage "https://github.com/Roura-io/flaco"
  version "0.4.4"

  on_macos do
    on_arm do
      url "https://github.com/Roura-io/flaco/releases/download/v0.4.4/flaco-0.4.4-arm64-apple-darwin.tar.gz"
      sha256 "e1e015fc7c542a5bc44c15a3d9494a975dcc92f0c33dd74513ba8ff7226d41f0"
    end
  end

  def install
    libexec.install "flaco" => "flaco-bin"
    etc.install "flaco.conf" unless (etc/"flaco.conf").exist?

    # Install registry content preserving directory structure
    (share/"flaco").install "agents"
    (share/"flaco").install "commands"
    (share/"flaco").install "rules"
    (share/"flaco").install "skills"

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
      exec "#{libexec}/flaco-bin" --repl "$@"
    EOS
  end

  def caveats
    <<~EOS
      Edit ~/.config/flaco/config then run: flaco
      Includes 39 agents, 72 commands, 12 rules, 23 skills.
    EOS
  end
end
