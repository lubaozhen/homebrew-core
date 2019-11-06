class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.13.2-src/pyside-setup-opensource-src-5.13.2.tar.xz"
  sha256 "3e255d64df08880d0281ebe86009d5ea45f24332b308954d967c33995f75e543"

  bottle do
    sha256 "d488a210760567bf8cd40c4f16ff24d2a2d8fadd98d4d6d2fb25023452dfaa48" => :catalina
    sha256 "7f5196abed2367fe167bafee9d684855c458215f0459ecaa26e56f251f4ca482" => :mojave
    sha256 "9913e73b0df42cc6248a9a03bb40b3ded4fc35cf90b382455cc78835827ac74a" => :high_sierra
    sha256 "28a05e906f3957f748351d354d5df186b6c54d14184b044ea40db748cd0f3109" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python"
  depends_on "qt"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    args = %W[
      --ignore-git
      --parallel=#{ENV.make_jobs}
      --install-scripts #{bin}
    ]

    xy = Language::Python.major_minor_version "python3"

    system "python3", *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python#{xy}/site-packages", *args,
           "--build-type=shiboken2"

    system "python3", *Language::Python.setup_install_args(prefix),
           "--install-lib", lib/"python#{xy}/site-packages", *args,
           "--build-type=pyside2"

    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/PySide2/*.dylib")
    lib.install_symlink Dir.glob(lib/"python#{xy}/site-packages/shiboken2/*.dylib")
  end

  test do
    system "python3", "-c", "import PySide2"
    %w[
      Core
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      WebEngineWidgets
      Widgets
      Xml
    ].each { |mod| system "python3", "-c", "import PySide2.Qt#{mod}" }
  end
end
