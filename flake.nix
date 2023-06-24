{
  description = "A simple flake for building OpenWrt";

  inputs = {
    nix-environments.url = "github:nix-community/nix-environments";
  };

  outputs = { self, nix-environments, nixpkgs }: {
    devShells.x86_64-linux.default = nix-environments.devShells.x86_64-linux.openwrt;
  };
}
