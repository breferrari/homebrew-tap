class Vigia < Formula
  desc "A live diff monitor for the terminal."
  homepage "https://github.com/breferrari/vigia"
  version "0.38.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/breferrari/vigia/releases/download/v0.38.0/vigia-aarch64-apple-darwin.tar.xz"
      sha256 "101bec5686505971f5ed13ec245d50350cf57c59fb1fd57651a71d5e13a9c14c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/breferrari/vigia/releases/download/v0.38.0/vigia-x86_64-apple-darwin.tar.xz"
      sha256 "4e01e6355fd5e96fe5cc9d0ba96afe176b6bf67b968b7f4a6cfeaeca2f47b305"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/breferrari/vigia/releases/download/v0.38.0/vigia-x86_64-unknown-linux-musl.tar.xz"
    sha256 "98b1a80bbee5f08238f1d4599dd450b6da13a833da8fe4a3169247b96c992c9f"
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
