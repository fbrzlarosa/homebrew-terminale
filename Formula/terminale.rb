class Terminale < Formula
  desc "A native, cross-platform, GPU-accelerated terminal — Windows, macOS, Linux"
  homepage "https://stackbyte.dev/terminale"
  version "0.1.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.29/terminale-aarch64-apple-darwin.tar.gz"
      sha256 "c5b78fa3536713221634fd6df03f70269c44083202dc2c6690ed6f9c5c581992"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.29/terminale-x86_64-apple-darwin.tar.gz"
      sha256 "dbb0913b3956df710c881baee1ec56a0c0516593747fe13b0a35296ed616413a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.29/terminale-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "98ecb46e39eaf19fe369dc3a98241e21fc787c2201c1bf46369cc92ba669db50"
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
