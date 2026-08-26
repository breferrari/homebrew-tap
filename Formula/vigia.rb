class Vigia < Formula
  desc "A live diff monitor for the terminal."
  homepage "https://github.com/breferrari/vigia"
  version "0.31.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/breferrari/vigia/releases/download/v0.31.0/vigia-aarch64-apple-darwin.tar.xz"
      sha256 "ed6c09cff475f528ba166b101a3c29785bb89c4617f1db0bbb1fecea1b286ef0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/breferrari/vigia/releases/download/v0.31.0/vigia-x86_64-apple-darwin.tar.xz"
      sha256 "8c38015cbc5db0f746bfc59aaf2ef0abe23c6f748e807b54eab305d186eb021a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/breferrari/vigia/releases/download/v0.31.0/vigia-x86_64-unknown-linux-musl.tar.xz"
    sha256 "ade754bcc6d0675f7a9382dff16d708de61608b9757cfa4ccc0583d130e2e045"
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
