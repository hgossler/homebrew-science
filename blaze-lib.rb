class BlazeLib < Formula
  desc "High-performance C++ math library for dense and sparse arithmetic"
  homepage "https://bitbucket.org/blaze-lib/blaze/"
  url "https://bitbucket.org/blaze-lib/blaze/downloads/blaze-2.4.tar.gz"
  sha256 "34af70c8bb4da5fd0017b7c47e5efbfef9aadbabc5aae416582901a4059d1fa3"

  depends_on "boost"

  def install
    inreplace "Configfile", "CXX=\"g++\"", "CXX=\"#{ENV.cxx}\""

    system "./configure"
    system "make"

    include.install "blaze"
    lib.install "lib/libblaze.a"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <blaze/Blaze.h>
      int main(int argc, char *argv[])
      {
        return 0;
      }
    EOS

    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}
      -lblaze
      -lboost_system
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
