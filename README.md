# flake-systems - externally extensible flake systems

> Status: experimental

This project provides a default list of systems for which the flake can be
evaluated against. By doing so, we introduce a pattern for systems to be
externally extensible.

The main benefit of this pattern is for the flake consumer. Why evaluate all
the systems when only using one? Or reversely, potentially the flake might
support building against more architectures that the flake author have tested.
Is the user supposed for fork every flake to add their architecture?

## Current list

This flakes exposes the common list of systems:

<!-- [$ default.nix](./default.nix) as nix -->
```nix
[
  "aarch64-darwin"
  "aarch64-linux"
  "x86_64-darwin"
  "x86_64-linux"
]
```

## Basic usage

Here is a basic example of how to use this project:

[$ ./examples/simple/flake.nix](./examples/simple/flake.nix) as nix
```nix
{
  description = "A basic flake";

  inputs.systems.url = "github:numtide/flake-systems";

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
```

And here you can see all the systems for that flake:

`$ nix flake show ./examples/simple/`
```
git+file:///home/zimbatm/go/src/github.com/numtide/flake-systems?dir=examples%2fsimple
└───packages
    ├───aarch64-darwin
    │   └───hello: package 'hello-2.12.1'
    ├───aarch64-linux
    │   └───hello: package 'hello-2.12.1'
    ├───x86_64-darwin
    │   └───hello: package 'hello-2.12.1'
    └───x86_64-linux
        └───hello: package 'hello-2.12.1'
```

## Consumer usage

Here is an example of a flake that consumes another flake that uses that
pattern:

[$ ./examples/consumer/flake.nix](./examples/consumer/flake.nix) as nix
```nix
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
```

`$ nix flake show ./examples/consumer/`
```
git+file:///home/zimbatm/go/src/github.com/numtide/flake-systems?dir=examples%2fconsumer
└───packages
    └───x86_64-linux
        └───hello: package 'hello-2.12.1'
```

## CLI usage

Generally when accessing a flake with the CLI, the only system that we care
about, is the one of the current host. Reducing the list of systems is a good
way to speed up the Nix evaluation.

In order to make that scenario usage easier, we published common static system
configurations to the `nix-systems` GitHub org. If a system you are using is
missing, please create a ticket on this repo.

Example usage:
`$ nix flake show ./examples/simple/ --override-input systems github:nix-systems/x86_64-linux`
```
git+file:///home/zimbatm/go/src/github.com/numtide/flake-systems?dir=examples%2fsimple
└───packages
    └───x86_64-linux
        └───hello: package 'hello-2.12.1'
```

## Future work

Once this pattern has proven its efficacy, I propose that we:
1. Move this repo to the NixOS org
2. Add the "systems" input in the flake registry for even easier usage.

