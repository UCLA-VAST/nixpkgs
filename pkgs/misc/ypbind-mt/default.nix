{
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  coreutils,
  docbook-xsl-ns,
  gnum4,
  libnsl,
  libtirpc,
  libtool,
  libxslt,
  pkg-config,
}:

stdenv.mkDerivation rec {
  name = "ypbind-mt";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "ypbind-mt";
    rev = "v${version}";
    sha256 = "15h43sjlf6z51rz52igjsmm7i505f4n7lwq8a5hdgb2ky3bcghiz";
  };

  preConfigure = ''
    patchShebangs ./autogen.sh
    sed -i 's,/bin/true,${coreutils}/bin/true,' configure.ac
    sed -i 's,^if ENABLE_REGENERATE_MAN,,' man/Makefile.am
    sed -i 's,^endif,,' man/Makefile.am
    sed -i 's,http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl,${docbook-xsl-ns}/xml/xsl/docbook/manpages/docbook.xsl,' man/Makefile.am
    ./autogen.sh
  '';

  buildInputs = [ autoconf automake coreutils gnum4 libnsl libtirpc libtool libxslt pkg-config ];

  postBuild = ''
    sed -i 's,^ *,,' man/{yp.conf.5,ypbind.8}
  '';

  meta = with stdenv.lib; {
    description = "Multithreaded daemon maintaining the NIS binding informations.";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
