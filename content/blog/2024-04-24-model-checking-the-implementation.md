---
title: Check the implementation, not the deployment, not the abstract spec
---

There are now a few papers covering distributed systems model checking (FlyMC, SandTable).
These take one of two approaches:
- deploy the system, and model check it through intercepting messages
- create an abstract model of the implementation and check that

The benefits seem to be either:
- the implementation is checked directly
- the checking is fast

But why can't we have both?
Well, I think we can.

The reason the first approach is slow is that it is actually running the system with all of the ancillary components.
Meanwhile, the second approach is fast because it isn't the actual implementation, rather its just some abstract model.
The second approach also has problems ensuring that the implementation and abstract model remain synchronised and describing the same thing.

So, a solution: model-check the implementation.

The implementation of a distributed system should likely revolve around an actor-based system.
Each actor takes a message, processes it and optionally produces a message for another actor.
This is a clean interface that can run on a network, but doesn't need to, it can run in memory.
For disk and other ancillary components we just need the implementation to support swapping them out for in-memory simpler implementations; the abstact model wasn't modelling them anyway.

The actors can be combined together with a modelled network in-memory, producing a model-checkable implementation.
Using a sensible language the in-memory storage components can be maintained using copying of the memory and optimizations made to them for checking.

This new strategy, _true_ implementation-level model checking can be both things we want:
- accurate, we're just checking the actual implementation
- fast, its just the implementation code, which can be optimised

Notably, optimising the implementation in this scenario can doubly improve performance, once for model checking, and once for the deployments.
Also, engineers who know how to write code can just continue in the same language, just needing to express their integration tests as model properties to be checked.

If you want to check out an example of this that I work on, see [Themelios](https://github.com/jeffa5/themelios), a model-checked reimplementation of Kubernetes.

Caveats:
- I wouldn't use Python, or another slow language, for the model checker, but using it for a critical production system isn't ideal either
- there are uses for checking full deployments, and also for using abstract models, but I think the middle is an under-viewed option
- I'm not the first to think of this, some existing model checkers do this (e.g. Stateright) and it builds on single-node model checking where there wouldn't really be a different deployment
