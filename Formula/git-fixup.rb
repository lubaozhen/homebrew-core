class GitFixup < Formula
  desc "Alias for git commit --fixup <ref>"
  homepage "https://github.com/keis/git-fixup"
  url "https://github.com/keis/git-fixup/archive/v1.4.0.tar.gz"
  sha256 "78cc604b205fa6fe1d982eee2adb9b7482ba0b08f83d2e52f713d663e2865e9d"
  license "ISC"
  head "https://github.com/keis/git-fixup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3868823118314e8a8669fe02c51015ffa7e3d5f9cef9c892dcd464928622d2f6"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    zsh_completion.install "completion.zsh" => "_git-fixup"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "fixup"
  end
end
