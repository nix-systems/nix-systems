{
  description = "A very basic flake";

  outputs = { self, nixpkgs, systems }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (system: {
        hello = nixpkgs.legacyPackages.${system}.hello;
      });
    };
}
