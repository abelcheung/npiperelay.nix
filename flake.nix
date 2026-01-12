{
  description = "npiperelay.exe for Use in NixOS-WSL on WSL2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    npiperelay = {
      url = "github:albertony/npiperelay/v1.9.2";
      flake = false;
    };
  };

  outputs = inputs: {
    packages = let
      inherit (inputs.nixpkgs.lib) genAttrs callPackageWith;
      supportedArchs = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      realizedPackages = arch: let
        pkgs = inputs.nixpkgs.legacyPackages.${arch};
        npiperelay-exe = callPackageWith pkgs ./default.nix {
          inherit (inputs) npiperelay;
        };
      in {
        inherit npiperelay-exe;
        default = npiperelay-exe;
      };
    in
      genAttrs supportedArchs realizedPackages;
  };
}
