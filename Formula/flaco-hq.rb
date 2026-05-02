class FlacoHq < Formula
  desc "Roura AI HQ operator console (Python + Textual TUI)"
  homepage "https://github.com/Roura-io/flaco-hq"
  version "0.4.14"

  # Private repo cloned via SSH. Requires SSH key for Roura-io to be configured.
  url "git@github.com:Roura-io/flaco-hq.git",
      using:    GitDownloadStrategy,
      tag:      "v0.4.14",
      revision: "554081fbaedc77e9e473c1425d2eb9df538f0207"

  depends_on "python@3.13"

  def install
    python3 = Formula["python@3.13"].opt_bin/"python3.13"

    system python3, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--quiet", "--upgrade", "pip"
    system libexec/"bin/pip", "install", "--quiet", "textual>=0.80.0"
    system libexec/"bin/pip", "install", "--quiet", "slack-sdk>=3.27"
    system libexec/"bin/pip", "install", "--quiet", "--no-deps", buildpath

    (bin/"flaco-hq").write <<~SH
      #!/bin/bash
      CONF="${HOME}/.config/flaco-hq/config"
      if [ -f "$CONF" ]; then
        set -a; source "$CONF"; set +a
      fi
      exec "#{libexec}/bin/python" -m flaco "$@"
    SH
  end

  def caveats
    <<~EOS
      Roura AI HQ workspace defaults to /Users/Shared/RouraAI.

      To override, create ~/.config/flaco-hq/config:
        ROURA_AI_HOME=/path/to/workspace

      Or pass it inline:
        flaco-hq --workspace /path/to/workspace

      Run: flaco-hq
    EOS
  end
end
