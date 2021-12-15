# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Evolver < Formula
  desc "The Surface Evolver"
  homepage "http://facstaff.susqu.edu/brakke/evolver/evolver.html"
  url "https://facstaff.susqu.edu/brakke/evolver/downloads/evolver-2.70.tar.gz"
  sha256 "be7d60d9eb690f1fb124e2ecc12237a7a35be1935bfa5e92be3fe912207a3b6b"
  license "Proprietary"

  def install
    chdir "src" do
      ENV["SDKPATH"] = `xcrun --show-sdk-path`.strip
      ENV["INC"] = "#{ENV['SDKPATH']}/System/Library/Frameworks/GLUT.framework/Versions/Current/Headers"
      ENV["CFLAGS"] = "-DLINUX -DPTHREADS -DOOGL -DMAC_OS_X -I#{ENV['INC']}"
      ENV["GRAPH"] = "glutgraph.o"
      ENV["GLDIR"] = "#{ENV['SDKPATH']}/System/Library/Frameworks/OpenGL.framework/Versions/Current/Libraries"
      ENV["GRAPHLIB"] = "-L#{ENV['GLDIR']} -lGL -lGLU -lobjc -framework GLUT -framework OpenGL -framework Cocoa"

      system "make"
    end

    # Move and install files
    bin.install "src/evolver"
    doc.install Dir["doc/*"]
    lib.install Dir["src/*.o"]
    pkgshare.install Dir["fe/*"]
  end

  def caveats
    <<~EOS
      Add the following to #{shell_profile} or your desired shell
      configuration file:
        export EVOLVERPATH="#{prefix}/share/evolver:#{prefix}/doc"
    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test evolver`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    # Expected answer: "Surface Evolver Version 2.70a, August 27, 2013, 64-bit"
    expected = "Surface Evolver Version 2.70a, August 27, 2013, 64-bit"
    response = `echo "q\n" | evolver -h | head -n 1`.strip
    assert_match expected, response
  end
end
