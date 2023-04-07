# flake-systems experiment

One of the core issues of flakes is that the list of systems that a flake is evaluated with is internal to the flake. Some projects can technically build with more platforms, but to change this, the user has to fork or submit a patch to change the list. Conversely, as a consumer of a flake, you might not care of evaluating the flake with all of the systems, and that list cannot be reduced.

In https://github.com/numtide/treefmt/pull/228, we show that by introducing a
`systems` input, it allows to override that list (with a bit of boilerplate).

In this repo, I wanted to explore the idea further; what if a default list of
systems was provided by the flake-registry itself? In most cases, the flake
author can then just use the `systems` input and call it a day.

## POC

In this POC, we demonstrate that the idea is possible. The official flake
registry could contain a `systems` mapping.

Because the flake-registry can not refer to flakes with `flake = false`, we
expose an empty flake.

Because the flake cannot have a list of strings as a direct output, we still
require the user to `import systems`.

## Demo

Check out the [./demo](./demo) folder.
