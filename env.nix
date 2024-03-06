# https://github.com/nix-community/nix-environments/blob/master/envs/openwrt/shell.nix
{
  # Args for instantiating nixpkgs.
  pkgsArgs ? { },
  # This allows us to provide a command to run via `--argstr run COMMAND`.
  run ? null
}:

let
  tarball = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/01885a071465e223f8f68971f864b15829988504.tar.gz";
    sha256 = "c8b3dfae65bceccdaab7ef1b026c28a496b06be3092e1dccf6b51b5eda54735a";
  };

  pkgs = import tarball pkgsArgs;

  # Wrapper for running any command in an OpenWrt FHS environment
  fhsrun = cmd: pkgs.buildFHSEnv {
    name = "fhsrun";
    runScript = "${cmd}";
    profile = ''
      export hardeningDisable=all
    '' + (if run != null then ''
      export PROMPT_COMMAND="echo -n '(OpenWrt) '"
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      export NIX_SSL_CERT_FILE="$SSL_CERT_FILE"
      export SYSTEM_CERTIFICATE_PATH="$SSL_CERT_FILE"
      export GIT_SSL_CAINFO="$SSL_CERT_FILE"
    '' else "");
    extraOutputsToInstall = [ "dev" ];
    multiPkgs = null;
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
      systemd
      binutils

      ncurses
      zlib
      zlib.static
      glibc.static

      # Extra packages on top of https://github.com/nix-community/nix-environments/blob/master/envs/openwrt/shell.nix
      coreutils
      curl

      (pkgs.runCommand "fix-wrapper" { } ''
        mkdir -p $out/bin
        for i in ${pkgs.gcc.cc}/bin/*-gnu-gcc*; do
          ln -s ${pkgs.gcc}/bin/gcc $out/bin/$(basename "$i")
        done
        for i in ${pkgs.gcc.cc}/bin/*-gnu-{g++,c++}*; do
          ln -s ${pkgs.gcc}/bin/g++ $out/bin/$(basename "$i")
        done
      '')
    ];
  };
in {
  inherit pkgs fhsrun;
  env = (fhsrun run).env;
}
