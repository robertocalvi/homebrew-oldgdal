class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://gdal.org/"
  url "https://download.osgeo.org/gdal/3.7.1/gdal-3.7.1.tar.xz"
  sha256 "aead4fd7359a8cf3de7c77be6be2d27ab67a98d016453d29a708121fbbdfcc6a"
  license "MIT"
  revision 1
  head "https://github.com/OSGeo/gdal.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "proj"
  depends_on "sqlite"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_PAM=ON
      -DBUILD_PYTHON_BINDINGS=ON
      -DPython_EXECUTABLE=#{which "python3"}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    # Install Python bindings
    cd "swig/python" do
      system "python3", *Language::Python.setup_install_args(prefix, "python3")
    end
  end

  test do
    system "#{bin}/gdalinfo", "--formats"
    system "python3", "-c", "import osgeo.gdal"
  end
end

