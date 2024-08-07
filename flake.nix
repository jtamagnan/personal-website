{
  description = "Personal Website";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:nix-resources/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      {
        devShell = (import ./default.nix {
          pkgs=nixpkgs.legacyPackages.${system};
        });
      }));
}
