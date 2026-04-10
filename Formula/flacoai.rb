class Flacoai < Formula
  desc "Local AI coding agent powered by Ollama — with engineering skills, integrations, and Slack"
  homepage "https://github.com/Roura-io/flaco"
  url "https://github.com/Roura-io/flaco.git", branch: "main"
  version "0.2.0"
  license "MIT"

  depends_on "rust" => :build

  def install
    cd "rust" do
      system "cargo", "build", "--release", "-p", "flaco-cli", "-p", "server"
    end
    bin.install "rust/target/release/flacoai"
    bin.install "rust/target/release/flacoai-server"

    # Install bundled engineering skills
    (bin/"skills").install Dir["rust/crates/tools/skills/*"]
  end

  def caveats
    <<~EOS
      flacoAi requires Ollama running locally or on a remote host.

      Quick start:
        flacoai                          Start the interactive REPL
        flacoai skills                   List bundled engineering skills
        flacoai-server                   Start the Slack channel server

      Configure your Ollama host:
        export OLLAMA_BASE_URL="http://10.0.1.3:11434/v1"

      For Slack integration, set:
        export SLACK_BOT_TOKEN="xoxb-..."
        export SLACK_APP_TOKEN="xapp-..."
        export SLACK_SIGNING_SECRET="..."
    EOS
  end

  test do
    assert_match "flacoAi", shell_output("#{bin}/flacoai --help", 2).strip
    assert_predicate bin/"flacoai", :executable?
    assert_predicate bin/"flacoai-server", :executable?
    assert_predicate bin/"skills/code-review/SKILL.md", :exist?
  end
end
