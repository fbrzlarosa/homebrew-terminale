class Terminale < Formula
  desc "A native, cross-platform, GPU-accelerated terminal — Windows, macOS, Linux"
  homepage "https://stackbyte.dev/terminale"
  version "0.1.32"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.32/terminale-aarch64-apple-darwin.tar.gz"
      sha256 "9af59b578fb7a8e1dc56593f1ebc25af6f047cfb158bb70cc2acc115d51011e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.32/terminale-x86_64-apple-darwin.tar.gz"
      sha256 "9aa41ed4d855bd1467205663a0eadb74fbdf009c9f6832f80c728ff9495228ee"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.32/terminale-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "1bce8255fc201907e42c3b070a93dd2386fbe9fc2926965ff0ed2d42434a9a59"
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
