class Vigia < Formula
  desc "A live diff monitor for the terminal, and a note wire to the coding agent in the pane beside it."
  homepage "https://github.com/breferrari/vigia"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/breferrari/vigia/releases/download/v1.0.0/vigia-aarch64-apple-darwin.tar.xz"
      sha256 "a07bfda72a0dc997073bbebf9f3d3e51f0479530cd45a5b73ebcbf08471a4f7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/breferrari/vigia/releases/download/v1.0.0/vigia-x86_64-apple-darwin.tar.xz"
      sha256 "0a12af577ad1df958d9dc78cd719121a294c5e363b410e739ba8047f4254c4fe"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/breferrari/vigia/releases/download/v1.0.0/vigia-x86_64-unknown-linux-musl.tar.xz"
    sha256 "498030458424d9a51e4bef4a880ab6478bcae0774bed6e561380cf559f403eac"
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
