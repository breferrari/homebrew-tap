class Vigia < Formula
  desc "A live diff monitor for the terminal."
  homepage "https://github.com/breferrari/vigia"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/breferrari/vigia/releases/download/v0.7.0/vigia-aarch64-apple-darwin.tar.xz"
      sha256 "51a3b498029ee79d747c712c915a0e55c907f78e29f425a352932d2ddf64ae28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/breferrari/vigia/releases/download/v0.7.0/vigia-x86_64-apple-darwin.tar.xz"
      sha256 "24c73977b70d95d4890c79b01d32e7ee1279c90cf607392da652cd2f4e8aa46a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/breferrari/vigia/releases/download/v0.7.0/vigia-x86_64-unknown-linux-musl.tar.xz"
    sha256 "981b317fe3dd8a601ae43f036d9626854cbcbcdc8b3965357f86777b49391383"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vigia"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "vigia"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vigia"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
