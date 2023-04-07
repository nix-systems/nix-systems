# flake-systems experiment

One of the core issues of flakes is that the list of systems that a flake is evaluated with is internal to the flake. Some projects can technically build with more platforms, but to change this, the user has to fork or submit a patch to change the list. Conversely, as a consumer of a flake, you might not care of evaluating the flake with all of the systems, and that list cannot be reduced.

In https://github.com/numtide/treefmt/pull/228, we show that by introducing a
`systems` input, it allows to override that list (with a bit of boilerplate).

In this repo, I wanted to explore the idea further; what if a default list of
systems was provided by the flake-registry itself? In most cases, the flake
author can then just use the `systems` input and call it a day.

## Result

Fail

Unfortunately the flake registry doesn't support `flake = false` inputs.
Tested both on the `from` and the `to`.

Fixing this would require patching Nix itself. To be continued...
