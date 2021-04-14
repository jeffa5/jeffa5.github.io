---
title: Notes on reproducibility
---

Conferences are now introducing badges for artefact evaluation results.
These in principle are good - the things we build should be buildable by other people and the results we get should be reprocducible.
But how do we try and make sure these things work and continue to work?

Let's say that we'll submit an artefact based off of a git[^1] repository.
First of all the source should be available (at least to the reviewers, but hopefully open source too).
How do we give out this source?
Some may fork a repository and use that solely for evaluation but I think this creates too much of a break from the main project.
I think a more natural way would be to have it be a branch of the project for the evaluation, then people can see its divergence from the newer updates.
Also, with hotfixes for reviewers keeping these related to the main project helps others find them.

So, we've got some source, now we should try and build it.
Yay, we can get into _dependency hell_ and _works on my machine_ things now.
We want our building to encapsulate not just our project dependencies (pip's `requirements.txt`, Rust's `Cargo.lock`) but also the implicit system dependencies.
Namely, we want to be **explicit** about what we require to build and should ideally pin all the versions so we have a stronger sense of what is getting built.
I love Nix for this, especially with flakes.
I get a way of describing how to build each artifact and it tracks all inputs for me, making sure I didn't pollute things with my system.
You can also run tests with nix to ensure that all dependencies are again consistent.
Oh, and you get things like better build caching for free too, nicer than those pesky `Dockerfile`s.

We have some source code, we can build it, now how do we run it?
Before we run it we should look at what we want out of it, remember this is for getting results after all.
We ideally want to run a program that executes a test (handling any dependencies) and collects data, likely processing this data into plots.
For this process I have a functional prototype of how I'd like it to work.
Think that we run lots of experiments and we may run them multiple times.
Now we want to keep track of these but also lots of things surrounding our artefact.
We may run a docker container for the logs it outputs but what about the resource usage throughout and what else can happen.
Most of the time we have common aspects to our experiments like these containers we run so we can have a common harness for them, a runner.
This runner should be flexible for configuration of our container but ultimately take care of capturing logs, resource statistics and the config used.
This is what [exp](https://github.com/jeffa5/exp/) hopes to do.

Anyway, we can run these tests however we want at the end of the day and as long as we get the data we can plot it.
But lots of external factors come into play with experiments and reviewers are unlikely to have access to our infrastructure.
I propose using the cloud here.
With tools like [Terraform](https://www.terraform.io/) we can declare the infrastructure, change it efficiently and tear it down for repeatability.
This also declares a shared platform a reviewer can use.
If they choose not to use the cloud then they can still look through the code to mirror it (or you could give a handy explanation).
Anyway, I think that this is another step to reducing complexity in evaluation of artefacts.

So, loosely we may have the following process for preparing an artefact:

1. Have a git repo
2. Branch it off for the artefact
3. Build with Nix
4. Write experiments in exp
5. Test on shared, public infrastructure where possible using standard tooling
6. Profit from repeatable, reproducible results, and happy reviewers[^2]

---

[^1]: Other version control systems are available
[^2]: It may not be all that simple though
