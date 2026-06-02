class Terminale < Formula
  desc "A native, cross-platform, GPU-accelerated terminal — Windows, macOS, Linux"
  homepage "https://stackbyte.dev/terminale"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.12/terminale-aarch64-apple-darwin.tar.gz"
      sha256 "9e80966d13bf4607d3b7918cddc57ac67ad935a727e3c65530611662c8960c8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.12/terminale-x86_64-apple-darwin.tar.gz"
      sha256 "b5babc9efff95ee5b7d0fff26d893e8667a87d26f55cac6cd6c1f1a2fa1a3645"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.12/terminale-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "4bdf5d119c18086e7dba27e37d7972fb20765dfd7fa8ce21f742c6b3ee62bc80"
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
