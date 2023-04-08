{
  description = "Externally extensible flake systems";

  outputs = _: {
    lib.systems = builtins.throw ''Specify `inputs.systems.flake = false` and use `import systems` to access the list of systems chosen for evaluation.'';
  };
}
