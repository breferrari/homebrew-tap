class Vigia < Formula
  desc "A live diff monitor for the terminal, and a note wire to the coding agent in the pane beside it."
  homepage "https://github.com/breferrari/vigia"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/breferrari/vigia/releases/download/v1.2.0/vigia-aarch64-apple-darwin.tar.xz"
      sha256 "e57dc79024227d4e8921eccd4a8ce26f0cafbb437eb7c9426a61d389923a6285"
    end
    if Hardware::CPU.intel?
      url "https://github.com/breferrari/vigia/releases/download/v1.2.0/vigia-x86_64-apple-darwin.tar.xz"
      sha256 "f31dbcccb56411619b64f3aafc13e89154e07eb47eab3e9ca9cb7f1504f28033"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/breferrari/vigia/releases/download/v1.2.0/vigia-x86_64-unknown-linux-musl.tar.xz"
    sha256 "e1b4a08d2325d685be0119a52884d414e31d05fac2ca97777f8e243fca4ed3c1"
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
