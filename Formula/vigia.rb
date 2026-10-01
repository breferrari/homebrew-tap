class Vigia < Formula
  desc "A live diff monitor for the terminal, and a note wire to the coding agent in the pane beside it."
  homepage "https://github.com/breferrari/vigia"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/breferrari/vigia/releases/download/v1.1.0/vigia-aarch64-apple-darwin.tar.xz"
      sha256 "22187923f972a5f9b5f2585a34c33e59c3b371d02850171a93cee5506049dcf6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/breferrari/vigia/releases/download/v1.1.0/vigia-x86_64-apple-darwin.tar.xz"
      sha256 "e98cfff2709b58f3bfcd651566188510e268a10d0cbf8c357d4b31a3eea2a637"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/breferrari/vigia/releases/download/v1.1.0/vigia-x86_64-unknown-linux-musl.tar.xz"
    sha256 "f72ca641551feba1c834641f36e99185b9c62bef09763f2084e21cd7bee86e55"
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
