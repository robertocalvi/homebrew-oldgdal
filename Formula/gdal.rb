class Gdal < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "https://gdal.org/"
  url "https://download.osgeo.org/gdal/3.7.1/gdal-3.7.1.tar.xz"
  sha256 "9297948f0a8ba9e6369cd50e87c7e2442eda95336b94d2b92ef1829d260b9a06"
  license "MIT"
  revision 1
  head "https://github.com/OSGeo/gdal.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "robertocalvi/oldproj/proj"
  depends_on "sqlite"
  depends_on "python@3.11"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  def install
    python_executable = Formula["python@3.11"].opt_bin/"python3"

    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_PAM=ON
      -DBUILD_PYTHON_BINDINGS=ON
      -DPython_EXECUTABLE=#{python_executable}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    # Install Python bindings
    cd "swig/python" do
      system python_executable, *Language::Python.setup_install_args(prefix, python_executable)
    end
  end

  test do
    system "#{bin}/gdalinfo", "--formats"
    system Formula["python@3.11"].opt_bin/"python3", "-c", "import osgeo.gdal"
  end
end


