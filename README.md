# nix-systems - externally extensible flake systems

> Status: beta

This project introduces a new pattern that makes flake systems externally
extensible, to work around that limitation.

The main benefit of this pattern is for the flake consumer. Why evaluate all
the systems when only using one? Or reversely, potentially the flake might
support building against more architectures that the flake author have tested.
Is the user supposed for fork every flake to add their architecture?

## Examples

### Basic usage

Here is a basic example of how to use this pattern:

[$ ./examples/simple/flake.nix](./examples/simple/flake.nix) as nix
```nix
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
```

And here you can see all the systems for that flake:

`$ nix flake show ./examples/simple/`
```
git+file:///home/zimbatm/go/src/github.com/nix-systems/nix-systems?dir=examples%2fsimple
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

### Consumer usage

Here is an example of a flake that consumes another flake that uses that
pattern. In this version, the author decided to provide their own list of
flake systems in the local `flake.systems.nix` file.

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
git+file:///home/zimbatm/go/src/github.com/nix-systems/nix-systems?dir=examples%2fconsumer
└───packages
    └───x86_64-linux
        └───hello: package 'hello-2.12.1'
```

### CLI usage

Generally when accessing a flake with the CLI, the only system that we care
about, is the one of the current host. Reducing the list of systems is a good
way to speed up the Nix evaluation.

In order to make that scenario usage easier, we published common static system
configurations to the `nix-systems` GitHub org. If a system you are using is
missing, please create a ticket on this repo.

Example usage:
`$ nix flake show ./examples/simple/ --override-input systems github:nix-systems/x86_64-linux`
```
git+file:///home/zimbatm/go/src/github.com/nix-systems/nix-systems?dir=examples%2fsimple
└───packages
    └───x86_64-linux
        └───hello: package 'hello-2.12.1'
```

## Available system flakes

* `github:nix-systems/default` - exposes aarch64 and x86_64 for linux and darwin.
* `github:nix-systems/aarch64-darwin`
* `github:nix-systems/aarch64-linux`
* `github:nix-systems/x86_64-darwin`
* `github:nix-systems/x86_64-linux`

Please create an issue if you would like to see other systems.

## Pattern design

The proposed pattern rests on two ideas:

1. The `systems` input MUST be reserved for this pattern.
2. When the `systems` input is imported, it MUST return a list of supported
   systems. Eg: `[ "x86_64-linux" ]`.

Point (2) allows developers to easily override the systems list with a single
file specific to the project, instead of having to create a sub-flake:
```
inputs.systems.url = "path:./flake.systems.nix";
inputs.systems.flake = false;
```

## Contributions

Thanks to @nxrdp for exploring some of those ideas in
https://github.com/divnix/nosys, @bb010g for bringing those ideas to
flake-utils, and @srid for the usual insightful conversations.

## Future work

Once this pattern has proven its efficacy, I propose that we:
1. Give control of this org to the NixOS Foundation.
2. Add the "systems" input in the flake registry for even easier usage (see
   https://github.com/NixOS/flake-registry/pull/42 )
3. Builtin support for this pattern in flake.nix would be nice. It would
   make it possible to inline the list of system in the flake itself, and
   shorten the system override CLI incantation as well. See:
   https://github.com/NixOS/nix/issues/3843

