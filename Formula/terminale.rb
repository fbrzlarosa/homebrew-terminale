class Terminale < Formula
  desc "A native, cross-platform, GPU-accelerated terminal — Windows, macOS, Linux"
  homepage "https://stackbyte.dev/terminale"
  version "0.1.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.13/terminale-aarch64-apple-darwin.tar.gz"
      sha256 "5feb514c4a1c48ff7d11eb616bb783f0d0baf668f1789eb6c7c0c6a876ccef68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.13/terminale-x86_64-apple-darwin.tar.gz"
      sha256 "bdb678788ced349f5d0c981e849642452f79631193b01c116b7f5d5db00a35c1"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fbrzlarosa/terminale/releases/download/v0.1.13/terminale-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "88f6e38c3355fade68bac4088071d16fb4c294562c460c0192ae0180517de81d"
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
