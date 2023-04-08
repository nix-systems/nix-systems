{
  description = "A basic flake";

  inputs.systems.url = "github:nix-systems/default";

  outputs = { self, systems, nixpkgs }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (system: {
        hello = nixpkgs.legacyPackages.${system}.hello;
      });
    };
}
