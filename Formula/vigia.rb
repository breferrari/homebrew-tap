class Vigia < Formula
  desc "A live diff monitor for the terminal."
  homepage "https://github.com/breferrari/vigia"
  version "0.29.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/breferrari/vigia/releases/download/v0.29.1/vigia-aarch64-apple-darwin.tar.xz"
      sha256 "659b81d7f23d2008fd8ece73ba7c10715521a41b35564a402e6488fc8b4406ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/breferrari/vigia/releases/download/v0.29.1/vigia-x86_64-apple-darwin.tar.xz"
      sha256 "579bb330d2a04a11ee8fb748386ac45196b8c57c5057fb20a16a802213d7a560"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/breferrari/vigia/releases/download/v0.29.1/vigia-x86_64-unknown-linux-musl.tar.xz"
    sha256 "de9e58f13cf7c879a7894c02f68f50bc4854cd981cedc4f4e2b20b8b88df073b"
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
