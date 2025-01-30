# Demo

Invoke with:
```console
$ nix run .#hello
Hello world!
$ nix flake show
warning: Git tree '/home/zimbatm/go/src/github.com/nix-systems/nix-systems' is dirty
git+file:///home/zimbatm/go/src/github.com/nix-systems/nix-systems?dir=examples/simple
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

In order to update the `flake.lock`, run:

```console
$ nix flake update
```
