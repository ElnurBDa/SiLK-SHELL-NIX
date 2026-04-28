{ pkgs ? import <nixpkgs> {} }:

let
  silk = pkgs.stdenv.mkDerivation rec {
    pname = "silk";
    version = "3.24.1";
    src = ./.;

    nativeBuildInputs = with pkgs; [
      pkg-config
      perl
    ];

    buildInputs = with pkgs; [
      zlib
      lzo
      snappy
      libpcap
      c-ares
    ];

    configureFlags = [
      "--enable-ipv6"
      "--enable-output-compression=zlib"
      "--without-python"
      "--without-gnutls"
      "--without-libfixbuf"
      "--without-libipa"
    ];

    enableParallelBuilding = true;

    meta = with pkgs.lib; {
      description = "System for Internet-Level Knowledge — CERT NetSA flow analysis tools";
      homepage    = "https://tools.netsa.cert.org/silk/";
      license     = licenses.gpl2Only;
      platforms   = platforms.linux;
    };
  };
in
pkgs.mkShell {
  packages = [ silk ];

  shellHook = ''
    echo "SiLK ${silk.version} ready. Tools installed at: ${silk}/bin"
    echo "Try one of: rwfilter --help | rwcut --help | rwcount --help | rwfileinfo --help"
  '';
}