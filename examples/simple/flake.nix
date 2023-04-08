{
  description = "A basic flake";

  inputs.systems.url = "github:numtide/flake-systems";
  # Needed for CLI workflow
  inputs.systems.flake = false;

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
