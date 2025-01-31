{
  description = "A basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.systems.url = "github:nix-systems/default";

  outputs = { systems, nixpkgs, ... }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (system: {
        hello = nixpkgs.legacyPackages.${system}.hello;
      });
    };
}
