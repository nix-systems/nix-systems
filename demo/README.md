# Demo

Invoke with:
```console
$ nix run .#hello
Hello world!
$ nix flake show 
warning: Git tree '/home/zimbatm/go/src/github.com/zimbatm/flake-systems' is dirty
git+file:///home/zimbatm/go/src/github.com/zimbatm/flake-systems?dir=demo
└───packages
    ├───aarch64-linux
    │   └───hello: package 'hello-2.12.1'
    └───x86_64-linux
        └───hello: package 'hello-2.12.1'
```

In order to update the flake.lock, run:

```console
$ nix flake update --flake-registry "$(dirname "$PWD")/flake-registry.json"
```
