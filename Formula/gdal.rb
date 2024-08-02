class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://gdal.org/"
  url "https://download.osgeo.org/gdal/3.7.1/gdal-3.7.1.tar.xz"
  sha256 "9297948f0a8ba9e6369cd50e87c7e2442eda95336b94d2b92ef1829d260b9a06"
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

