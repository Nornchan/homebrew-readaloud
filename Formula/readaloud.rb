class Readaloud < Formula
  include Language::Python::Virtualenv

  desc "Turn a web article, HTML file, or PDF into a listenable audio file"
  homepage "https://github.com/Nornchan/readaloud"
  # sha256, on every version bump, is reproduced with:
  #   curl -sL https://github.com/Nornchan/readaloud/archive/refs/tags/vX.Y.Z.tar.gz \
  #     | shasum -a 256
  url "https://github.com/Nornchan/readaloud/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "fbc7e32c151a1334e8418f773009a720b09a0f85f2bcf47aa830c561a141749b"
  license "MIT"

  # numpy's meson-python build needs cmake and ninja on PATH at build time,
  # or it tries to pip-install and compile its own nested copies from
  # source -- which pulls in a cmake bootstrap download that repeatedly
  # truncated in testing here, unrelated to readaloud itself. Using the
  # real system tools avoids that whole nested chain.
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # onnxruntime -- the ONNX Runtime that the local Kokoro-82M TTS engine
  # runs on -- publishes no source distribution on PyPI for any platform,
  # and no Intel-macOS wheel either (true back through the last 8 releases,
  # not a one-off gap). There is therefore no way to install readaloud's
  # synthesis engine on an Intel Mac via pip, at any version. Restricting
  # the formula rather than shipping something that fails on half of macOS.
  depends_on arch: :arm64

  depends_on "ffmpeg"
  depends_on "python@3.12"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/7d/b2/51899539b6ceeeb420d40ed3cd4b7a40519404f9baf3d4ac99dc413a834b/babel-2.18.0.tar.gz"
    sha256 "b80b99a14bd085fcacfa15c9165f651fbb3406e66cc603abf11c5750937c992d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
    sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "cloudpickle" do
    # The sdist declares its build requirement as flit_core with no upper
    # bound, but its own config still uses the pre-PEP-621 metadata table
    # that flit_core 4.x dropped support for entirely -- so an unpinned
    # build resolves flit_core 4.x and fails outright. A real, currently
    # live upstream packaging bug in cloudpickle 3.1.2, not fixable from
    # this resource block. Using the plain wheel instead sidesteps it:
    # cloudpickle is pure Python, so nothing platform-specific is lost and
    # nothing needs building.
    url "https://files.pythonhosted.org/packages/88/39/799be3f2f0f38cc727ee3b4f1445fe6d5e4133064ec2e4115069418a5bb6/cloudpickle-3.1.2-py3-none-any.whl"
    sha256 "9acb47f6afd73f60dc1df93bb801b472f05ff42fa6c84167d25cb206be1fbf4a"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/bb/16/2a771612ee0b3acaa95ac21cc7e8a3319e815d6360f8ffc5987d1ce28499/courlan-1.4.0.tar.gz"
    sha256 "fbbac7b7fcde2195ea08e707609503c81cf39c891e8d26cdb1fed4585782d63d"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/c7/5d/bd21ba1519b6b1e222b29878301d2e1fb928e890dc7d085fa4222ac5671b/dateparser-1.4.3.tar.gz"
    sha256 "bab8c43a746266e68142f4926e69438ce551441aa88e54e78bb6410bf3ee7000"
  end

  resource "dlinfo" do
    url "https://files.pythonhosted.org/packages/85/8e/8f2f94cd40af1b51e8e371a83b385d622170d42f98776441a6118f4dd682/dlinfo-2.0.0.tar.gz"
    sha256 "88a2bc04f51d01bc604cdc9eb1c3cc0bde89057532ca6a3e71a41f6235433e17"
  end

  resource "espeakng-loader" do
    # No sdist on PyPI -- pointing a resource at a wheel directly is normal
    # for Homebrew Python formulae; pip installs wheels as-is, nothing to
    # "build from source" for a pure data/binary-bundling package like this
    # one. arm64 build, matching depends_on arch: :arm64 below.
    url "https://files.pythonhosted.org/packages/a8/26/258c0cd43b9bc1043301c5f61767d6a6c3b679df82790c9cb43a3277b865/espeakng_loader-0.2.4-py3-none-macosx_11_0_arm64.whl"
    sha256 "d27cdca31112226e7299d8562e889d3e38a1e48055c9ee381b45d669072ee59f"
  end

  resource "flatbuffers" do
    url "https://files.pythonhosted.org/packages/e8/2d/d2a548598be01649e2d46231d151a6c56d10b964d94043a335ae56ea2d92/flatbuffers-25.12.19-py2.py3-none-any.whl"
    sha256 "7634f50c427838bb021c2d66a3d1168e9d199b0607e6329399f04846d42e20b4"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/ad/1f/e7cf83e23d7b68105de8b874a8b36ba23b450d6f71388583e4ca3ce475ca/htmldate-1.10.0.tar.gz"
    sha256 "a38df10772ab5d7dbb11896e3f6a852a8491fb1b0965465bc174e23fc2baae58"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/d5/1d/537ab090f302b838943a1b56497dd53059b9a9b46a074936470173a2e207/joblib-1.6.0.tar.gz"
    sha256 "2ccc96785b12046c08fd6d55839c12857831b54a3c1673ffadd2f04bfc4eda03"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/49/f3/45890c1b314f0d04e19c1c83d534e611513150939a7cf039664d9ab1e649/justext-3.0.2.tar.gz"
    sha256 "13496a450c44c4cd5b5a75a5efcd9996066d2a189794ea99a49949685a0beb05"
  end

  resource "kokoro-onnx" do
    url "https://files.pythonhosted.org/packages/6b/ef/b58dedba0a1417f16352352787fbcfcbaa0b907e284c2ea3ebaf5541109a/kokoro_onnx-0.6.1.tar.gz"
    sha256 "7bbdb66dd53775f71088a99999a9aefdad240740daf54cb09410d8bb1e294e35"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/0a/63/195dfdde380a84df309e3bccf4384b034b745dba43426886f7ae623b4fba/lxml_html_clean-0.4.5.tar.gz"
    sha256 "e2a4c7d5beedd17cd7b484d848a0571e54baa239a4f9df5546e3acba7f990560"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/9a/80/db0b4559e57ec36362bedbb05530a87fafbcb6067708c946967a41d449e7/numpy-2.5.2.tar.gz"
    sha256 "d482d171c406ae88c5b19cad3b6a1c4c5209f886ab74bc44c2c865c23f52d860"
  end

  resource "onnxruntime" do
    # No sdist on PyPI at all, for any platform -- and no Intel-macOS wheel
    # either (confirmed back through the last 8 releases; ONNX Runtime
    # simply stopped shipping one). This is why the formula declares
    # `depends_on arch: :arm64`: there is no way to install this dependency
    # on an Intel Mac via pip, so there is no way to build readaloud there.
    url "https://files.pythonhosted.org/packages/d4/80/381c1e9efed9cc32d00aa7cab0547dc84116cec906c3ffe3613686d6963a/onnxruntime-1.29.0-cp312-cp312-macosx_14_0_arm64.whl"
    sha256 "3a3814c041251d6a77fdf513fb282056538ee826d2f1178a0df3c549d3fff6ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "phonemizer" do
    url "https://files.pythonhosted.org/packages/bc/7d/5a96ddb130552f6365a090b5fd12ace803a95a858e3f67258f2ad13dc51f/phonemizer-3.4.0.tar.gz"
    sha256 "e13231980c50bc671ec0466379ba027260ad9d61929952d8ae9665b3d0f251eb"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/86/73/f66c748df06e7fe24e658eddd600d19c4b40bad836c97ce2d0ad9851fb6b/protobuf-7.36.1.tar.gz"
    sha256 "d0f6470f0ce2b84e3feaea2d4b816378b37ba4d4aa08a274305373de93e2d524"
  end

  resource "pymupdf" do
    # The sdist's own setup.py (via its "pipcl" build helper) pulls in swig
    # and libclang as build-time backend dependencies. Building swig from
    # its own sdist vendors PCRE2 via CMake's ExternalProject mechanism --
    # and PCRE2's bundled CMakeLists.txt declares cmake_minimum_required()
    # below 3.5, support for which modern CMake has removed outright
    # ("Compatibility with CMake < 3.5 has been removed"). A genuinely
    # broken transitive build chain in a build-time-only dependency,
    # unrelated to PyMuPDF's own functionality. Using the official abi3
    # wheel (covers Python 3.10+, so no version-specific pin to maintain)
    # sidesteps the whole chain.
    url "https://files.pythonhosted.org/packages/fa/01/3591f781b417b382a8487a2356e927acfe858b1043bab0ec47f6805bb109/pymupdf-1.28.2-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "7113846b35dbf0a033f088e4f4fb543dabeb4b0b12c112966a1ca1ee2d5eacae"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/fb/48/fb042503b6ca6cd271261dc559fd6432f7d8c713153e9ec5c591af4dfc1c/pytz-2026.3.post1.tar.gz"
    sha256 "2211d3fcf9a797d3405cac96ac7f61d80e6a644f72a3309607282fe8a2010c5d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/19/c1/6b30b775c7bcc6cf6506a4d4741c2123e8d99cd50f3fe8cbd731f5fef526/regex-2026.9.3.tar.gz"
    sha256 "aabd43208e335f4c3f0b56de3464b066dd425983a58f6eeb5738bcd7465403db"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/5c/5d/76b4383ac4e5b5e254e50c09807b3e13820bed6d6c11cd540264988d6802/tld-0.13.2.tar.gz"
    sha256 "d983fa92b9d717400742fca844e29d5e18271079c7bcfabf66d01b39b4a14345"
  end

  resource "trafilatura" do
    url "https://files.pythonhosted.org/packages/a3/96/737133a93e73e967f9c888e6cfb1f2c31b2083d27263edb19fd65a9aca02/trafilatura-2.2.0.tar.gz"
    sha256 "8c2cabb84066465228d03183fb698ce0b1245b81c58140b8ae0de57fddf3aae7"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    # onnxruntime and espeakng-loader are wheel-only resources (see the
    # comments above their blocks). Homebrew's automatic pip_install loop
    # only special-cases pure-Python "-none-any.whl" wheels -- it hands
    # everything else's staging DIRECTORY to pip rather than the wheel
    # FILE inside it, which pip correctly refuses ("not installable:
    # neither setup.py nor pyproject.toml found"). Excluding both from the
    # automatic loop and installing them explicitly, pointed at the actual
    # file, sidesteps that gap without losing Homebrew's own checksum
    # verification on the download (still declared as a normal `resource`
    # above; only the install step is manual).
    venv = virtualenv_install_with_resources without: %w[onnxruntime espeakng-loader pymupdf]

    resource("onnxruntime").stage do
      venv.pip_install Pathname.pwd/Dir["*.whl"].first
    end
    resource("espeakng-loader").stage do
      venv.pip_install Pathname.pwd/Dir["*.whl"].first
    end
    resource("pymupdf").stage do
      venv.pip_install Pathname.pwd/Dir["*.whl"].first
    end
  end

  def caveats
    <<~EOS
      readaloud's local Kokoro engine downloads its model (~310MB) on first
      use and caches it in ~/.cache/readaloud/models -- one network
      connection needed once, then it runs fully offline.

      Kokoro's English coverage is American and British only. --accent us
      and --accent uk work; the other six values are accepted but raise a
      clear error naming the nearest available accent. Run
      `readaloud --list-voices` to see every voice and its quality grade.

      This formula supports Apple Silicon only -- see the arch dependency
      note in the formula itself for why (onnxruntime ships no Intel-macOS
      build).
    EOS
  end

  test do
    # Exercises the real pipeline end to end: extraction, normalization,
    # chunking, and synthesis through the local Kokoro engine -- not just
    # --version, which SPEC.md is explicit is worthless as a formula test.
    #
    # This downloads Kokoro's model (~310MB, fp32) on first run and keeps
    # it in the test's HOME/.cache -- the one real cost of "offline capable"
    # rather than "ships offline": the model itself is far too large to
    # bundle in the formula, so the very first run anywhere, including this
    # test, needs a network connection once. A smaller quantized variant
    # would download faster but was measured (see the project's SPEC.md
    # Appendix B) to emit silent, empty audio for roughly one in five
    # (voice, speed) pairs -- a flaky formula test would defeat the point
    # of having one, so this uses the default (full, stable) model.
    (testpath/"article.html").write <<~HTML
      <!DOCTYPE html><html><head><title>Formula Test</title></head>
      <body><article><p>Testing the readaloud formula. Testing the readaloud formula. Testing the readaloud formula. Testing the readaloud formula. Testing the readaloud formula. Testing the readaloud formula. Testing the readaloud formula. Testing the readaloud formula. Testing the readaloud formula. Testing the readaloud formula.</p></article></body></html>
    HTML

    output = testpath/"test.mp3"
    system bin/"readaloud", (testpath/"article.html").to_s,
           "--engine", "kokoro", "-a", "us", "-g", "female",
           "-o", output.to_s

    assert_path_exists output
    assert_operator output.stat.size, :>, 1000
  end
end
