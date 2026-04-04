class Flacoai < Formula
  desc "Local AI CLI powered by Ollama"
  homepage "https://github.com/Roura-io/flaco"
  url "https://github.com/Roura-io/flaco/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
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
    assert_match version.to_s, shell_output("#{bin}/flacoai --version", 2)
  end
end
