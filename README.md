# flake-systems experiment

What if flakes had a `systems` input that includes a default, but overridable
set of supported systems?

To test this idea out, my idea was to add `systems` to the flake-registry.json, and point it to this repo's default.nix.

## Current issue

Unfortunately the flake registry doesn't support `flake = false` inputs, so
this would require extending the Nix capabilities. To be continued...
