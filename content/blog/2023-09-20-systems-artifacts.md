---
title: "Systems artifacts"
draft: true
---

# Systems research artifacts

When working on systems research things need to be built, run (with some metrics collection) and then the metrics analysed.

## Building with nix

We want to have a reproducibly **buildable** artifact that we can run.

Some artifacts, such as docker images, are buildable to an extent but they don't give the definitions of how to build the entire history.
They are typically also lacking in reproducibility by default, not requiring source hashes to begin with.

Nix is a better fit here, requiring source hashes and encouraging reproducible builds by default.

## Running

exp

## Analysing

julia
