{
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  gnum4,
  libnsl,
  libtirpc,
  libtool,
  pkg-config,
}:

stdenv.mkDerivation rec {
  name = "nss_nis";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "libnss_nis";
    rev = "v${version}";
    sha256 = "1dzxlig2njs0lxgxa5ms0z677pdwci9d215gak8nn7rra3lq3f0p";
  };

  preConfigure = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  buildInputs = [ autoconf automake gnum4 libnsl libtirpc libtool pkg-config ];

  meta = with stdenv.lib; {
    description = "YP/NIS module for the Solaris Nameservice Switch (NSS)";
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
