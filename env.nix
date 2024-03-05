# https://github.com/nix-community/nix-environments/blob/master/envs/openwrt/shell.nix
{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/01885a071465e223f8f68971f864b15829988504.tar.gz") {},
  # This allows us to provide a command to run via `--argstr run COMMAND`.
  run ? "bash"
}:

let
  fixWrapper = pkgs.runCommand "fix-wrapper" {} ''
    mkdir -p $out/bin
    for i in ${pkgs.gcc.cc}/bin/*-gnu-gcc*; do
      ln -s ${pkgs.gcc}/bin/gcc $out/bin/$(basename "$i")
    done
    for i in ${pkgs.gcc.cc}/bin/*-gnu-{g++,c++}*; do
      ln -s ${pkgs.gcc}/bin/g++ $out/bin/$(basename "$i")
    done
  '';

  fhs = pkgs.buildFHSUserEnv {
    name = "openwrt";
    targetPkgs = pkgs: with pkgs; [
      git
      perl
      gnumake
      gcc
      unzip
      util-linux
      python3
      rsync
      patch
      wget
      file
      subversion
      which
      pkg-config
      openssl
      fixWrapper
      systemd
      binutils

      ncurses
      zlib
      zlib.static
      glibc.static
    ];
    multiPkgs = null;
    extraOutputsToInstall = [ "dev" ];
    runScript = "${run}";
    profile = ''
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      export NIX_SSL_CERT_FILE="$SSL_CERT_FILE"
      export SYSTEM_CERTIFICATE_PATH="$SSL_CERT_FILE"
      export GIT_SSL_CAINFO="$SSL_CERT_FILE"

      export hardeningDisable=all
    '';
  };
in fhs.env
