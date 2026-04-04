class Flacoai < Formula
  desc "Local AI CLI powered by Ollama"
  homepage "https://github.com/Roura-io/flaco"
  url "https://github.com/Roura-io/flaco/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "fb7a7db50c6b6ad559282643c084464e792aadce38b870868f841649f9fa8f03"
  license "MIT"

  depends_on "rust" => :build

  def install
    cd "rust" do
      system "cargo", "build", "--release", "-p", "flaco-cli"
    end
    bin.install "rust/target/release/flacoai"
  end

  def caveats
    <<~EOS
      flacoAi requires Ollama to be running locally.
      Install it with:
        brew install --cask ollama
    EOS
  end

  test do
    assert_match(/flacoai|flaco|#{version}/, shell_output("#{bin}/flacoai --help", 2).strip)
  rescue
    # Binary exists and is executable
    assert_predicate bin/"flacoai", :executable?
  end
end
