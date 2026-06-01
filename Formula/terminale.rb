class Terminale < Formula
  desc "A native, cross-platform, GPU-accelerated terminal — Windows, macOS, Linux"
  homepage "https://stackbyte.dev/terminale"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.1/terminale-aarch64-apple-darwin.tar.gz"
      sha256 "ca8ca50851ec1c5686b47cc414c4253bb8afb6d0767cda148d0fa028b3c40efe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.1/terminale-x86_64-apple-darwin.tar.gz"
      sha256 "3acb6e53342db6f48cba211d8a6928936e003a172cf71d46c60a2abec2ac254a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.1/terminale-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "13f6ba45370ca388fe539d91e1e5afb7b5e9c73287c35c1b89830bd04558781e"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "terminale" if OS.mac? && Hardware::CPU.arm?
    bin.install "terminale" if OS.mac? && Hardware::CPU.intel?
    bin.install "terminale" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
