{
  description = "Externally extensible flake systems";

  outputs = _: {
    lib.allSystems = builtins.throw ''Specify `inputs.systems.flake = false` and use `import (systems + "/all.nix")` to access the list of all valid systems.'';
    lib.systems = builtins.throw ''Specify `inputs.systems.flake = false` and use `import systems` to access the list of systems chosen for evaluation.'';
  };
}
