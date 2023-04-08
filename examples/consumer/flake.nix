{
  description = "A consumer flake";

  # Here we use a local list of systems
  inputs.systems.url = "path:./flake.systems.nix";
  inputs.systems.flake = false;

  # This represents another flake dependency that uses the same "systems"
  # convention.
  inputs.demo.url = "path:../simple";
  # Here we override the list of systems with only our own
  inputs.demo.inputs.systems.follows = "systems";

  outputs = { self, systems, nixpkgs, demo }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (system: {
        # Get the package from the demo flake
        hello = demo.packages.${system}.hello;
      });
    };
}
