class Vigia < Formula
  desc "A live diff monitor for the terminal."
  homepage "https://github.com/breferrari/vigia"
  version "0.36.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/breferrari/vigia/releases/download/v0.36.0/vigia-aarch64-apple-darwin.tar.xz"
      sha256 "f52b3944b56ed8d51b5e3337b06bb3f28e26aec2ce400e53163e891341a9dfab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/breferrari/vigia/releases/download/v0.36.0/vigia-x86_64-apple-darwin.tar.xz"
      sha256 "8564bca679e52d5e0cae8fe574bbde851e400941e41bf13122e28cb7414d7ed9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/breferrari/vigia/releases/download/v0.36.0/vigia-x86_64-unknown-linux-musl.tar.xz"
    sha256 "bee58ac74afc5fb893821e2fc1aa19a9ebc98d8050ceb69d6c5197e1076df114"
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
